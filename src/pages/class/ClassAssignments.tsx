import React from "react";
import { FileText, Calendar, CheckCircle, Plus } from "lucide-react";
import { useTranslation } from "../../hooks/useTranslation";

const ClassAssignments: React.FC = () => {
  const { t } = useTranslation();

  const assignments = [
    {
      id: 1,
      title: "Mathematics Homework Chapter 5",
      subject: "Mathematics",
      dueDate: "2024-11-20",
      submissions: 28,
      total: 32,
      status: "active",
    },
    {
      id: 2,
      title: "Physics Lab Report",
      subject: "Physics",
      dueDate: "2024-11-18",
      submissions: 25,
      total: 32,
      status: "active",
    },
    {
      id: 3,
      title: "Chemistry Quiz",
      subject: "Chemistry",
      dueDate: "2024-11-15",
      submissions: 32,
      total: 32,
      status: "completed",
    },
  ];

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                {t("totalAssignments")}
              </p>
              <p className="text-2xl font-bold text-gray-900 mt-2">12</p>
            </div>
            <FileText className="w-10 h-10 text-blue-500" />
          </div>
        </div>
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">{t("active")}</p>
              <p className="text-2xl font-bold text-gray-900 mt-2">8</p>
            </div>
            <Calendar className="w-10 h-10 text-green-500" />
          </div>
        </div>
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                {t("completed")}
              </p>
              <p className="text-2xl font-bold text-gray-900 mt-2">4</p>
            </div>
            <CheckCircle className="w-10 h-10 text-purple-500" />
          </div>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-sm border border-gray-200">
        <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
          <h3 className="text-lg font-semibold text-gray-900">
            {t("allAssignments")}
          </h3>
          <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>{t("createAssignment")}</span>
          </button>
        </div>
        <div className="divide-y divide-gray-200">
          {assignments.map((assignment) => (
            <div
              key={assignment.id}
              className="px-6 py-4 hover:bg-gray-50 cursor-pointer"
            >
              <div className="flex items-center justify-between">
                <div className="flex-1">
                  <div className="flex items-center space-x-3">
                    <FileText className="w-5 h-5 text-gray-400" />
                    <div>
                      <h4 className="text-sm font-medium text-gray-900">
                        {assignment.title}
                      </h4>
                      <p className="text-sm text-gray-500">
                        {assignment.subject}
                      </p>
                    </div>
                  </div>
                </div>
                <div className="flex items-center space-x-6">
                  <div className="text-right">
                    <p className="text-sm text-gray-500">{t("dueDate")}</p>
                    <p className="text-sm font-medium text-gray-900">
                      {assignment.dueDate}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm text-gray-500">{t("submissions")}</p>
                    <p className="text-sm font-medium text-gray-900">
                      {assignment.submissions}/{assignment.total}
                    </p>
                  </div>
                  <span
                    className={`px-3 py-1 text-xs font-semibold rounded-full ${
                      assignment.status === "completed"
                        ? "bg-green-100 text-green-800"
                        : "bg-blue-100 text-blue-800"
                    }`}
                  >
                    {assignment.status === "completed"
                      ? t("completed")
                      : t("active")}
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ClassAssignments;
