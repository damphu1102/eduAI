import React from "react";
import { NavLink } from "react-router-dom";
import {
  LayoutDashboard,
  Users,
  BookOpen,
  GraduationCap,
  GamepadIcon,
  FileText,
  FolderOpen,
  Trophy,
  UserCheck,
  BarChart3,
  Settings,
  X,
} from "lucide-react";
import { useTranslation } from "../../hooks/useTranslation";

interface SidebarProps {
  isMobileMenuOpen: boolean;
  setIsMobileMenuOpen: (value: boolean) => void;
}

const Sidebar: React.FC<SidebarProps> = ({
  isMobileMenuOpen,
  setIsMobileMenuOpen,
}) => {
  const { t } = useTranslation();

  const menuItems = [
    {
      path: "/curriculum-management",
      icon: BookOpen,
      label: t("curriculumManagement"),
    },
    {
      path: "/course-management",
      icon: GraduationCap,
      label: t("courseManagement"),
    },
    {
      path: "/assignments-games",
      icon: GamepadIcon,
      label: t("assignmentsGames"),
    },
    { path: "/exam-management", icon: FileText, label: t("examManagement") },
    {
      path: "/document-library",
      icon: FolderOpen,
      label: t("documentLibrary"),
    },
    {
      path: "/gamification-grading",
      icon: Trophy,
      label: t("gamificationGrading"),
    },
    { path: "/users-roles", icon: UserCheck, label: t("usersRoles") },
    {
      path: "/analytics-reports",
      icon: BarChart3,
      label: t("analyticsReports"),
    },
    { path: "/settings", icon: Settings, label: t("settings") },
  ];

  return (
    <>
      {/* Mobile Overlay */}
      {isMobileMenuOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={() => setIsMobileMenuOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`fixed left-0 top-0 h-full w-64 bg-white/80 backdrop-blur-sm border-r border-emerald-200 z-50 transform transition-transform duration-300 ease-in-out ${
          isMobileMenuOpen ? "translate-x-0" : "-translate-x-full"
        } lg:translate-x-0`}
      >
        <div className="flex flex-col h-full">
          {/* Logo */}
          <div className="flex items-center justify-between px-6 py-4 border-b border-emerald-200">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-emerald-600 rounded-lg flex items-center justify-center">
                <GraduationCap className="w-5 h-5 text-white" />
              </div>
              <span className="text-xl font-bold text-gray-900">SysEdu AI</span>
            </div>
            {/* Close button for mobile */}
            <button
              onClick={() => setIsMobileMenuOpen(false)}
              className="lg:hidden p-2 text-gray-600 hover:bg-gray-100 rounded-lg"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Navigation */}
          <nav className="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
            {/* Dashboard */}
            <NavLink
              to="/"
              onClick={() => setIsMobileMenuOpen(false)}
              className={({ isActive }) =>
                `flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors duration-200 ${
                  isActive
                    ? "bg-emerald-50 text-emerald-700"
                    : "text-gray-600 hover:bg-emerald-50/50 hover:text-gray-900"
                }`
              }
            >
              <LayoutDashboard className="w-5 h-5 mr-3" />
              {t("dashboard")}
            </NavLink>

            {/* Class Management */}
            <NavLink
              to="/class-management"
              onClick={() => setIsMobileMenuOpen(false)}
              className={({ isActive }) =>
                `flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors duration-200 ${
                  isActive
                    ? "bg-emerald-50 text-emerald-700"
                    : "text-gray-600 hover:bg-emerald-50/50 hover:text-gray-900"
                }`
              }
            >
              <Users className="w-5 h-5 mr-3" />
              {t("classManagement")}
            </NavLink>

            {/* Other menu items */}
            {menuItems.map((item) => (
              <NavLink
                key={item.path}
                to={item.path}
                onClick={() => setIsMobileMenuOpen(false)}
                className={({ isActive }) =>
                  `flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors duration-200 ${
                    isActive
                      ? "bg-emerald-50 text-emerald-700"
                      : "text-gray-600 hover:bg-emerald-50/50 hover:text-gray-900"
                  }`
                }
              >
                <item.icon className="w-5 h-5 mr-3" />
                {item.label}
              </NavLink>
            ))}
          </nav>
        </div>
      </aside>
    </>
  );
};

export default Sidebar;
