import React from "react";
import { Activity, TrendingUp, Users, BookOpen } from "lucide-react";
import { useTranslation } from "../../hooks/useTranslation";

const ClassActivity: React.FC = () => {
  const { t } = useTranslation();

  const activities = [
    {
      id: 1,
      type: "assignment",
      title: "New assignment posted",
      description: "Mathematics homework due next week",
      time: "2 hours ago",
      user: "Dr. Smith",
    },
    {
      id: 2,
      type: "submission",
      title: "Student submitted assignment",
      description: "John Doe submitted Physics Lab Report",
      time: "5 hours ago",
      user: "John Doe",
    },
    {
      id: 3,
      type: "grade",
      title: "Grades published",
      description: "Chemistry Quiz results are now available",
      time: "1 day ago",
      user: "Dr. Brown",
    },
  ];

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white rounded-lg p-4 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">{t("totalActivities")}</p>
              <p className="text-2xl font-bold text-gray-900 mt-1">156</p>
            </div>
            <Activity className="w-8 h-8 text-blue-500" />
          </div>
        </div>
        <div className="bg-white rounded-lg p-4 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">{t("thisWeek")}</p>
              <p className="text-2xl font-bold text-gray-900 mt-1">24</p>
            </div>
            <TrendingUp className="w-8 h-8 text-green-500" />
          </div>
        </div>
        <div className="bg-white rounded-lg p-4 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">{t("activeUsers")}</p>
              <p className="text-2xl font-bold text-gray-900 mt-1">32</p>
            </div>
            <Users className="w-8 h-8 text-purple-500" />
          </div>
        </div>
        <div className="bg-white rounded-lg p-4 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">{t("assignments")}</p>
              <p className="text-2xl font-bold text-gray-900 mt-1">12</p>
            </div>
            <BookOpen className="w-8 h-8 text-orange-500" />
          </div>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-sm border border-gray-200">
        <div className="px-6 py-4 border-b border-gray-200">
          <h3 className="text-lg font-semibold text-gray-900">
            {t("recentActivity")}
          </h3>
        </div>
        <div className="divide-y divide-gray-200">
          {activities.map((activity) => (
            <div key={activity.id} className="px-6 py-4 hover:bg-gray-50">
              <div className="flex items-start space-x-4">
                <div className="flex-shrink-0">
                  <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                    <Activity className="w-5 h-5 text-blue-600" />
                  </div>
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-gray-900">
                    {activity.title}
                  </p>
                  <p className="text-sm text-gray-500">
                    {activity.description}
                  </p>
                  <p className="text-xs text-gray-400 mt-1">
                    {activity.user} • {activity.time}
                  </p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ClassActivity;
