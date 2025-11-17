/**
 * AI Assistant Type Definitions
 *
 * Type definitions for the Homeroom AI Assistant feature that analyzes
 * dashboard data and provides actionable insights using Google Gemini AI.
 */

// ============================================================================
// User and Role Types
// ============================================================================

export type UserRole = "admin" | "teacher" | "academic" | "student" | "parent";

// ============================================================================
// Context JSON Types (Input to Gemini API)
// ============================================================================

export interface RiskyClass {
  name: string;
  absenceRate: number;
  teacher: string;
}

export interface LowHomeworkClass {
  name: string;
  submitRate: number;
}

export interface DashboardDataPayload {
  totalClasses: number;
  activeClasses: number;
  draftClasses: number;
  completedClasses: number;
  riskyClasses?: RiskyClass[];
  lowHomeworkClasses?: LowHomeworkClass[];
  studentsAtRisk?: number;
}

export interface CurrentUser {
  id: number;
  role: UserRole;
  name: string;
}

export interface ContextJSON {
  currentUser: CurrentUser;
  dashboardData: DashboardDataPayload;
}

// ============================================================================
// AI Response Types (Output from Gemini API)
// ============================================================================

export interface AIAction {
  id: string; // snake_case identifier
  label: string; // Display text (Vietnamese)
  target: string; // Frontend route path
  reason: string; // Explanation (Vietnamese)
  priority: 1 | 2 | 3; // 1=high, 2=medium, 3=low
}

export interface AIResponse {
  summary: string; // Vietnamese text, max 120 words
  actions: AIAction[];
}

// ============================================================================
// Dashboard Data Types (Internal Application State)
// ============================================================================

export interface RiskyClassData {
  id: number;
  name: string;
  absenceRate: number;
  teacherId: number;
  teacherName: string;
}

export interface LowHomeworkClassData {
  id: number;
  name: string;
  submitRate: number;
}

export interface DashboardStats {
  totalClasses: number;
  activeClasses: number;
  draftClasses: number;
  completedClasses: number;
}

export interface DashboardData {
  stats: DashboardStats;
  riskyClasses: RiskyClassData[];
  lowHomeworkClasses: LowHomeworkClassData[];
  studentsAtRisk: number;
}

// ============================================================================
// Error Types
// ============================================================================

export type ErrorType =
  | "api_key"
  | "network"
  | "rate_limit"
  | "invalid_response"
  | "timeout";

export interface ErrorState {
  type: ErrorType;
  message: string;
  retryable: boolean;
  retryAfter?: number; // seconds
}

// ============================================================================
// Service Configuration Types
// ============================================================================

export interface GeminiServiceConfig {
  apiKey: string;
  model: string; // "gemini-2.5-flash"
  temperature?: number;
  maxTokens?: number;
}

export interface AIAssistantConfig {
  enabled: boolean;
  useMockData: boolean;
  cacheEnabled: boolean;
  cacheTTL: number; // milliseconds
  maxRetries: number;
  requestTimeout: number; // milliseconds
}

// ============================================================================
// Cache Types
// ============================================================================

export interface CachedInsight {
  data: AIResponse;
  timestamp: number;
  contextHash: string;
}

// ============================================================================
// Component Props Types
// ============================================================================

export interface AIAssistantPanelProps {
  dashboardData: DashboardData;
  isLoading?: boolean;
  onActionClick?: (action: AIAction) => void;
}

export interface AIInsightCardProps {
  summary: string;
  timestamp: Date;
  isExpanded?: boolean;
  onToggle?: () => void;
}

export interface AIActionListProps {
  actions: AIAction[];
  onActionClick: (action: AIAction) => void;
}

// ============================================================================
// Hook Return Types
// ============================================================================

export interface UseAIAssistantReturn {
  insights: AIResponse | null;
  isLoading: boolean;
  error: ErrorState | null;
  refresh: () => Promise<void>;
  executeAction: (action: AIAction) => void;
}

// ============================================================================
// Gemini API Types
// ============================================================================

export interface GeminiRequestPart {
  text: string;
}

export interface GeminiRequestContent {
  parts: GeminiRequestPart[];
}

export interface GeminiGenerationConfig {
  temperature: number;
  maxOutputTokens: number;
  responseMimeType: string;
}

export interface GeminiRequest {
  contents: GeminiRequestContent[];
  generationConfig: GeminiGenerationConfig;
}

export interface GeminiCandidate {
  content: {
    parts: Array<{
      text: string;
    }>;
  };
}

export interface GeminiResponse {
  candidates: GeminiCandidate[];
}

// ============================================================================
// Logging Types
// ============================================================================

export interface AIAssistantLog {
  timestamp: Date;
  userId: number;
  userRole: string;
  requestDuration: number;
  success: boolean;
  errorType?: string;
  actionsTaken?: string[];
}
