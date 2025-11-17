/**
 * Gemini API Service
 *
 * Handles all communication with Google Gemini API for AI-powered
 * dashboard insights and recommendations.
 */

import type {
  ContextJSON,
  AIResponse,
  ErrorState,
  GeminiRequest,
  GeminiResponse,
  GeminiServiceConfig,
} from "../types/ai-assistant.types";

// ============================================================================
// Constants
// ============================================================================

const GEMINI_API_BASE_URL = "https://generativelanguage.googleapis.com/v1beta";
const DEFAULT_MODEL = "gemini-2.0-flash-exp";
const DEFAULT_TEMPERATURE = 0.7;
const DEFAULT_MAX_TOKENS = 1024;
const REQUEST_TIMEOUT = 10000; // 10 seconds
const MAX_RETRY_ATTEMPTS = 2;
const RETRY_DELAY_BASE = 1000; // 1 second

// ============================================================================
// System Prompt
// ============================================================================

const SYSTEM_PROMPT = `You are an AI assistant for an educational management system (SysEdu AI). 
Your role is to analyze dashboard data and provide actionable insights for educational administrators, teachers, and academic staff.

CRITICAL INSTRUCTIONS:
1. Generate a Vietnamese-language summary (max 120 words) based ONLY on the provided data
2. Use a professional and friendly tone
3. Create 3-5 action items with priorities (1=high, 2=medium, 3=low)
4. Each action must include: id (snake_case), label (Vietnamese), target (route path), reason (Vietnamese), priority
5. Base all recommendations on the actual data provided - do not infer or assume
6. Return ONLY valid JSON in this exact format:

{
  "summary": "Vietnamese text summary here...",
  "actions": [
    {
      "id": "action_identifier",
      "label": "Action label in Vietnamese",
      "target": "/route/path",
      "reason": "Explanation in Vietnamese",
      "priority": 1
    }
  ]
}

ROLE-SPECIFIC GUIDELINES:
- admin: System-level recommendations across all classes
- teacher: Recommendations for their specific classes only
- academic: Focus on class quality and academic metrics

PRIORITY GUIDELINES:
- Priority 1 (High): Absence rate > 30% OR homework submit rate < 50%
- Priority 2 (Medium): Moderate issues requiring attention
- Priority 3 (Low): Suggestions for improvement

Do not include any text outside the JSON structure.`;

// ============================================================================
// Service Class
// ============================================================================

class GeminiService {
  private config: GeminiServiceConfig;

  constructor(config?: Partial<GeminiServiceConfig>) {
    const apiKey = config?.apiKey || import.meta.env.VITE_GEMINI_API_KEY || "";
    const model =
      config?.model || import.meta.env.VITE_GEMINI_MODEL || DEFAULT_MODEL;

    this.config = {
      apiKey,
      model,
      temperature: config?.temperature ?? DEFAULT_TEMPERATURE,
      maxTokens: config?.maxTokens ?? DEFAULT_MAX_TOKENS,
    };
  }

  /**
   * Analyze dashboard context and generate AI insights
   */
  async analyzeContext(contextJson: ContextJSON): Promise<AIResponse> {
    if (!this.config.apiKey) {
      throw this.createError(
        "api_key",
        "Gemini API key is not configured. Please add VITE_GEMINI_API_KEY to your .env file.",
        false
      );
    }

    let lastError: Error | null = null;

    // Retry logic with exponential backoff
    for (let attempt = 0; attempt < MAX_RETRY_ATTEMPTS; attempt++) {
      try {
        const response = await this.makeRequest(contextJson);
        return response;
      } catch (error) {
        lastError = error as Error;

        // Don't retry for non-retryable errors
        if (
          error instanceof Error &&
          "retryable" in error &&
          !(error as any).retryable
        ) {
          throw error;
        }

        // Wait before retrying (exponential backoff)
        if (attempt < MAX_RETRY_ATTEMPTS - 1) {
          const delay = RETRY_DELAY_BASE * Math.pow(2, attempt);
          await this.sleep(delay);
        }
      }
    }

    // All retries failed
    throw (
      lastError ||
      new Error("Failed to analyze context after multiple attempts")
    );
  }

  /**
   * Make HTTP request to Gemini API
   */
  private async makeRequest(contextJson: ContextJSON): Promise<AIResponse> {
    const url = `${GEMINI_API_BASE_URL}/models/${this.config.model}:generateContent?key=${this.config.apiKey}`;

    const requestBody: GeminiRequest = {
      contents: [
        {
          parts: [
            {
              text: `${SYSTEM_PROMPT}\n\nContext Data:\n${JSON.stringify(
                contextJson,
                null,
                2
              )}`,
            },
          ],
        },
      ],
      generationConfig: {
        temperature: this.config.temperature!,
        maxOutputTokens: this.config.maxTokens!,
        responseMimeType: "application/json",
      },
    };

    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), REQUEST_TIMEOUT);

      const response = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(requestBody),
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      // Handle HTTP errors
      if (!response.ok) {
        return this.handleHttpError(response);
      }

      // Parse response
      const data: GeminiResponse = await response.json();
      return this.parseGeminiResponse(data);
    } catch (error) {
      return this.handleRequestError(error);
    }
  }

  /**
   * Parse and validate Gemini API response
   */
  private parseGeminiResponse(data: GeminiResponse): AIResponse {
    try {
      // Extract text from response
      if (!data.candidates || data.candidates.length === 0) {
        throw this.createError(
          "invalid_response",
          "No candidates in Gemini response",
          false
        );
      }

      const candidate = data.candidates[0];
      if (
        !candidate.content ||
        !candidate.content.parts ||
        candidate.content.parts.length === 0
      ) {
        throw this.createError(
          "invalid_response",
          "No content parts in Gemini response",
          false
        );
      }

      const textContent = candidate.content.parts[0].text;

      // Parse JSON
      const aiResponse: AIResponse = JSON.parse(textContent);

      // Validate structure
      if (!aiResponse.summary || !Array.isArray(aiResponse.actions)) {
        throw this.createError(
          "invalid_response",
          "Invalid AI response structure: missing summary or actions",
          false
        );
      }

      // Validate actions
      for (const action of aiResponse.actions) {
        if (
          !action.id ||
          !action.label ||
          !action.target ||
          !action.reason ||
          ![1, 2, 3].includes(action.priority)
        ) {
          throw this.createError(
            "invalid_response",
            "Invalid action structure in AI response",
            false
          );
        }
      }

      return aiResponse;
    } catch (error) {
      if (error instanceof SyntaxError) {
        throw this.createError(
          "invalid_response",
          "Failed to parse JSON response from Gemini API",
          false
        );
      }
      throw error;
    }
  }

  /**
   * Handle HTTP error responses
   */
  private handleHttpError(response: Response): never {
    if (response.status === 401 || response.status === 403) {
      throw this.createError(
        "api_key",
        "Invalid or expired Gemini API key",
        false
      );
    }

    if (response.status === 429) {
      // Extract retry-after header if available
      const retryAfter = response.headers.get("retry-after");
      const retrySeconds = retryAfter ? parseInt(retryAfter, 10) : 60;

      throw this.createError(
        "rate_limit",
        `Rate limit exceeded. Please try again in ${retrySeconds} seconds.`,
        true,
        retrySeconds
      );
    }

    if (response.status >= 500) {
      throw this.createError(
        "network",
        `Gemini API server error (${response.status})`,
        true
      );
    }

    throw this.createError(
      "network",
      `HTTP error ${response.status}: ${response.statusText}`,
      true
    );
  }

  /**
   * Handle request errors (network, timeout, etc.)
   */
  private handleRequestError(error: unknown): never {
    if (error instanceof Error) {
      // Timeout error
      if (error.name === "AbortError") {
        throw this.createError(
          "timeout",
          "Request timed out after 10 seconds",
          true
        );
      }

      // Network error
      if (
        error.message.includes("fetch") ||
        error.message.includes("network")
      ) {
        throw this.createError(
          "network",
          "Network error: Unable to reach Gemini API",
          true
        );
      }
    }

    // Unknown error
    throw this.createError(
      "network",
      `Unexpected error: ${
        error instanceof Error ? error.message : "Unknown error"
      }`,
      true
    );
  }

  /**
   * Create structured error object
   */
  private createError(
    type: ErrorState["type"],
    message: string,
    retryable: boolean,
    retryAfter?: number
  ): Error & ErrorState {
    const error = new Error(message) as any;
    error.type = type;
    error.message = message;
    error.retryable = retryable;
    if (retryAfter !== undefined) {
      error.retryAfter = retryAfter;
    }
    return error as Error & ErrorState;
  }

  /**
   * Sleep utility for retry delays
   */
  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  /**
   * Validate API key (optional utility method)
   */
  async validateApiKey(): Promise<boolean> {
    try {
      // Make a minimal request to test the API key
      const testContext: ContextJSON = {
        currentUser: { id: 1, role: "admin", name: "Test" },
        dashboardData: {
          totalClasses: 0,
          activeClasses: 0,
          draftClasses: 0,
          completedClasses: 0,
        },
      };

      await this.analyzeContext(testContext);
      return true;
    } catch (error) {
      if (error instanceof Error && "type" in error && "retryable" in error) {
        return (error as Error & ErrorState).type !== "api_key";
      }
      return false;
    }
  }
}

// ============================================================================
// Export singleton instance
// ============================================================================

export const geminiService = new GeminiService();

// Export class for testing
export { GeminiService };
