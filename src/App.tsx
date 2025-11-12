import React from "react";
import "@radix-ui/themes/styles.css";
import { Theme } from "@radix-ui/themes";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";

import Dashboard from "./pages/Dashboard.tsx";
import ClassManagement from "./pages/ClassManagement.tsx";
import CurriculumManagement from "./pages/CurriculumManagement.tsx";
import CourseManagement from "./pages/CourseManagement.tsx";
import AssignmentsGames from "./pages/AssignmentsGames.tsx";
import ExamManagement from "./pages/ExamManagement.tsx";
import DocumentLibrary from "./pages/DocumentLibrary.tsx";
import GamificationGrading from "./pages/GamificationGrading.tsx";
import UsersRoles from "./pages/UsersRoles.tsx";
import AnalyticsReports from "./pages/AnalyticsReports.tsx";
import Settings from "./pages/Settings.tsx";
import Login from "./pages/Login.tsx";
import NotFound from "./pages/NotFound.tsx";

// Protected Route Component
const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const isAuthenticated = localStorage.getItem("isAuthenticated") === "true";
  return isAuthenticated ? <>{children}</> : <Navigate to="/login" replace />;
};

const App: React.FC = () => {
  return (
    <Theme appearance="inherit" radius="large" scaling="100%">
      <Router>
        <main className="min-h-screen font-inter">
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route
              path="/"
              element={
                <ProtectedRoute>
                  <Dashboard />
                </ProtectedRoute>
              }
            />
            <Route
              path="/class-management"
              element={
                <ProtectedRoute>
                  <ClassManagement />
                </ProtectedRoute>
              }
            />
            <Route
              path="/curriculum-management"
              element={
                <ProtectedRoute>
                  <CurriculumManagement />
                </ProtectedRoute>
              }
            />
            <Route
              path="/course-management"
              element={
                <ProtectedRoute>
                  <CourseManagement />
                </ProtectedRoute>
              }
            />
            <Route
              path="/assignments-games"
              element={
                <ProtectedRoute>
                  <AssignmentsGames />
                </ProtectedRoute>
              }
            />
            <Route
              path="/exam-management"
              element={
                <ProtectedRoute>
                  <ExamManagement />
                </ProtectedRoute>
              }
            />
            <Route
              path="/document-library"
              element={
                <ProtectedRoute>
                  <DocumentLibrary />
                </ProtectedRoute>
              }
            />
            <Route
              path="/gamification-grading"
              element={
                <ProtectedRoute>
                  <GamificationGrading />
                </ProtectedRoute>
              }
            />
            <Route
              path="/users-roles"
              element={
                <ProtectedRoute>
                  <UsersRoles />
                </ProtectedRoute>
              }
            />
            <Route
              path="/analytics-reports"
              element={
                <ProtectedRoute>
                  <AnalyticsReports />
                </ProtectedRoute>
              }
            />
            <Route
              path="/settings"
              element={
                <ProtectedRoute>
                  <Settings />
                </ProtectedRoute>
              }
            />
            <Route path="*" element={<NotFound />} />
          </Routes>
          <ToastContainer
            position="top-right"
            autoClose={3000}
            newestOnTop
            closeOnClick
            pauseOnHover
          />
        </main>
      </Router>
    </Theme>
  );
};

export default App;
