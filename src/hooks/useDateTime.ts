import { useSettings } from "../context/SettingsContext";

export const useDateTime = () => {
  const { timezone, datetimeFormat, getCurrentDateTime } = useSettings();

  const formatDateTime = (date: Date | string): string => {
    const dateObj = typeof date === "string" ? new Date(date) : date;

    const options: Intl.DateTimeFormatOptions = {
      timeZone: timezone,
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
      hour12: datetimeFormat.includes("A"),
    };

    const formatter = new Intl.DateTimeFormat("en-GB", options);
    const parts = formatter.formatToParts(dateObj);

    const getValue = (type: string) =>
      parts.find((p) => p.type === type)?.value || "";

    const day = getValue("day");
    const month = getValue("month");
    const year = getValue("year");
    const hour = getValue("hour");
    const minute = getValue("minute");
    const second = getValue("second");
    const dayPeriod = getValue("dayPeriod");

    let formatted = datetimeFormat
      .replace("DD", day)
      .replace("MM", month)
      .replace("YYYY", year)
      .replace("HH", hour)
      .replace("hh", hour)
      .replace("mm", minute)
      .replace("ss", second);

    if (datetimeFormat.includes("A")) {
      formatted = formatted.replace("A", dayPeriod);
    }

    return formatted;
  };

  return {
    formatDateTime,
    getCurrentDateTime,
    timezone,
    datetimeFormat,
  };
};
