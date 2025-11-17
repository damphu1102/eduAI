import React, { useState } from "react";
import Layout from "../components/layout/Layout";
import Breadcrumb from "../components/common/Breadcrumb";
import { User, Bell, Lock, Globe, Palette, Database } from "lucide-react";
import { useSettings, type Language } from "../context/SettingsContext";
import { timezones } from "../utils/timezones";
import { toast } from "react-toastify";
import { useTranslation } from "../hooks/useTranslation";

const Settings: React.FC = () => {
  const [activeTab, setActiveTab] = useState("profile");
  const { t } = useTranslation();
  const { language, timezone, setLanguage, setTimezone, formatDateTime } =
    useSettings();

  // Local state for temporary changes
  const [tempLanguage, setTempLanguage] = useState<Language>(language);
  const [tempTimezone, setTempTimezone] = useState(timezone);

  const languageOptions = [
    { value: "en", label: "English (Anh)" },
    { value: "vi", label: "Tiếng Việt (Việt)" },
    { value: "zh", label: "中文 (Trung)" },
    { value: "ko", label: "한국어 (Hàn)" },
    { value: "ja", label: "日本語 (Nhật)" },
  ];

  const handleSaveLanguageSettings = () => {
    setLanguage(tempLanguage);
    setTimezone(tempTimezone);
    toast.success(t("settingsSaved"));
  };

  const tabs = [
    { id: "profile", label: t("profile"), icon: User },
    { id: "notifications", label: t("notifications"), icon: Bell },
    { id: "security", label: t("security"), icon: Lock },
    { id: "language", label: t("languageRegion"), icon: Globe },
    { id: "appearance", label: t("appearance"), icon: Palette },
    { id: "data", label: t("dataPrivacy"), icon: Database },
  ];

  return (
    <Layout hideBreadcrumb>
      <div className="space-y-6">
        {/* Breadcrumb */}
        <Breadcrumb
          items={[
            { label: t("dashboard"), path: "/" },
            { label: t("settings") },
          ]}
        />
        <div>
          <h1 className="text-2xl font-bold text-gray-900">{t("settings")}</h1>
          <p className="text-gray-600 mt-1">{t("manageSettings")}</p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          {/* Sidebar */}
          <div className="lg:col-span-1">
            <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-2">
              {tabs.map((tab) => {
                const Icon = tab.icon;
                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`w-full flex items-center space-x-3 px-4 py-3 rounded-lg text-left transition-colors ${
                      activeTab === tab.id
                        ? "bg-blue-50 text-blue-600"
                        : "text-gray-700 hover:bg-gray-50"
                    }`}
                  >
                    <Icon className="w-5 h-5" />
                    <span className="font-medium">{tab.label}</span>
                  </button>
                );
              })}
            </div>
          </div>

          {/* Content */}
          <div className="lg:col-span-3">
            <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
              {activeTab === "profile" && (
                <div className="space-y-6">
                  <h2 className="text-xl font-semibold text-gray-900">
                    {t("profileSettings")}
                  </h2>

                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("fullName")}
                      </label>
                      <input
                        type="text"
                        defaultValue="Admin User"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("emailAddress")}
                      </label>
                      <input
                        type="email"
                        defaultValue="admin@sysedu.ai"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("phoneNumber")}
                      </label>
                      <input
                        type="tel"
                        defaultValue="+84 123 456 789"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("bio")}
                      </label>
                      <textarea
                        rows={4}
                        defaultValue="Education system administrator"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>

                    <button className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                      {t("saveChanges")}
                    </button>
                  </div>
                </div>
              )}

              {activeTab === "notifications" && (
                <div className="space-y-6">
                  <h2 className="text-xl font-semibold text-gray-900">
                    {t("notificationPreferences")}
                  </h2>

                  <div className="space-y-4">
                    {[
                      {
                        label: t("emailNotifications"),
                        description: t("emailNotificationsDesc"),
                      },
                      {
                        label: t("pushNotifications"),
                        description: t("pushNotificationsDesc"),
                      },
                      {
                        label: t("smsNotifications"),
                        description: t("smsNotificationsDesc"),
                      },
                      {
                        label: t("weeklyReports"),
                        description: t("weeklyReportsDesc"),
                      },
                    ].map((item, index) => (
                      <div
                        key={index}
                        className="flex items-center justify-between py-3 border-b border-gray-200"
                      >
                        <div>
                          <p className="font-medium text-gray-900">
                            {item.label}
                          </p>
                          <p className="text-sm text-gray-600">
                            {item.description}
                          </p>
                        </div>
                        <label className="relative inline-flex items-center cursor-pointer">
                          <input
                            type="checkbox"
                            defaultChecked
                            className="sr-only peer"
                          />
                          <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                        </label>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {activeTab === "security" && (
                <div className="space-y-6">
                  <h2 className="text-xl font-semibold text-gray-900">
                    {t("securitySettings")}
                  </h2>

                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("currentPassword")}
                      </label>
                      <input
                        type="password"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("newPassword")}
                      </label>
                      <input
                        type="password"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("confirmNewPassword")}
                      </label>
                      <input
                        type="password"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>

                    <button className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                      {t("updatePassword")}
                    </button>

                    <div className="pt-6 border-t border-gray-200">
                      <h3 className="font-semibold text-gray-900 mb-4">
                        {t("twoFactorAuth")}
                      </h3>
                      <p className="text-sm text-gray-600 mb-4">
                        {t("twoFactorAuthDesc")}
                      </p>
                      <button className="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                        {t("enable2FA")}
                      </button>
                    </div>
                  </div>
                </div>
              )}

              {activeTab === "language" && (
                <div className="space-y-6">
                  <h2 className="text-xl font-semibold text-gray-900">
                    {t("languageRegion")}
                  </h2>

                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("language")}
                      </label>
                      <select
                        value={tempLanguage}
                        onChange={(e) =>
                          setTempLanguage(e.target.value as Language)
                        }
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      >
                        {languageOptions.map((lang) => (
                          <option key={lang.value} value={lang.value}>
                            {lang.label}
                          </option>
                        ))}
                      </select>
                      <p className="text-xs text-gray-500 mt-1">
                        {t("languageDesc")}
                      </p>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("timeZone")}
                      </label>
                      <select
                        value={tempTimezone}
                        onChange={(e) => setTempTimezone(e.target.value)}
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      >
                        {timezones.map((tz) => (
                          <option key={tz.value} value={tz.value}>
                            {tz.offset} - {tz.label}
                          </option>
                        ))}
                      </select>
                      <p className="text-xs text-gray-500 mt-1">
                        {t("timeZoneDesc")}
                      </p>
                    </div>

                    <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
                      <p className="text-sm font-medium text-blue-900 mb-1">
                        {t("preview")}
                      </p>
                      <p className="text-sm text-blue-700">
                        {t("currentTimeInTimezone")}{" "}
                        <span className="font-semibold">
                          {formatDateTime(new Date())}
                        </span>
                      </p>
                      <p className="text-xs text-gray-600 mt-2">
                        {t("datetimeFormatAutoDesc")}
                      </p>
                    </div>

                    <button
                      onClick={handleSaveLanguageSettings}
                      className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                    >
                      {t("saveChanges")}
                    </button>
                  </div>
                </div>
              )}

              {activeTab === "appearance" && (
                <div className="space-y-6">
                  <h2 className="text-xl font-semibold text-gray-900">
                    {t("appearance")}
                  </h2>

                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("theme")}
                      </label>
                      <div className="grid grid-cols-3 gap-4">
                        {[t("light"), t("dark"), t("auto")].map((theme) => (
                          <button
                            key={theme}
                            className="px-4 py-3 border-2 border-gray-300 rounded-lg hover:border-blue-500 transition-colors"
                          >
                            {theme}
                          </button>
                        ))}
                      </div>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        {t("accentColor")}
                      </label>
                      <div className="flex space-x-3">
                        {[
                          "bg-blue-600",
                          "bg-green-600",
                          "bg-purple-600",
                          "bg-orange-600",
                          "bg-pink-600",
                        ].map((color) => (
                          <button
                            key={color}
                            className={`w-10 h-10 rounded-full ${color} hover:ring-4 hover:ring-gray-300 transition-all`}
                          />
                        ))}
                      </div>
                    </div>

                    <button className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                      {t("saveChanges")}
                    </button>
                  </div>
                </div>
              )}

              {activeTab === "data" && (
                <div className="space-y-6">
                  <h2 className="text-xl font-semibold text-gray-900">
                    {t("dataPrivacy")}
                  </h2>

                  <div className="space-y-4">
                    <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
                      <p className="text-sm text-blue-900">
                        {t("privacyMessage")}
                      </p>
                    </div>

                    <div className="space-y-3">
                      <button className="w-full px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors text-left">
                        {t("downloadData")}
                      </button>
                      <button className="w-full px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors text-left">
                        {t("exportAccount")}
                      </button>
                      <button className="w-full px-6 py-3 border border-red-300 text-red-600 rounded-lg hover:bg-red-50 transition-colors text-left">
                        {t("deleteAccount")}
                      </button>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default Settings;
