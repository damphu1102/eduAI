import React from "react";
import Layout from "../components/layout/Layout";
import { useTranslation } from "../hooks/useTranslation";
import ClassList from "./class/ClassList";

const ClassManagement: React.FC = () => {
  const { t } = useTranslation();

  return (
    <Layout>
      <div className="space-y-6">
        {/* Page Header */}
        <div>
          <h1 className="text-2xl font-bold text-gray-900">
            {t("classManagement")}
          </h1>
          <p className="text-gray-600 mt-1">{t("classManagementDesc")}</p>
        </div>

        {/* Class List Content */}
        <ClassList />
      </div>
    </Layout>
  );
};

export default ClassManagement;
