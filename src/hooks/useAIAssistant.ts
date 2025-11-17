/**
 * useAIAssistant Hook
 *
 * Custom React hook for managing AI Assistant state, caching, and actions.
 * Integrates with Gemini API service and React Router for navigation.
 */

import { useState, useEffect, useCallback, useRef } from "react";
import { useNavigate } from "react-router-dom";
import { geminiService } from "../services/geminiService";
import {
  buildContextJSON,
  generateContextHash,
} from "../services/dashboardService";
import type {
  AIResponse,
  AIAction,
  ErrorState,
  DashboardData,
  CurrentUser,
  UseAIAssistantReturn,
  CachedInsight,
} from "../types/ai-assistant.types";

// ============================================================================
// Configuration
// ============================================================================

const CACHE_TTL = 5 * 60 * 1000; // 5 minutes in milliseconds
const DEBOUNCE_DELAY = 500; // 500ms debounce for data updates
const RATE_LIMIT_MAX_REQUESTS = 10; // Max requests per window
const RATE_LIMIT_WINDOW = 60 * 1000; // 1 minute window

// ============================================================================
// In-Memory Cache
// ============================================================================

const insightCache = new Map<string, CachedInsight>();

// ============================================================================
// Rate Limiting
// ============================================================================

const requestTimestamps: number[] = [];

/**
 * Check if rate limit is exceeded
 */
function isRateLimitExceeded(): boolean {
  const now = Date.now();

  // Remove timestamps outside the current window
  while (
    requestTimestamps.length > 0 &&
    requestTimestamps[0] < now - RATE_LIMIT_WINDOW
  ) {
    requestTimestamps.shift();
  }

  // Check if we've exceeded the limit
  return requestTimestamps.length >= RATE_LIMIT_MAX_REQUESTS;
}

/**
 * Record a new request timestamp
 */
function recordRequest(): void {
  requestTimestamps.push(Date.now());
}

/**
 * Get time until rate limit resets
 */
function getTimeUntilReset(): number {
  if (requestTimestamps.length === 0) return 0;

  const oldestRequest = requestTimestamps[0];
  const resetTime = oldestRequest + RATE_LIMIT_WINDOW;
  const now = Date.now();

  return Math.max(0, resetTime - now);
}

/**
 * Get cached insight if valid
 */
function getCachedInsight(contextHash: string): AIResponse | null {
  const cached = insightCache.get(contextHash);
  if (!cached) return null;

  const now = Date.now();
  if (now - cached.timestamp > CACHE_TTL) {
    insightCache.delete(contextHash);
    return null;
  }

  return cached.data;
}

/**
 * Store insight in cache
 */
function setCachedInsight(
  contextHash: string,
  data: AIResponse,
  timestamp: number
): void {
  insightCache.set(contextHash, {
    data,
    timestamp,
    contextHash,
  });
}

/**
 * Clear all cached insights
 */
export function clearInsightCache(): void {
  insightCache.clear();
}

// ============================================================================
// Hook Implementation
// ============================================================================

export function useAIAssistant(
  currentUser: CurrentUser | null,
  dashboardData: DashboardData | null,
  options?: {
    enabled?: boolean;
    autoRefresh?: boolean;
  }
): UseAIAssistantReturn {
  const navigate = useNavigate();

  // State
  const [insights, setInsights] = useState<AIResponse | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<ErrorState | null>(null);

  // Refs for debouncing
  const debounceTimerRef = useRef<NodeJS.Timeout | null>(null);
  const lastContextHashRef = useRef<string>("");

  // Check if feature is enabled
  const isEnabled =
    options?.enabled !== false &&
    import.meta.env.VITE_AI_ASSISTANT_ENABLED !== "false";

  /**
   * Fetch insights from Gemini API
   */
  const fetchInsights = useCallback(
    async (forceRefresh = false) => {
      // Skip if disabled or missing required data
      if (!isEnabled || !currentUser || !dashboardData) {
        return;
      }

      // Check rate limit
      if (isRateLimitExceeded()) {
        const resetTime = getTimeUntilReset();
        const resetSeconds = Math.ceil(resetTime / 1000);
        setError({
          type: "rate_limit",
          message: `Đã vượt quá giới hạn yêu cầu. Vui lòng thử lại sau ${resetSeconds} giây.`,
          retryable: true,
          retryAfter: resetSeconds,
        });
        return;
      }

      try {
        setIsLoading(true);
        setError(null);

        // Build context JSON
        const contextJson = buildContextJSON(currentUser, dashboardData);
        const contextHash = generateContextHash(contextJson);

        // Check cache unless force refresh
        if (!forceRefresh) {
          const cached = getCachedInsight(contextHash);
          if (cached) {
            setInsights(cached);
            setIsLoading(false);
            return;
          }
        }

        // Record request for rate limiting
        recordRequest();

        // Call Gemini API
        const response = await geminiService.analyzeContext(contextJson);

        // Cache the result
        setCachedInsight(contextHash, response, Date.now());

        // Update state
        setInsights(response);
        lastContextHashRef.current = contextHash;
      } catch (err) {
        // Handle errors
        if (err instanceof Error && "type" in err && "retryable" in err) {
          setError(err as Error & ErrorState);
        } else {
          setError({
            type: "network",
            message:
              err instanceof Error ? err.message : "Unknown error occurred",
            retryable: true,
          });
        }
        setInsights(null);
      } finally {
        setIsLoading(false);
      }
    },
    [isEnabled, currentUser, dashboardData]
  );

  /**
   * Debounced fetch to avoid excessive API calls
   */
  const debouncedFetch = useCallback(() => {
    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current);
    }

    debounceTimerRef.current = setTimeout(() => {
      fetchInsights(false);
    }, DEBOUNCE_DELAY);
  }, [fetchInsights]);

  /**
   * Refresh insights (force refresh, bypass cache)
   */
  const refresh = useCallback(async () => {
    await fetchInsights(true);
  }, [fetchInsights]);

  /**
   * Execute an action (navigate to target route)
   */
  const executeAction = useCallback(
    (action: AIAction) => {
      if (!action.target) {
        console.warn("Action has no target route:", action);
        return;
      }

      // Navigate to the target route
      navigate(action.target);

      // Log action execution (optional)
      console.log("AI Action executed:", {
        id: action.id,
        label: action.label,
        target: action.target,
        priority: action.priority,
      });
    },
    [navigate]
  );

  /**
   * Auto-fetch on mount and when dependencies change
   */
  useEffect(() => {
    if (!isEnabled || !currentUser || !dashboardData) {
      return;
    }

    // Generate context hash to detect changes
    const contextJson = buildContextJSON(currentUser, dashboardData);
    const contextHash = generateContextHash(contextJson);

    // Only fetch if context has changed
    if (contextHash !== lastContextHashRef.current) {
      if (options?.autoRefresh !== false) {
        debouncedFetch();
      }
    }

    // Cleanup debounce timer
    return () => {
      if (debounceTimerRef.current) {
        clearTimeout(debounceTimerRef.current);
      }
    };
  }, [
    isEnabled,
    currentUser,
    dashboardData,
    options?.autoRefresh,
    debouncedFetch,
  ]);

  return {
    insights,
    isLoading,
    error,
    refresh,
    executeAction,
  };
}
