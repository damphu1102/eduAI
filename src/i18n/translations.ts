// Import all locales from separate files
import { en } from "./locales/en";
import { vi } from "./locales/vi";
import { zh } from "./locales/zh";
import { ko } from "./locales/ko";
import { ja } from "./locales/ja";

export type TranslationKey = keyof typeof en;

export const translations = {
  en,
  vi,
  zh,
  ko,
  ja,
};
