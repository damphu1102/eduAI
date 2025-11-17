import React from "react";
import { useParams, useNavigate, useSearchParams } from "react-router-dom";
import Layout from "../../components/layout/Layout";
import Breadcrumb from "../../components/common/Breadcrumb";
import { useClass } from "../../hooks/useClasses";
import { useTranslation } from "../../hooks/useTranslation";
import {
  ArrowLeft,
  Edit,
  Calendar,
  MapPin,
  Users,
  BookOpen,
  Clock,
  Globe,
  List,
  Activity,
  CheckSquare,
  FileText,
  BarChart3,
  Bell,
  Award,
  Settings,
} from "lucide-react";
import ClassSchedule from "./ClassSchedule";
import ClassActivity from "./ClassActivity";
import ClassAttendance from "./ClassAttendance";
import ClassAssignments from "./ClassAssignments";
import ClassGrades from "./ClassGrades";
import ClassNotifications from "./ClassNotifications";
import ClassMembers from "./ClassMembers";
import ClassCertificates from "./ClassCertificates";
import ClassSettings from "./ClassSettings";

type TabType =
  | "overview"
  | "schedule"
  | "activity"
  | "attendance"
  | "assignments"
  | "grades"
  | "notifications"
  | "members"
  | "certificates"
  | "settings";

const ClassDetail: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchParams, setSearchParams] = useSearchParams();
  const activeTab = (searchParams.get("tab") as TabType) || "overview";
  const { classData, loading, error } = useClass(Number(id));

  const tabs = [
    { id: "overview", label: t("overview"), icon: List },
    { id: "schedule", label: t("schedule"), icon: Calendar },
    { id: "activity", label: t("activity"), icon: Activity },
    { id: "attendance", label: t("attendance"), icon: CheckSquare },
    { id: "assignments", label: t("assignments"), icon: FileText },
    { id: "grades", label: t("grades"), icon: BarChart3 },
    { id: "notifications", label: t("notifications"), icon: Bell },
    { id: "members", label: t("members"), icon: Users },
    { id: "certificates", label: t("certificates"), icon: Award },
    { id: "settings", label: t("settings"), icon: Settings },
  ];

  const handleTabChange = (tabId: string) => {
    setSearchParams({ tab: tabId });
  };

  if (loading) {
    return (
      <Layout>
        <div className="flex items-center justify-center h-64">
          <div className="text-gray-500">Loading class details...</div>
        </div>
      </Layout>
    );
  }

  if (error || !classData) {
    return (
      <Layout>
        <div className="flex items-center justify-center h-64">
          <div className="text-red-500">
            Error: {error || "Class not found"}
          </div>
        </div>
      </Layout>
    );
  }

  const formatDate = (dateString: string | null) => {
    if (!dateString) return "N/A";
    return new Date(dateString).toLocaleDateString("en-US", {
      year: "numeric",
      month: "long",
      day: "numeric",
    });
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case "overview":
        return renderOverviewContent();
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
        return renderOverviewContent();
    }
  };

  const renderOverviewContent = () => (
    <>
      {/* Main Info Card */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">
          Class Information
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Left Column */}
          <div className="space-y-4">
            <div>
              <label className="text-sm font-medium text-gray-500">
                Description
              </label>
              <p className="mt-1 text-gray-900">
                {classData.description || "No description"}
              </p>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-500">Level</label>
              <div className="mt-1 flex items-center space-x-2">
                <span className="px-3 py-1 text-sm font-semibold rounded-full bg-purple-100 text-purple-800">
                  {classData.level || "N/A"}
                </span>
              </div>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-500">
                Language
              </label>
              <div className="mt-1 flex items-center space-x-2">
                <Globe className="w-4 h-4 text-gray-400" />
                <span className="text-gray-900">
                  {classData.language?.toUpperCase() || "N/A"}
                </span>
              </div>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-500">
                Max Students
              </label>
              <div className="mt-1 flex items-center space-x-2">
                <Users className="w-4 h-4 text-gray-400" />
                <span className="text-gray-900">{classData.max_students}</span>
              </div>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-500">
                Teacher(s)
              </label>
              <div className="mt-1 space-y-2">
                {classData.teachers && classData.teachers.length > 0 ? (
                  classData.teachers.map((teacher) => (
                    <div
                      key={teacher.id}
                      className="flex items-center space-x-2"
                    >
                      <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                        <span className="text-sm font-medium text-blue-600">
                          {teacher.full_name.charAt(0)}
                        </span>
                      </div>
                      <div>
                        <div className="text-sm font-medium text-gray-900">
                          {teacher.full_name}
                        </div>
                        <div className="text-xs text-gray-500">
                          {teacher.email}
                        </div>
                      </div>
                      {teacher.role === "ta" && (
                        <span className="px-2 py-0.5 text-xs bg-gray-100 text-gray-600 rounded">
                          TA
                        </span>
                      )}
                    </div>
                  ))
                ) : (
                  <span className="text-sm text-gray-400 italic">
                    No teacher assigned
                  </span>
                )}
              </div>
            </div>
          </div>

          {/* Right Column */}
          <div className="space-y-4">
            <div>
              <label className="text-sm font-medium text-gray-500">
                Duration
              </label>
              <div className="mt-1 flex items-center space-x-2">
                <Calendar className="w-4 h-4 text-gray-400" />
                <span className="text-gray-900">
                  {formatDate(classData.start_date)} -{" "}
                  {formatDate(classData.end_date)}
                </span>
              </div>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-500">
                Schedule
              </label>
              <div className="mt-1">
                {classData.schedule ? (
                  <div className="space-y-1">
                    {classData.schedule.days && (
                      <div className="flex items-center space-x-2">
                        <Calendar className="w-4 h-4 text-gray-400" />
                        <span className="text-gray-900">
                          {classData.schedule.days.join(", ")}
                        </span>
                      </div>
                    )}
                    {classData.schedule.time && (
                      <div className="flex items-center space-x-2">
                        <Clock className="w-4 h-4 text-gray-400" />
                        <span className="text-gray-900">
                          {classData.schedule.time}
                        </span>
                      </div>
                    )}
                    {classData.schedule.timezone && (
                      <div className="text-sm text-gray-500">
                        Timezone: {classData.schedule.timezone}
                      </div>
                    )}
                  </div>
                ) : (
                  <span className="text-gray-500">No schedule set</span>
                )}
              </div>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-500">Room</label>
              <div className="mt-1 flex items-center space-x-2">
                <MapPin className="w-4 h-4 text-gray-400" />
                <span className="text-gray-900">{classData.room || "TBA"}</span>
              </div>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-500">
                Status
              </label>
              <div className="mt-1">
                <span
                  className={`px-3 py-1 text-sm font-semibold rounded-full ${
                    classData.status === "active"
                      ? "bg-green-100 text-green-800"
                      : classData.status === "draft"
                      ? "bg-gray-100 text-gray-800"
                      : classData.status === "completed"
                      ? "bg-blue-100 text-blue-800"
                      : "bg-red-100 text-red-800"
                  }`}
                >
                  {classData.status}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Additional Info */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Students Card */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Students</h3>
            <Users className="w-5 h-5 text-gray-400" />
          </div>
          <p className="text-3xl font-bold text-gray-900">0</p>
          <p className="text-sm text-gray-500 mt-1">
            of {classData.max_students} max
          </p>
        </div>

        {/* Sessions Card */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Sessions</h3>
            <Calendar className="w-5 h-5 text-gray-400" />
          </div>
          <p className="text-3xl font-bold text-gray-900">0</p>
          <p className="text-sm text-gray-500 mt-1">scheduled</p>
        </div>

        {/* Assignments Card */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Assignments</h3>
            <BookOpen className="w-5 h-5 text-gray-400" />
          </div>
          <p className="text-3xl font-bold text-gray-900">0</p>
          <p className="text-sm text-gray-500 mt-1">active</p>
        </div>
      </div>

      {/* Metadata */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Metadata</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
          <div>
            <span className="text-gray-500">Created:</span>
            <span className="ml-2 text-gray-900">
              {new Date(classData.created_at).toLocaleString()}
            </span>
          </div>
          <div>
            <span className="text-gray-500">Updated:</span>
            <span className="ml-2 text-gray-900">
              {new Date(classData.updated_at).toLocaleString()}
            </span>
          </div>
          <div>
            <span className="text-gray-500">Tenant:</span>
            <span className="ml-2 text-gray-900">
              {classData.tenant_name || `ID: ${classData.tenant_id}`}
            </span>
          </div>
          <div>
            <span className="text-gray-500">Campus ID:</span>
            <span className="ml-2 text-gray-900">
              {classData.campus_id || "N/A"}
            </span>
          </div>
          <div>
            <span className="text-gray-500">Course Blueprint ID:</span>
            <span className="ml-2 text-gray-900">
              {classData.course_blueprint_id || "N/A"}
            </span>
          </div>
        </div>
      </div>
    </>
  );

  return (
    <Layout hideBreadcrumb>
      <div className="space-y-6">
        {/* Breadcrumb Navigation */}
        <Breadcrumb
          items={[
            { label: t("dashboard"), path: "/" },
            { label: t("classManagement"), path: "/class-management" },
            { label: classData.name },
          ]}
        />

        {/* Header */}
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <button
              onClick={() => navigate("/class-management")}
              className="p-2 hover:bg-gray-100 rounded-lg"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">
                {classData.name}
              </h1>
              <p className="text-gray-600 mt-1">
                {classData.code || "No code"}
              </p>
            </div>
          </div>
          <button
            onClick={() => navigate(`/classes/${id}/edit`)}
            className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2"
          >
            <Edit className="w-4 h-4" />
            <span>Edit Class</span>
          </button>
        </div>

        {/* Tab Navigation */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="grid grid-cols-5 md:grid-cols-10 gap-0">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              return (
                <div key={tab.id} className="relative group">
                  <button
                    onClick={() => handleTabChange(tab.id)}
                    className={`w-full flex flex-col md:flex-row items-center justify-center md:space-x-2 px-2 md:px-4 py-3 text-xs md:text-sm font-medium border-b-2 transition-colors ${
                      activeTab === tab.id
                        ? "border-emerald-600 text-emerald-700 bg-emerald-50/50"
                        : "border-transparent text-gray-600 hover:text-gray-900 hover:bg-gray-50"
                    }`}
                  >
                    <Icon className="w-4 h-4 md:w-4 md:h-4" />
                    <span className="mt-1 md:mt-0 text-[10px] md:text-sm truncate max-w-full">
                      {tab.label}
                    </span>
                  </button>
                  {/* Tooltip */}
                  <div className="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 px-3 py-1.5 bg-gray-900 text-white text-xs rounded-lg opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap z-50 shadow-lg">
                    {tab.label}
                    <div className="absolute top-full left-1/2 transform -translate-x-1/2 -mt-1 border-4 border-transparent border-t-gray-900"></div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Tab Content */}
        <div className="space-y-6">{renderTabContent()}</div>
      </div>
    </Layout>
  );
};

export default ClassDetail;
