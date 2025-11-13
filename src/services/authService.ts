import api from "./api";

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface LoginResponse {
  success: boolean;
  message: string;
  data: {
    user: {
      id: number;
      email: string;
      full_name: string;
      role: string;
      created_at: string;
    };
    token: string;
  };
}

export interface RegisterData {
  email: string;
  password: string;
  full_name: string;
  role?: string;
}

export interface RegisterResponse {
  success: boolean;
  message: string;
  data: {
    id: number;
    email: string;
    full_name: string;
    role: string;
  };
}

export interface CurrentUserResponse {
  success: boolean;
  data: {
    id: number;
    email: string;
    full_name: string;
    role: string;
    created_at: string;
  };
}

class AuthService {
  async login(credentials: LoginCredentials): Promise<LoginResponse> {
    const response = await api.post<LoginResponse>("/auth/login", credentials);
    return response.data;
  }

  async register(data: RegisterData): Promise<RegisterResponse> {
    const response = await api.post<RegisterResponse>("/auth/register", data);
    return response.data;
  }

  async getCurrentUser(): Promise<CurrentUserResponse> {
    const response = await api.get<CurrentUserResponse>("/auth/me");
    return response.data;
  }

  logout(): void {
    localStorage.removeItem("authToken");
    localStorage.removeItem("isAuthenticated");
    localStorage.removeItem("userEmail");
    localStorage.removeItem("userRole");
    localStorage.removeItem("userName");
  }
}

export default new AuthService();
