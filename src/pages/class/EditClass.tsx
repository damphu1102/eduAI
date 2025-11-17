import React, { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import Layout from "../../components/layout/Layout";
import Breadcrumb from "../../components/common/Breadcrumb";
import ClassForm from "../../components/class/ClassForm";
import { useClass } from "../../hooks/useClasses";
import { classService } from "../../services/classService";
import { ArrowLeft } from "lucide-react";
import { useTranslation } from "../../hooks/useTranslation";

const EditClass: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { t } = useTranslation();
  const { classData, loading: loadingClass, error } = useClass(Number(id));
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (data: any) => {
    try {
      setLoading(true);
      const { teacher_ids, ...classData } = data;

      // Update class first
      await classService.update(Number(id), classData);

      // Update teachers assignment
      if (teacher_ids !== undefined) {
        await classService.assignTeachers(Number(id), teacher_ids);
      }

      alert("Class updated successfully!");
      navigate(`/classes/${id}`);
    } catch (error: any) {
      console.error("Update class error:", error);
      alert(error.response?.data?.message || "Failed to update class");
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = () => {
    navigate(`/classes/${id}`);
  };

  if (loadingClass) {
    return (
      <Layout>
        <div className="flex items-center justify-center h-64">
          <div className="text-gray-500">Loading class...</div>
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

  return (
    <Layout hideBreadcrumb>
      <div className="space-y-6">
        {/* Breadcrumb */}
        <Breadcrumb
          items={[
            { label: t("dashboard"), path: "/" },
            { label: t("classManagement"), path: "/class-management" },
            { label: classData.name, path: `/classes/${id}` },
            { label: t("edit") },
          ]}
        />

        <div className="flex items-center space-x-4">
          <button
            onClick={() => navigate(`/classes/${id}`)}
            className="p-2 hover:bg-gray-100 rounded-lg"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {t("edit")} {classData.name}
            </h1>
            <p className="text-gray-600 mt-1">{classData.code || "No code"}</p>
          </div>
        </div>

        <ClassForm
          initialData={classData}
          onSubmit={handleSubmit}
          onCancel={handleCancel}
          loading={loading}
        />
      </div>
    </Layout>
  );
};

export default EditClass;
