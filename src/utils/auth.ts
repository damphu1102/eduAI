import { STORAGE_KEYS } from "./constants";

export const isAuthenticated = (): boolean => {
  return localStorage.getItem(STORAGE_KEYS.IS_AUTHENTICATED) === "true";
};

export const setAuthToken = (email: string): void => {
  localStorage.setItem(STORAGE_KEYS.IS_AUTHENTICATED, "true");
  localStorage.setItem(STORAGE_KEYS.USER_EMAIL, email);
};

export const clearAuthToken = (): void => {
  localStorage.removeItem(STORAGE_KEYS.IS_AUTHENTICATED);
  localStorage.removeItem(STORAGE_KEYS.USER_EMAIL);
};

export const getUserEmail = (): string | null => {
  return localStorage.getItem(STORAGE_KEYS.USER_EMAIL);
};
