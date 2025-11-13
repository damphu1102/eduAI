import React, { createContext, useContext, useState } from "react";

export type Language = "en" | "vi" | "zh" | "ko" | "ja";

export interface SettingsContextType {
  language: Language;
  timezone: string;
  setLanguage: (lang: Language) => void;
  setTimezone: (tz: string) => void;
  getCurrentDateTime: () => string;
  getCurrentDateTimeWithWeekday: () => string;
  formatDateTime: (date: Date) => string;
  getWeekday: (date: Date) => string;
}

const SettingsContext = createContext<SettingsContextType | undefined>(
  undefined
);

export const SettingsProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [language, setLanguageState] = useState<Language>(() => {
    return (localStorage.getItem("language") as Language) || "en";
  });

  const [timezone, setTimezoneState] = useState<string>(() => {
    return localStorage.getItem("timezone") || "Asia/Ho_Chi_Minh";
  });

  const setLanguage = (lang: Language) => {
    setLanguageState(lang);
    localStorage.setItem("language", lang);
  };

  const setTimezone = (tz: string) => {
    setTimezoneState(tz);
    localStorage.setItem("timezone", tz);
  };

  // Helper function to get locale based on selected language
  const getLocaleForLanguage = (): string => {
    const localeMap: Record<Language, string> = {
      en: "en-US",
      vi: "vi-VN",
      zh: "zh-CN",
      ko: "ko-KR",
      ja: "ja-JP",
    };
    return localeMap[language];
  };

  const formatDateTime = (date: Date): string => {
    const locale = getLocaleForLanguage();
    const options: Intl.DateTimeFormatOptions = {
      timeZone: timezone,
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
      hour12: language === "en", // 12-hour format only for English
    };

    return new Intl.DateTimeFormat(locale, options).format(date);
  };

  const getWeekday = (date: Date): string => {
    const locale = getLocaleForLanguage();
    const options: Intl.DateTimeFormatOptions = {
      timeZone: timezone,
      weekday: "long", // Full weekday name
    };

    return new Intl.DateTimeFormat(locale, options).format(date);
  };

  const getCurrentDateTime = (): string => {
    return formatDateTime(new Date());
  };

  const getCurrentDateTimeWithWeekday = (): string => {
    const now = new Date();
    const weekday = getWeekday(now);
    const datetime = formatDateTime(now);
    return `${weekday}, ${datetime}`;
  };

  return (
    <SettingsContext.Provider
      value={{
        language,
        timezone,
        setLanguage,
        setTimezone,
        getCurrentDateTime,
        getCurrentDateTimeWithWeekday,
        formatDateTime,
        getWeekday,
      }}
    >
      {children}
    </SettingsContext.Provider>
  );
};

export const useSettings = () => {
  const context = useContext(SettingsContext);
  if (!context) {
    throw new Error("useSettings must be used within SettingsProvider");
  }
  return context;
};
