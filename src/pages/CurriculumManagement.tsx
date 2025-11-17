import React from "react";
import Layout from "../components/layout/Layout";
import Breadcrumb from "../components/common/Breadcrumb";
import { Plus, Edit, Trash2, BookOpen, GraduationCap } from "lucide-react";
import { useTranslation } from "../hooks/useTranslation";

const CurriculumManagement: React.FC = () => {
  const { t } = useTranslation();

  const curricula = [
    {
      id: 1,
      name: "STEM Program",
      subjects: 8,
      gradeLevel: "Grade 9-12",
      status: t("published"),
      lastUpdated: "2024-01-15",
    },
    {
      id: 2,
      name: "Liberal Arts",
      subjects: 12,
      gradeLevel: "Grade 10-12",
      status: t("draft"),
      lastUpdated: "2024-01-10",
    },
    {
      id: 3,
      name: "Advanced Mathematics",
      subjects: 6,
      gradeLevel: "Grade 11-12",
      status: t("published"),
      lastUpdated: "2024-01-08",
    },
    {
      id: 4,
      name: "Science Foundation",
      subjects: 10,
      gradeLevel: "Grade 6-9",
      status: t("published"),
      lastUpdated: "2024-01-05",
    },
    {
      id: 5,
      name: "Language Arts",
      subjects: 7,
      gradeLevel: "Grade 6-12",
      status: t("review"),
      lastUpdated: "2024-01-03",
    },
  ];

  return (
    <Layout hideBreadcrumb>
      <div className="space-y-6">
        {/* Breadcrumb */}
        <Breadcrumb
          items={[
            { label: t("dashboard"), path: "/" },
            { label: t("curriculumManagement") },
          ]}
        />

        {/* Page Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {t("curriculumManagementTitle")}
            </h1>
            <p className="text-gray-600 mt-1">
              {t("curriculumManagementDesc")}
            </p>
          </div>
          <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>{t("createCurriculum")}</span>
          </button>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("totalPrograms")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">15</p>
              </div>
              <div className="w-12 h-12 bg-blue-500 rounded-lg flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("published")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">12</p>
              </div>
              <div className="w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center">
                <GraduationCap className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("inReview")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">2</p>
              </div>
              <div className="w-12 h-12 bg-orange-500 rounded-lg flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("draft")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">1</p>
              </div>
              <div className="w-12 h-12 bg-gray-500 rounded-lg flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
        </div>

        {/* Curriculum Table */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900">
              {t("allCurricula")}
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("programName")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("subjects")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("gradeLevel")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("status")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("lastUpdated")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("actions")}
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {curricula.map((curriculum) => (
                  <tr key={curriculum.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm font-medium text-gray-900">
                        {curriculum.name}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {curriculum.subjects} {t("subjects")}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {curriculum.gradeLevel}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          curriculum.status === t("published")
                            ? "bg-green-100 text-green-800"
                            : curriculum.status === t("draft")
                            ? "bg-gray-100 text-gray-800"
                            : "bg-orange-100 text-orange-800"
                        }`}
                      >
                        {curriculum.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {curriculum.lastUpdated}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <div className="flex space-x-2">
                        <button className="text-blue-600 hover:text-blue-900">
                          <Edit className="w-4 h-4" />
                        </button>
                        <button className="text-red-600 hover:text-red-900">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default CurriculumManagement;
