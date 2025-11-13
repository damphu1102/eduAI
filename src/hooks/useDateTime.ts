import { useSettings } from "../context/SettingsContext";

export const useDateTime = () => {
  const {
    timezone,
    getCurrentDateTime,
    formatDateTime: formatDateTimeFromContext,
  } = useSettings();

  const formatDateTime = (date: Date | string): string => {
    const dateObj = typeof date === "string" ? new Date(date) : date;
    return formatDateTimeFromContext(dateObj);
  };

  return {
    formatDateTime,
    getCurrentDateTime,
    timezone,
  };
};
