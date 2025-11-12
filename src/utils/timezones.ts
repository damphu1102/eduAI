export interface TimezoneOption {
  value: string;
  label: string;
  offset: string;
}

export const timezones: TimezoneOption[] = [
  // Asia
  {
    value: "Asia/Ho_Chi_Minh",
    label: "Hồ Chí Minh (Vietnam)",
    offset: "UTC+7",
  },
  { value: "Asia/Bangkok", label: "Bangkok (Thailand)", offset: "UTC+7" },
  { value: "Asia/Jakarta", label: "Jakarta (Indonesia)", offset: "UTC+7" },
  { value: "Asia/Shanghai", label: "上海 (China)", offset: "UTC+8" },
  { value: "Asia/Hong_Kong", label: "Hong Kong", offset: "UTC+8" },
  { value: "Asia/Singapore", label: "Singapore", offset: "UTC+8" },
  { value: "Asia/Taipei", label: "Taipei (Taiwan)", offset: "UTC+8" },
  { value: "Asia/Seoul", label: "서울 (South Korea)", offset: "UTC+9" },
  { value: "Asia/Tokyo", label: "東京 (Japan)", offset: "UTC+9" },
  {
    value: "Asia/Pyongyang",
    label: "Pyongyang (North Korea)",
    offset: "UTC+9",
  },
  { value: "Asia/Dubai", label: "Dubai (UAE)", offset: "UTC+4" },
  { value: "Asia/Kolkata", label: "Kolkata (India)", offset: "UTC+5:30" },

  // Europe
  { value: "Europe/London", label: "London (UK)", offset: "UTC+0" },
  { value: "Europe/Paris", label: "Paris (France)", offset: "UTC+1" },
  { value: "Europe/Berlin", label: "Berlin (Germany)", offset: "UTC+1" },
  { value: "Europe/Rome", label: "Rome (Italy)", offset: "UTC+1" },
  { value: "Europe/Madrid", label: "Madrid (Spain)", offset: "UTC+1" },
  { value: "Europe/Moscow", label: "Moscow (Russia)", offset: "UTC+3" },

  // Americas
  { value: "America/New_York", label: "New York (USA)", offset: "UTC-5" },
  { value: "America/Chicago", label: "Chicago (USA)", offset: "UTC-6" },
  { value: "America/Denver", label: "Denver (USA)", offset: "UTC-7" },
  { value: "America/Los_Angeles", label: "Los Angeles (USA)", offset: "UTC-8" },
  { value: "America/Toronto", label: "Toronto (Canada)", offset: "UTC-5" },
  { value: "America/Vancouver", label: "Vancouver (Canada)", offset: "UTC-8" },
  {
    value: "America/Mexico_City",
    label: "Mexico City (Mexico)",
    offset: "UTC-6",
  },
  { value: "America/Sao_Paulo", label: "São Paulo (Brazil)", offset: "UTC-3" },
  {
    value: "America/Buenos_Aires",
    label: "Buenos Aires (Argentina)",
    offset: "UTC-3",
  },

  // Oceania
  { value: "Australia/Sydney", label: "Sydney (Australia)", offset: "UTC+10" },
  {
    value: "Australia/Melbourne",
    label: "Melbourne (Australia)",
    offset: "UTC+10",
  },
  { value: "Australia/Perth", label: "Perth (Australia)", offset: "UTC+8" },
  {
    value: "Pacific/Auckland",
    label: "Auckland (New Zealand)",
    offset: "UTC+12",
  },

  // Africa
  { value: "Africa/Cairo", label: "Cairo (Egypt)", offset: "UTC+2" },
  {
    value: "Africa/Johannesburg",
    label: "Johannesburg (South Africa)",
    offset: "UTC+2",
  },
  { value: "Africa/Lagos", label: "Lagos (Nigeria)", offset: "UTC+1" },

  // Middle East
  { value: "Asia/Jerusalem", label: "Jerusalem (Israel)", offset: "UTC+2" },
  { value: "Asia/Riyadh", label: "Riyadh (Saudi Arabia)", offset: "UTC+3" },
  { value: "Asia/Tehran", label: "Tehran (Iran)", offset: "UTC+3:30" },
];
