/**
 * Dashboard Data Service
 *
 * Provides dashboard data aggregation and context JSON building
 * for the AI Assistant feature. Supports both mock and real data modes.
 */

import type {
  ContextJSON,
  CurrentUser,
  DashboardDataPayload,
  DashboardData,
  UserRole,
} from "../types/ai-assistant.types";

// ============================================================================
// Mock Data
// ============================================================================

/**
 * Get mock context JSON for development and testing
 */
export function getMockContextJSON(role: UserRole = "admin"): ContextJSON {
  const mockUsers: Record<UserRole, CurrentUser> = {
    admin: {
      id: 1,
      role: "admin",
      name: "Nguyễn Văn An",
    },
    teacher: {
      id: 2,
      role: "teacher",
      name: "Trần Thị Bình",
    },
    academic: {
      id: 3,
      role: "academic",
      name: "Lê Văn Cường",
    },
    student: {
      id: 4,
      role: "student",
      name: "Phạm Thị Dung",
    },
    parent: {
      id: 5,
      role: "parent",
      name: "Hoàng Văn Em",
    },
  };

  const mockDashboardData: Record<UserRole, DashboardDataPayload> = {
    admin: {
      totalClasses: 24,
      activeClasses: 18,
      draftClasses: 3,
      completedClasses: 3,
      riskyClasses: [
        {
          name: "Lớp Toán 10A1",
          absenceRate: 0.35,
          teacher: "Nguyễn Thị Lan",
        },
        {
          name: "Lớp Văn 11B2",
          absenceRate: 0.42,
          teacher: "Trần Văn Minh",
        },
        {
          name: "Lớp Anh 12C3",
          absenceRate: 0.38,
          teacher: "Lê Thị Hoa",
        },
      ],
      lowHomeworkClasses: [
        {
          name: "Lớp Lý 10B1",
          submitRate: 0.45,
        },
        {
          name: "Lớp Hóa 11A2",
          submitRate: 0.38,
        },
      ],
      studentsAtRisk: 12,
    },
    teacher: {
      totalClasses: 4,
      activeClasses: 3,
      draftClasses: 1,
      completedClasses: 0,
      riskyClasses: [
        {
          name: "Lớp Toán 10A1",
          absenceRate: 0.28,
          teacher: "Trần Thị Bình",
        },
      ],
      lowHomeworkClasses: [
        {
          name: "Lớp Toán 10A1",
          submitRate: 0.62,
        },
      ],
      studentsAtRisk: 3,
    },
    academic: {
      totalClasses: 24,
      activeClasses: 18,
      draftClasses: 3,
      completedClasses: 3,
      riskyClasses: [
        {
          name: "Lớp Toán 10A1",
          absenceRate: 0.35,
          teacher: "Nguyễn Thị Lan",
        },
        {
          name: "Lớp Văn 11B2",
          absenceRate: 0.42,
          teacher: "Trần Văn Minh",
        },
      ],
      lowHomeworkClasses: [
        {
          name: "Lớp Lý 10B1",
          submitRate: 0.45,
        },
      ],
      studentsAtRisk: 8,
    },
    student: {
      totalClasses: 8,
      activeClasses: 8,
      draftClasses: 0,
      completedClasses: 0,
    },
    parent: {
      totalClasses: 8,
      activeClasses: 8,
      draftClasses: 0,
      completedClasses: 0,
    },
  };

  return {
    currentUser: mockUsers[role],
    dashboardData: mockDashboardData[role],
  };
}

// ============================================================================
// Context JSON Builder
// ============================================================================

/**
 * Build context JSON from dashboard data
 * Handles missing optional fields gracefully and supports role-based filtering
 */
export function buildContextJSON(
  currentUser: CurrentUser,
  dashboardData: DashboardData
): ContextJSON {
  const payload: DashboardDataPayload = {
    totalClasses: dashboardData.stats.totalClasses,
    activeClasses: dashboardData.stats.activeClasses,
    draftClasses: dashboardData.stats.draftClasses,
    completedClasses: dashboardData.stats.completedClasses,
  };

  // Add optional fields only if they have data
  if (dashboardData.riskyClasses && dashboardData.riskyClasses.length > 0) {
    payload.riskyClasses = dashboardData.riskyClasses.map((cls) => ({
      name: cls.name,
      absenceRate: cls.absenceRate,
      teacher: cls.teacherName,
    }));
  }

  if (
    dashboardData.lowHomeworkClasses &&
    dashboardData.lowHomeworkClasses.length > 0
  ) {
    payload.lowHomeworkClasses = dashboardData.lowHomeworkClasses.map(
      (cls) => ({
        name: cls.name,
        submitRate: cls.submitRate,
      })
    );
  }

  if (dashboardData.studentsAtRisk !== undefined) {
    payload.studentsAtRisk = dashboardData.studentsAtRisk;
  }

  // Apply role-based filtering
  const filteredPayload = applyRoleBasedFiltering(currentUser.role, payload);

  return {
    currentUser: {
      id: currentUser.id,
      role: currentUser.role,
      name: currentUser.name,
    },
    dashboardData: filteredPayload,
  };
}

/**
 * Apply role-based data filtering
 * Different roles see different levels of detail
 */
function applyRoleBasedFiltering(
  role: UserRole,
  payload: DashboardDataPayload
): DashboardDataPayload {
  // Students and parents see limited data
  if (role === "student" || role === "parent") {
    return {
      totalClasses: payload.totalClasses,
      activeClasses: payload.activeClasses,
      draftClasses: payload.draftClasses,
      completedClasses: payload.completedClasses,
      // No risky classes or at-risk students for these roles
    };
  }

  // Admin, teacher, and academic staff see full data
  return payload;
}

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Check if dashboard data has actionable insights
 */
export function hasActionableInsights(data: DashboardDataPayload): boolean {
  return (
    (data.riskyClasses !== undefined && data.riskyClasses.length > 0) ||
    (data.lowHomeworkClasses !== undefined &&
      data.lowHomeworkClasses.length > 0) ||
    (data.studentsAtRisk !== undefined && data.studentsAtRisk > 0)
  );
}

/**
 * Get priority level based on metrics
 */
export function calculatePriority(
  absenceRate?: number,
  submitRate?: number
): 1 | 2 | 3 {
  // High priority: absence > 30% OR submit < 50%
  if (
    (absenceRate !== undefined && absenceRate > 0.3) ||
    (submitRate !== undefined && submitRate < 0.5)
  ) {
    return 1;
  }

  // Medium priority: absence > 20% OR submit < 70%
  if (
    (absenceRate !== undefined && absenceRate > 0.2) ||
    (submitRate !== undefined && submitRate < 0.7)
  ) {
    return 2;
  }

  // Low priority: everything else
  return 3;
}

/**
 * Generate a hash for context JSON (for caching)
 */
export function generateContextHash(context: ContextJSON): string {
  const str = JSON.stringify(context);
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    hash = (hash << 5) - hash + char;
    hash = hash & hash; // Convert to 32-bit integer
  }
  return Math.abs(hash).toString(36);
}
