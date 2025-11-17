import React from "react";
import Layout from "../components/layout/Layout";
import Breadcrumb from "../components/common/Breadcrumb";
import {
  Plus,
  Search,
  Filter,
  Download,
  Edit,
  Trash2,
  FileText,
  File,
  Video,
  Image,
} from "lucide-react";
import { useTranslation } from "../hooks/useTranslation";

const DocumentLibrary: React.FC = () => {
  const { t } = useTranslation();

  const documents = [
    {
      id: 1,
      name: "Mathematics Curriculum Guide.pdf",
      type: "PDF",
      size: "2.4 MB",
      category: t("curriculum"),
      uploadDate: "2024-01-15",
      downloads: 45,
    },
    {
      id: 2,
      name: "Physics Lab Manual.docx",
      type: "Word",
      size: "1.8 MB",
      category: t("labManual"),
      uploadDate: "2024-01-12",
      downloads: 32,
    },
    {
      id: 3,
      name: "Chemistry Experiment Video.mp4",
      type: "Video",
      size: "125 MB",
      category: t("video"),
      uploadDate: "2024-01-10",
      downloads: 78,
    },
    {
      id: 4,
      name: "Biology Diagram.png",
      type: "Image",
      size: "850 KB",
      category: t("image"),
      uploadDate: "2024-01-08",
      downloads: 23,
    },
    {
      id: 5,
      name: "History Timeline.pdf",
      type: "PDF",
      size: "3.2 MB",
      category: t("reference"),
      uploadDate: "2024-01-05",
      downloads: 56,
    },
    {
      id: 6,
      name: "English Grammar Rules.docx",
      type: "Word",
      size: "1.2 MB",
      category: t("reference"),
      uploadDate: "2024-01-03",
      downloads: 67,
    },
  ];

  const categories = [
    t("all"),
    t("curriculum"),
    t("labManual"),
    t("video"),
    t("image"),
    t("reference"),
  ];

  const getFileIcon = (type: string) => {
    switch (type) {
      case "PDF":
        return <FileText className="w-5 h-5 text-red-500" />;
      case "Word":
        return <File className="w-5 h-5 text-blue-500" />;
      case "Video":
        return <Video className="w-5 h-5 text-purple-500" />;
      case "Image":
        return <Image className="w-5 h-5 text-green-500" />;
      default:
        return <File className="w-5 h-5 text-gray-500" />;
    }
  };

  return (
    <Layout hideBreadcrumb>
      <div className="space-y-6">
        {/* Breadcrumb */}
        <Breadcrumb
          items={[
            { label: t("dashboard"), path: "/" },
            { label: t("documentLibrary") },
          ]}
        />

        {/* Page Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {t("documentLibraryTitle")}
            </h1>
            <p className="text-gray-600 mt-1">{t("documentLibraryDesc")}</p>
          </div>
          <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>{t("uploadDocument")}</span>
          </button>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("totalDocuments")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">248</p>
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
                  {t("totalSize")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">2.4 GB</p>
              </div>
              <div className="w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center">
                <File className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("downloads")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">1,456</p>
              </div>
              <div className="w-12 h-12 bg-purple-500 rounded-lg flex items-center justify-center">
                <Download className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">
                  {t("categories")}
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-2">8</p>
              </div>
              <div className="w-12 h-12 bg-orange-500 rounded-lg flex items-center justify-center">
                <Filter className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
        </div>

        {/* Search and Filter */}
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0">
            <div className="relative flex-1 max-w-md">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="text"
                placeholder={t("searchDocuments")}
                className="pl-10 pr-4 py-2 w-full border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
            <div className="flex space-x-2">
              {categories.map((category, index) => (
                <button
                  key={index}
                  className={`px-3 py-2 text-sm rounded-lg transition-colors ${
                    index === 0
                      ? "bg-blue-600 text-white"
                      : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                  }`}
                >
                  {category}
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* Documents Table */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900">
              {t("allDocuments")}
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("document")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("type")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("size")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("category")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("uploadDate")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("downloads")}
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    {t("actions")}
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {documents.map((document) => (
                  <tr key={document.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        {getFileIcon(document.type)}
                        <div className="ml-3">
                          <div className="text-sm font-medium text-gray-900">
                            {document.name}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">
                        {document.type}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {document.size}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {document.category}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {document.uploadDate}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {document.downloads}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <div className="flex space-x-2">
                        <button className="text-blue-600 hover:text-blue-900">
                          <Download className="w-4 h-4" />
                        </button>
                        <button className="text-gray-600 hover:text-gray-900">
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

export default DocumentLibrary;
