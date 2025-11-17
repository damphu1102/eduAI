import React from "react";
import Layout from "../components/layout/Layout";
import Breadcrumb from "../components/common/Breadcrumb";
import {
  Plus,
  Edit,
  Trash2,
  GamepadIcon,
  FileText,
  Trophy,
  Target,
} from "lucide-react";
import { useTranslation } from "../hooks/useTranslation";

const AssignmentsGames: React.FC = () => {
  const { t } = useTranslation();

  const assignments = [
    {
      id: 1,
      title: "Math Quiz Chapter 5",
      type: t("quiz"),
      dueDate: "2024-02-15",
      submissions: 28,
      totalStudents: 32,
      avgScore: 85,
    },
    {
      id: 2,
      title: "Physics Lab Report",
      type: t("assignment"),
      dueDate: "2024-02-18",
      submissions: 24,
      totalStudents: 30,
      avgScore: 78,
    },
    {
      id: 3,
      title: "Chemistry Experiment",
      type: t("lab"),
      dueDate: "2024-02-20",
      submissions: 15,
      totalStudents: 25,
      avgScore: 92,
    },
    {
      id: 4,
      title: "Biology Research Project",
      type: t("project"),
      dueDate: "2024-02-25",
      submissions: 8,
      totalStudents: 28,
      avgScore: 88,
    },
  ];

  const games = [
    {
      id: 1,
      title: "Math Adventure",
      subject: "Mathematics",
      players: 156,
      avgScore: 87,
      difficulty: t("medium"),
    },
    {
      id: 2,
      title: "Science Quest",
      subject: "Science",
      players: 203,
      avgScore: 92,
      difficulty: t("hard"),
    },
    {
      id: 3,
      title: "Word Master",
      subject: "English",
      players: 89,
      avgScore: 76,
      difficulty: t("easy"),
    },
    {
      id: 4,
      title: "History Timeline",
      subject: "History",
      players: 134,
      avgScore: 81,
      difficulty: t("medium"),
    },
  ];

  return (
    <Layout hideBreadcrumb>
      <div className="space-y-6">
        {/* Breadcrumb */}
        <Breadcrumb
          items={[
            { label: t("dashboard"), path: "/" },
            { label: t("assignmentsGames") },
          ]}
        />

        {/* Page Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {t("assignmentsGamesTitle")}
            </h1>
            <p className="text-gray-600 mt-1">{t("assignmentsGamesDesc")}</p>
          </div>
          <div className="flex space-x-3">
            <button className="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition-colors flex items-center space-x-2">
              <GamepadIcon className="w-4 h-4" />
              <span>{t("createGame")}</span>
            </button>
            <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2">
              <Plus className="w-4 h-4" />
              <span>{t("createAssignment")}</span>
            </button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("totalAssignments")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">48</p>
              </div>
              <div className="w-12 h-12 bg-blue-500 rounded-lg flex items-center justify-center">
                <FileText className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("activeGames")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">12</p>
              </div>
              <div className="w-12 h-12 bg-purple-500 rounded-lg flex items-center justify-center">
                <GamepadIcon className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("avgScore")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">84%</p>
              </div>
              <div className="w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center">
                <Target className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("completionRateShort")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">92%</p>
              </div>
              <div className="w-12 h-12 bg-orange-500 rounded-lg flex items-center justify-center">
                <Trophy className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
        </div>

        {/* Assignments Section */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900">
              {t("recentAssignmentsTable")}
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("assignmentTitle")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("type")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("dueDate")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("submissions")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("avgScore")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("actions")}
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {assignments.map((assignment) => (
                  <tr key={assignment.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm font-medium text-gray-900">
                        {assignment.title}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">
                        {assignment.type}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {assignment.dueDate}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {assignment.submissions}/{assignment.totalStudents}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {assignment.avgScore}%
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

        {/* Games Section */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900">
              {t("learningGames")}
            </h3>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 p-6">
            {games.map((game) => (
              <div
                key={game.id}
                className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
              >
                <div className="flex items-center justify-between mb-3">
                  <GamepadIcon className="w-8 h-8 text-purple-600" />
                  <span
                    className={`px-2 py-1 text-xs font-semibold rounded-full ${
                      game.difficulty === t("easy")
                        ? "bg-green-100 text-green-800"
                        : game.difficulty === t("medium")
                        ? "bg-yellow-100 text-yellow-800"
                        : "bg-red-100 text-red-800"
                    }`}
                  >
                    {game.difficulty}
                  </span>
                </div>
                <h4 className="text-lg font-semibold text-gray-900 mb-2">
                  {game.title}
                </h4>
                <p className="text-sm text-gray-600 mb-3">{game.subject}</p>
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">{t("players")}:</span>
                    <span className="font-medium">{game.players}</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">{t("avgScore")}:</span>
                    <span className="font-medium">{game.avgScore}%</span>
                  </div>
                </div>
                <button className="w-full mt-4 bg-purple-600 text-white px-3 py-2 rounded-lg hover:bg-purple-700 transition-colors text-sm">
                  {t("viewDetails")}
                </button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default AssignmentsGames;
