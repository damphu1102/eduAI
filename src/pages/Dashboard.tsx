import React from "react";
import Layout from "../components/layout/Layout";
import StatsCard from "../components/features/dashboard/StatsCard";
import { Users, BookOpen, GraduationCap, TrendingUp } from "lucide-react";
import {
  PieChart,
  Pie,
  Cell,
  ResponsiveContainer,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
} from "recharts";

const Dashboard: React.FC = () => {
  const stats = [
    {
      title: "Total Classes",
      value: "24",
      change: "+12% from last month",
      changeType: "increase" as const,
      icon: Users,
      color: "bg-blue-500",
    },
    {
      title: "Total Students",
      value: "1,248",
      change: "+8% from last month",
      changeType: "increase" as const,
      icon: GraduationCap,
      color: "bg-green-500",
    },
    {
      title: "Active Courses",
      value: "156",
      change: "+5% from last month",
      changeType: "increase" as const,
      icon: BookOpen,
      color: "bg-purple-500",
    },
    {
      title: "Completion Rate",
      value: "87%",
      change: "+3% from last month",
      changeType: "increase" as const,
      icon: TrendingUp,
      color: "bg-orange-500",
    },
  ];

  const pieData = [
    { name: "Completed", value: 65, color: "#10B981" },
    { name: "In Progress", value: 25, color: "#3B82F6" },
    { name: "Not Started", value: 10, color: "#EF4444" },
  ];

  const lineData = [
    { name: "Jan", students: 400, courses: 240 },
    { name: "Feb", students: 300, courses: 139 },
    { name: "Mar", students: 200, courses: 980 },
    { name: "Apr", students: 278, courses: 390 },
    { name: "May", students: 189, courses: 480 },
    { name: "Jun", students: 239, courses: 380 },
  ];

  return (
    <Layout>
      <div className="space-y-6">
        {/* Page Header */}
        <div>
          <h1 className="text-xl md:text-2xl font-bold text-gray-900">
            Dashboard Overview
          </h1>
          <p className="text-sm md:text-base text-gray-600 mt-1">
            Welcome back! Here's what's happening with your education system.
          </p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
          {stats.map((stat, index) => (
            <StatsCard key={index} {...stat} />
          ))}
        </div>

        {/* Charts Section */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Course Completion Chart */}
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Course Completion Status
            </h3>
            <div className="h-64">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={pieData}
                    cx="50%"
                    cy="50%"
                    outerRadius={80}
                    dataKey="value"
                  >
                    {pieData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            </div>
            <div className="flex justify-center space-x-4 mt-4">
              {pieData.map((item, index) => (
                <div key={index} className="flex items-center">
                  <div
                    className="w-3 h-3 rounded-full mr-2"
                    style={{ backgroundColor: item.color }}
                  ></div>
                  <span className="text-sm text-gray-600">{item.name}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Growth Trend Chart */}
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Growth Trends
            </h3>
            <div className="h-64">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={lineData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="name" />
                  <YAxis />
                  <Tooltip />
                  <Line
                    type="monotone"
                    dataKey="students"
                    stroke="#3B82F6"
                    strokeWidth={2}
                  />
                  <Line
                    type="monotone"
                    dataKey="courses"
                    stroke="#10B981"
                    strokeWidth={2}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>
        </div>

        {/* Recent Activity */}
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">
            Recent Activity
          </h3>
          <div className="space-y-4">
            {[
              {
                action: "New student enrolled in Mathematics Course",
                time: "2 minutes ago",
                type: "enrollment",
              },
              {
                action: "Assignment submitted by John Doe",
                time: "15 minutes ago",
                type: "submission",
              },
              {
                action: 'New course "Advanced Physics" created',
                time: "1 hour ago",
                type: "course",
              },
              {
                action: "Exam results published for Class 10A",
                time: "2 hours ago",
                type: "exam",
              },
            ].map((activity, index) => (
              <div
                key={index}
                className="flex items-center space-x-3 p-3 hover:bg-gray-50 rounded-lg"
              >
                <div
                  className={`w-2 h-2 rounded-full ${
                    activity.type === "enrollment"
                      ? "bg-green-500"
                      : activity.type === "submission"
                      ? "bg-blue-500"
                      : activity.type === "course"
                      ? "bg-purple-500"
                      : "bg-orange-500"
                  }`}
                ></div>
                <div className="flex-1">
                  <p className="text-sm text-gray-900">{activity.action}</p>
                  <p className="text-xs text-gray-500">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default Dashboard;
