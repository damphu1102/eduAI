// Common types and interfaces
export interface User {
  email: string;
  role: string;
}

export interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
}

export interface StatsCardProps {
  title: string;
  value: string;
  change: string;
  changeType: "increase" | "decrease";
  icon: React.ComponentType<any>;
  color: string;
}

export interface DemoAccount {
  role: string;
  email: string;
  password: string;
}
