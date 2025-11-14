import React, { useEffect } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import Layout from "../components/layout/Layout";
import { useTranslation } from "../hooks/useTranslation";
import ClassList from "./class/ClassList";
import ClassSchedule from "./class/ClassSchedule";
import ClassActivity from "./class/ClassActivity";
import ClassAttendance from "./class/ClassAttendance";
import ClassAssignments from "./class/ClassAssignments";
import ClassGrades from "./class/ClassGrades";
import ClassNotifications from "./class/ClassNotifications";
import ClassMembers from "./class/ClassMembers";
import ClassCertificates from "./class/ClassCertificates";
import ClassSettings from "./class/ClassSettings";

type TabType =
  | "list"
  | "schedule"
  | "activity"
  | "attendance"
  | "assignments"
  | "grades"
  | "notifications"
  | "members"
  | "certificates"
  | "settings";

const ClassManagement: React.FC = () => {
  const { t } = useTranslation();
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const activeTab = (searchParams.get("tab") as TabType) || "list";

  useEffect(() => {
    if (!searchParams.get("tab")) {
      navigate("/class-management?tab=list", { replace: true });
    }
  }, [searchParams, navigate]);

  const getPageTitle = () => {
    switch (activeTab) {
      case "list":
        return t("classList");
      case "schedule":
        return t("classSchedule");
      case "activity":
        return t("classActivity");
      case "attendance":
        return t("attendance");
      case "assignments":
        return t("assignments");
      case "grades":
        return t("grades");
      case "notifications":
        return t("notifications");
      case "members":
        return t("classMembers");
      case "certificates":
        return t("certificates");
      case "settings":
        return t("classSettings");
      default:
        return t("classList");
    }
  };

  const getPageDescription = () => {
    switch (activeTab) {
      case "list":
        return t("classManagementDesc");
      case "schedule":
        return t("classScheduleDesc");
      case "activity":
        return t("classActivityDesc");
      case "attendance":
        return t("attendanceDesc");
      case "assignments":
        return t("assignmentsDesc");
      case "grades":
        return t("gradesDesc");
      case "notifications":
        return t("notificationsDesc");
      case "members":
        return t("classMembersDesc");
      case "certificates":
        return t("certificatesDesc");
      case "settings":
        return t("classSettingsDesc");
      default:
        return t("classManagementDesc");
    }
  };

  const renderContent = () => {
    switch (activeTab) {
      case "list":
        return <ClassList />;
      case "schedule":
        return <ClassSchedule />;
      case "activity":
        return <ClassActivity />;
      case "attendance":
        return <ClassAttendance />;
      case "assignments":
        return <ClassAssignments />;
      case "grades":
        return <ClassGrades />;
      case "notifications":
        return <ClassNotifications />;
      case "members":
        return <ClassMembers />;
      case "certificates":
        return <ClassCertificates />;
      case "settings":
        return <ClassSettings />;
      default:
        return <ClassList />;
    }
  };

  return (
    <Layout>
      <div className="space-y-6">
        {/* Page Header */}
        <div>
          <h1 className="text-2xl font-bold text-gray-900">{getPageTitle()}</h1>
          <p className="text-gray-600 mt-1">{getPageDescription()}</p>
        </div>

        {/* Tab Content */}
        <div>{renderContent()}</div>
      </div>
    </Layout>
  );
};

export default ClassManagement;
