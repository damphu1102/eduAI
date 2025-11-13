import React from "react";
import Layout from "../components/layout/Layout";
import {
  Plus,
  Edit,
  Trash2,
  UserCheck,
  Shield,
  Users,
  Settings,
} from "lucide-react";
import { useTranslation } from "../hooks/useTranslation";

const UsersRoles: React.FC = () => {
  const { t } = useTranslation();

  const users = [
    {
      id: 1,
      name: "John Smith",
      email: "john.smith@school.edu",
      role: t("administrator"),
      status: t("active"),
      lastLogin: "2024-01-15",
    },
    {
      id: 2,
      name: "Sarah Johnson",
      email: "sarah.j@school.edu",
      role: t("teacher"),
      status: t("active"),
      lastLogin: "2024-01-14",
    },
    {
      id: 3,
      name: "Mike Davis",
      email: "mike.davis@school.edu",
      role: t("teacher"),
      status: t("active"),
      lastLogin: "2024-01-13",
    },
    {
      id: 4,
      name: "Emily Brown",
      email: "emily.brown@school.edu",
      role: t("student"),
      status: t("active"),
      lastLogin: "2024-01-15",
    },
    {
      id: 5,
      name: "David Wilson",
      email: "david.w@school.edu",
      role: t("parent"),
      status: t("inactive"),
      lastLogin: "2024-01-10",
    },
  ];

  const roles = [
    {
      id: 1,
      name: t("administrator"),
      users: 3,
      permissions: [t("fullAccess"), t("userManagement"), t("systemSettings")],
    },
    {
      id: 2,
      name: t("teacher"),
      users: 24,
      permissions: [
        t("courseManagement"),
        t("gradeStudents"),
        t("viewReports"),
      ],
    },
    {
      id: 3,
      name: t("student"),
      users: 1248,
      permissions: [t("viewCourses"), t("submitAssignments"), t("takeExams")],
    },
    {
      id: 4,
      name: t("parent"),
      users: 856,
      permissions: [t("viewChildProgress"), t("communication"), t("reports")],
    },
  ];

  return (
    <Layout>
      <div className="space-y-6">
        {/* Page Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {t("usersRolesTitle")}
            </h1>
            <p className="text-gray-600 mt-1">{t("usersRolesDesc")}</p>
          </div>
          <div className="flex space-x-3">
            <button className="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition-colors flex items-center space-x-2">
              <Shield className="w-4 h-4" />
              <span>{t("manageRoles")}</span>
            </button>
            <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2">
              <Plus className="w-4 h-4" />
              <span>{t("addUser")}</span>
            </button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("totalUsers")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">2,131</p>
              </div>
              <div className="w-12 h-12 bg-blue-500 rounded-lg flex items-center justify-center">
                <Users className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("activeUsers")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">2,045</p>
              </div>
              <div className="w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center">
                <UserCheck className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("roles")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">4</p>
              </div>
              <div className="w-12 h-12 bg-purple-500 rounded-lg flex items-center justify-center">
                <Shield className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("pendingInvites")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">12</p>
              </div>
              <div className="w-12 h-12 bg-orange-500 rounded-lg flex items-center justify-center">
                <Settings className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
        </div>

        {/* Users Table */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900">
              {t("allUsers")}
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("user")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("role")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("status")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("lastLogin")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("actions")}
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {users.map((user) => (
                  <tr key={user.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <div className="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center text-white font-semibold">
                          {user.name
                            .split(" ")
                            .map((n) => n[0])
                            .join("")}
                        </div>
                        <div className="ml-4">
                          <div className="text-sm font-medium text-gray-900">
                            {user.name}
                          </div>
                          <div className="text-sm text-gray-500">
                            {user.email}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          user.role === t("administrator")
                            ? "bg-red-100 text-red-800"
                            : user.role === t("teacher")
                            ? "bg-blue-100 text-blue-800"
                            : user.role === t("student")
                            ? "bg-green-100 text-green-800"
                            : "bg-purple-100 text-purple-800"
                        }`}
                      >
                        {user.role}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          user.status === t("active")
                            ? "bg-green-100 text-green-800"
                            : "bg-red-100 text-red-800"
                        }`}
                      >
                        {user.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {user.lastLogin}
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

        {/* Roles Section */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900">
              {t("roleManagement")}
            </h3>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 p-6">
            {roles.map((role) => (
              <div
                key={role.id}
                className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
              >
                <div className="flex items-center justify-between mb-3">
                  <Shield className="w-8 h-8 text-purple-600" />
                  <span className="text-sm text-gray-500">
                    {role.users} {t("users")}
                  </span>
                </div>
                <h4 className="text-lg font-semibold text-gray-900 mb-3">
                  {role.name}
                </h4>
                <div className="space-y-2">
                  <p className="text-sm font-medium text-gray-700">
                    {t("permissions")}:
                  </p>
                  {role.permissions.map((permission, index) => (
                    <div
                      key={index}
                      className="text-xs text-gray-600 bg-gray-50 px-2 py-1 rounded"
                    >
                      {permission}
                    </div>
                  ))}
                </div>
                <button className="w-full mt-4 bg-purple-600 text-white px-3 py-2 rounded-lg hover:bg-purple-700 transition-colors text-sm">
                  {t("editRole")}
                </button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default UsersRoles;
