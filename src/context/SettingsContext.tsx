import React, { createContext, useContext, useState } from "react";

export type Language = "en" | "vi" | "zh" | "ko" | "ja";

export interface SettingsContextType {
  language: Language;
  timezone: string;
  datetimeFormat: string;
  setLanguage: (lang: Language) => void;
  setTimezone: (tz: string) => void;
  setDatetimeFormat: (format: string) => void;
  getCurrentDateTime: () => string;
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

  const [datetimeFormat, setDatetimeFormatState] = useState<string>(() => {
    return localStorage.getItem("datetimeFormat") || "DD/MM/YYYY HH:mm:ss";
  });

  const setLanguage = (lang: Language) => {
    setLanguageState(lang);
    localStorage.setItem("language", lang);
  };

  const setTimezone = (tz: string) => {
    setTimezoneState(tz);
    localStorage.setItem("timezone", tz);
  };

  const setDatetimeFormat = (format: string) => {
    setDatetimeFormatState(format);
    localStorage.setItem("datetimeFormat", format);
  };

  const getCurrentDateTime = (): string => {
    const now = new Date();
    const options: Intl.DateTimeFormatOptions = {
      timeZone: timezone,
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
      hour12: false,
    };

    const formatter = new Intl.DateTimeFormat("en-GB", options);
    const parts = formatter.formatToParts(now);

    const getValue = (type: string) =>
      parts.find((p) => p.type === type)?.value || "";

    const day = getValue("day");
    const month = getValue("month");
    const year = getValue("year");
    const hour = getValue("hour");
    const minute = getValue("minute");
    const second = getValue("second");

    return datetimeFormat
      .replace("DD", day)
      .replace("MM", month)
      .replace("YYYY", year)
      .replace("HH", hour)
      .replace("mm", minute)
      .replace("ss", second);
  };

  return (
    <SettingsContext.Provider
      value={{
        language,
        timezone,
        datetimeFormat,
        setLanguage,
        setTimezone,
        setDatetimeFormat,
        getCurrentDateTime,
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
