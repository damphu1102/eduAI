import api from "./api";
import type {
  ClassListResponse,
  ClassDetailResponse,
  CreateClassRequest,
  ClassStatus,
} from "../types/class.types";

export interface GetClassesParams {
  page?: number;
  limit?: number;
  status?: ClassStatus;
  level?: string;
  language?: string;
  campus_id?: number;
  search?: string;
}

export const classService = {
  /**
   * Get all classes with pagination and filters
   */
  getAll: async (params?: GetClassesParams): Promise<ClassListResponse> => {
    const response = await api.get<ClassListResponse>("/classes", { params });
    return response.data;
  },

  /**
   * Get class by ID
   */
  getById: async (id: number): Promise<ClassDetailResponse> => {
    const response = await api.get<ClassDetailResponse>(`/classes/${id}`);
    return response.data;
  },

  /**
   * Create new class
   */
  create: async (data: CreateClassRequest): Promise<ClassDetailResponse> => {
    const response = await api.post<ClassDetailResponse>("/classes", data);
    return response.data;
  },

  /**
   * Update class
   */
  update: async (
    id: number,
    data: Partial<CreateClassRequest>
  ): Promise<{ success: boolean; message: string }> => {
    const response = await api.put(`/classes/${id}`, data);
    return response.data;
  },

  /**
   * Delete class (soft delete)
   */
  delete: async (
    id: number
  ): Promise<{ success: boolean; message: string }> => {
    const response = await api.delete(`/classes/${id}`);
    return response.data;
  },

  /**
   * Get overall class statistics
   */
  getOverallStats: async (): Promise<{
    success: boolean;
    data: {
      total: number;
      active: number;
      draft: number;
      completed: number;
      cancelled: number;
    };
  }> => {
    const response = await api.get("/classes/stats");
    return response.data;
  },

  /**
   * Get class statistics
   */
  getStats: async (id: number) => {
    const response = await api.get(`/classes/${id}/stats`);
    return response.data;
  },

  /**
   * Get class enrollments
   */
  getEnrollments: async (id: number) => {
    const response = await api.get(`/classes/${id}/enrollments`);
    return response.data;
  },

  /**
   * Get class teachers
   */
  getTeachers: async (id: number) => {
    const response = await api.get(`/classes/${id}/teachers`);
    return response.data;
  },

  /**
   * Get class sessions
   */
  getSessions: async (id: number) => {
    const response = await api.get(`/classes/${id}/sessions`);
    return response.data;
  },

  /**
   * Assign teachers to class
   */
  assignTeachers: async (
    classId: number,
    teacherIds: number[]
  ): Promise<{ success: boolean; message: string }> => {
    const response = await api.post(`/classes/${classId}/teachers`, {
      teacher_ids: teacherIds,
    });
    return response.data;
  },
};
