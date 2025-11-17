import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import Layout from "../../components/layout/Layout";
import ClassForm from "../../components/class/ClassForm";
import { classService } from "../../services/classService";
import { ArrowLeft } from "lucide-react";

const CreateClass: React.FC = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (data: any) => {
    try {
      setLoading(true);
      const { teacher_ids, ...classData } = data;

      // Create class first
      const response = await classService.create(classData);
      const classId = response.data.id;

      // Assign teachers if any selected
      if (teacher_ids && teacher_ids.length > 0) {
        await classService.assignTeachers(classId, teacher_ids);
      }

      alert("Class created successfully!");
      navigate("/class-management?tab=list");
    } catch (error: any) {
      console.error("Create class error:", error);
      alert(error.response?.data?.message || "Failed to create class");
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = () => {
    navigate("/class-management?tab=list");
  };

  return (
    <Layout>
      <div className="space-y-6">
        <div className="flex items-center space-x-4">
          <button
            onClick={() => navigate("/class-management?tab=list")}
            className="p-2 hover:bg-gray-100 rounded-lg"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              Create New Class
            </h1>
            <p className="text-gray-600 mt-1">
              Fill in the details to create a new class
            </p>
          </div>
        </div>

        <ClassForm
          onSubmit={handleSubmit}
          onCancel={handleCancel}
          loading={loading}
        />
      </div>
    </Layout>
  );
};

export default CreateClass;
