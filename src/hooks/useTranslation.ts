import { useSettings } from "../context/SettingsContext";
import { translations, type TranslationKey } from "../i18n/translations";

export const useTranslation = () => {
  const { language } = useSettings();

  const t = (key: TranslationKey): string => {
    return translations[language][key] || translations.en[key] || key;
  };

  return { t, language };
};
