import React, { useState, useEffect } from "react";
import {
  Search,
  Bell,
  User,
  LogOut,
  Menu,
  Clock,
  ChevronRight,
  Home,
} from "lucide-react";
import { useNavigate, useLocation } from "react-router-dom";
import { toast } from "react-toastify";
import { useSettings } from "../../context/SettingsContext";
import { useTranslation } from "../../hooks/useTranslation";

interface HeaderProps {
  isMobileMenuOpen: boolean;
  setIsMobileMenuOpen: (value: boolean) => void;
  hideBreadcrumb?: boolean;
}

const Header: React.FC<HeaderProps> = ({
  isMobileMenuOpen,
  setIsMobileMenuOpen,
  hideBreadcrumb,
}) => {
  const navigate = useNavigate();
  const location = useLocation();
  const [showDropdown, setShowDropdown] = useState(false);
  const { t } = useTranslation();
  const { getCurrentDateTimeWithWeekday } = useSettings();
  const [currentTime, setCurrentTime] = useState(
    getCurrentDateTimeWithWeekday()
  );

  // Generate breadcrumb from current path
  const getBreadcrumbs = () => {
    const pathnames = location.pathname.split("/").filter((x) => x);

    const breadcrumbs = [{ name: t("dashboard"), path: "/" }];

    // Special handling for class routes
    if (pathnames[0] === "classes" && pathnames[1]) {
      breadcrumbs.push({
        name: t("classManagement"),
        path: "/class-management",
      });

      // Get class name from URL state or show ID
      const classId = pathnames[1];
      const className = location.state?.className || `Class ${classId}`;

      if (pathnames[2] === "edit") {
        breadcrumbs.push({
          name: className,
          path: `/classes/${classId}`,
        });
        breadcrumbs.push({
          name: t("edit"),
          path: location.pathname,
        });
      } else {
        breadcrumbs.push({
          name: className,
          path: location.pathname,
        });
      }
      return breadcrumbs;
    }

    // Default handling for other routes
    pathnames.forEach((value, index) => {
      const path = `/${pathnames.slice(0, index + 1).join("/")}`;
      const key = value.replace(/-/g, "_");

      // Try to get translation, fallback to formatted value
      try {
        const name = t(key as any);
        breadcrumbs.push({ name, path });
      } catch {
        // Fallback: capitalize and replace underscores with spaces
        const name = key
          .split("_")
          .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
          .join(" ");
        breadcrumbs.push({ name, path });
      }
    });

    return breadcrumbs;
  };

  const breadcrumbs = getBreadcrumbs();

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(getCurrentDateTimeWithWeekday());
    }, 1000);

    return () => clearInterval(timer);
  }, [getCurrentDateTimeWithWeekday]);

  const handleLogout = () => {
    localStorage.removeItem("isAuthenticated");
    localStorage.removeItem("userEmail");
    toast.info(t("logoutSuccess"));
    navigate("/login");
  };

  return (
    <header className="bg-white/80 backdrop-blur-sm border-b border-emerald-200 px-4 md:px-6 py-4">
      <div className="flex items-center justify-between">
        {/* Left side - Mobile Menu + Search */}
        <div className="flex items-center space-x-3">
          {/* Mobile Menu Button */}
          <button
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            className="lg:hidden p-2 text-gray-600 hover:bg-gray-100 rounded-lg"
          >
            <Menu className="w-6 h-6" />
          </button>

          {/* Search */}
          <div className="relative hidden md:block">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder={t("search")}
              className="pl-10 pr-4 py-2 w-64 lg:w-80 border border-emerald-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent bg-white"
            />
          </div>
        </div>

        {/* Center - Breadcrumb Navigation */}
        {!hideBreadcrumb && (
          <nav className="hidden md:flex items-center space-x-1 md:space-x-2 flex-1 justify-center px-2 md:px-4 overflow-x-auto">
            {breadcrumbs.map((crumb, index) => (
              <React.Fragment key={crumb.path}>
                {index > 0 && (
                  <ChevronRight className="w-3 h-3 md:w-4 md:h-4 text-gray-400 flex-shrink-0" />
                )}
                <button
                  onClick={() => navigate(crumb.path)}
                  className={`flex items-center space-x-1 px-1.5 md:px-2 py-1 rounded-md transition-colors whitespace-nowrap ${
                    index === breadcrumbs.length - 1
                      ? "text-emerald-600 font-medium bg-emerald-50"
                      : "text-gray-600 hover:text-emerald-600 hover:bg-gray-50"
                  }`}
                >
                  {index === 0 && <Home className="w-3 h-3 md:w-4 md:h-4" />}
                  <span className="text-xs md:text-sm">{crumb.name}</span>
                </button>
              </React.Fragment>
            ))}
          </nav>
        )}

        {/* Right side - DateTime, Notifications and User */}
        <div className="flex items-center space-x-2 md:space-x-4">
          {/* DateTime Display - Desktop */}
          <div className="hidden lg:flex items-center space-x-2 px-3 py-1.5 bg-emerald-50 border border-emerald-200 rounded-lg">
            <Clock className="w-4 h-4 text-emerald-600" />
            <span className="text-sm font-medium text-emerald-700">
              {currentTime}
            </span>
          </div>

          {/* DateTime Display - Mobile (Icon with tooltip) */}
          <div className="lg:hidden relative group">
            <button className="p-2 text-emerald-600 hover:text-emerald-700 transition-colors">
              <Clock className="w-5 h-5" />
            </button>
            <div className="absolute right-0 top-full mt-2 px-3 py-2 bg-gray-900 text-white text-xs rounded-lg whitespace-nowrap opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none z-50">
              {currentTime}
            </div>
          </div>

          {/* Mobile Search Button */}
          <button className="md:hidden p-2 text-gray-400 hover:text-gray-600 transition-colors">
            <Search className="w-5 h-5" />
          </button>

          <button className="relative p-2 text-gray-400 hover:text-gray-600 transition-colors">
            <Bell className="w-5 h-5" />
            <span className="absolute -top-1 -right-1 w-3 h-3 bg-red-500 rounded-full"></span>
          </button>

          <div className="relative">
            <button
              onClick={() => setShowDropdown(!showDropdown)}
              className="flex items-center space-x-2 md:space-x-3 hover:opacity-80 transition-opacity"
            >
              <div className="w-8 h-8 bg-emerald-500 rounded-full flex items-center justify-center">
                <User className="w-5 h-5 text-white" />
              </div>
              <div className="text-sm text-left hidden md:block">
                <div className="font-medium text-gray-900">Admin User</div>
                <div className="text-gray-500">{t("administrator")}</div>
              </div>
            </button>

            {/* Dropdown Menu */}
            {showDropdown && (
              <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50">
                <button
                  onClick={handleLogout}
                  className="w-full flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-emerald-50 transition-colors"
                >
                  <LogOut className="w-4 h-4 mr-3" />
                  {t("logout")}
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
