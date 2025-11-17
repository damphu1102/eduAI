export type ClassStatus = "draft" | "active" | "completed" | "cancelled";

export interface ClassSchedule {
  days?: string[];
  time?: string;
  timezone?: string;
  recurrence?: string;
}

export interface ClassTeacher {
  id: number;
  full_name: string;
  email: string;
  role: "teacher" | "ta";
  start_date: string | null;
  end_date: string | null;
}

export interface Class {
  id: number;
  tenant_id: number;
  campus_id: number | null;
  course_blueprint_id: number | null;
  code: string | null;
  name: string;
  description: string | null;
  level: string | null;
  language: string | null;
  max_students: number;
  status: ClassStatus;
  start_date: string | null;
  end_date: string | null;
  schedule: ClassSchedule | null;
  room: string | null;
  created_by: number | null;
  updated_by: number | null;
  created_at: string;
  updated_at: string;
  teachers?: ClassTeacher[];
}

export interface ClassWithStats extends Class {
  enrolled_students?: number;
  teacher_name?: string;
  course_title?: string;
  campus_name?: string;
}

export interface ClassListResponse {
  success: boolean;
  data: {
    classes: Class[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  };
}

export interface ClassDetailResponse {
  success: boolean;
  data: Class;
}

export interface CreateClassRequest {
  name: string;
  description?: string;
  code?: string;
  level?: string;
  language?: string;
  max_students?: number;
  status?: ClassStatus;
  start_date?: string;
  end_date?: string;
  schedule?: ClassSchedule;
  room?: string;
  campus_id?: number;
  course_blueprint_id?: number;
}
