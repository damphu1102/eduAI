import React from "react";
import { Award, Download, FileText, Plus } from "lucide-react";
import { useTranslation } from "../../hooks/useTranslation";

const ClassCertificates: React.FC = () => {
  const { t } = useTranslation();

  const certificates = [
    {
      id: 1,
      name: "Course Completion Certificate",
      student: "John Doe",
      course: "Mathematics 10A",
      issueDate: "2024-11-01",
      status: "issued",
    },
    {
      id: 2,
      name: "Excellence Award",
      student: "Jane Smith",
      course: "Physics 11B",
      issueDate: "2024-10-28",
      status: "issued",
    },
    {
      id: 3,
      name: "Participation Certificate",
      student: "Bob Johnson",
      course: "Chemistry 12C",
      issueDate: "2024-10-25",
      status: "pending",
    },
  ];

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                {t("totalIssued")}
              </p>
              <p className="text-2xl font-bold text-gray-900 mt-2">45</p>
            </div>
            <Award className="w-10 h-10 text-blue-500" />
          </div>
        </div>
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                {t("thisMonth")}
              </p>
              <p className="text-2xl font-bold text-gray-900 mt-2">12</p>
            </div>
            <FileText className="w-10 h-10 text-green-500" />
          </div>
        </div>
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                {t("pending")}
              </p>
              <p className="text-2xl font-bold text-gray-900 mt-2">3</p>
            </div>
            <Award className="w-10 h-10 text-yellow-500" />
          </div>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-sm border border-gray-200">
        <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
          <h3 className="text-lg font-semibold text-gray-900">
            {t("allCertificates")}
          </h3>
          <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>{t("issueCertificate")}</span>
          </button>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  {t("certificateName")}
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  {t("student")}
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  {t("course")}
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  {t("issueDate")}
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  {t("status")}
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  {t("actions")}
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {certificates.map((cert) => (
                <tr key={cert.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="flex items-center">
                      <Award className="w-5 h-5 text-blue-500 mr-2" />
                      <span className="text-sm font-medium text-gray-900">
                        {cert.name}
                      </span>
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {cert.student}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {cert.course}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {cert.issueDate}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span
                      className={`px-2 py-1 text-xs font-semibold rounded-full ${
                        cert.status === "issued"
                          ? "bg-green-100 text-green-800"
                          : "bg-yellow-100 text-yellow-800"
                      }`}
                    >
                      {cert.status === "issued" ? t("issued") : t("pending")}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <button className="text-blue-600 hover:text-blue-900">
                      <Download className="w-4 h-4" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default ClassCertificates;
