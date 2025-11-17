import api from "./api";

export interface Teacher {
  id: number;
  email: string;
  full_name: string;
  role: string;
}

export const userService = {
  /**
   * Get all teachers
   */
  getTeachers: async (): Promise<{
    success: boolean;
    data: { users: Teacher[] };
  }> => {
    const response = await api.get("/users", {
      params: { role: "teacher", limit: 1000 },
    });
    return response.data;
  },
};
