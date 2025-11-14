import React from "react";
import { Users, Mail, Phone, UserPlus } from "lucide-react";
import { useTranslation } from "../../hooks/useTranslation";

const ClassMembers: React.FC = () => {
  const { t } = useTranslation();

  const members = [
    {
      id: 1,
      name: "John Doe",
      role: "Student",
      email: "john@example.com",
      phone: "+1234567890",
      status: "active",
    },
    {
      id: 2,
      name: "Jane Smith",
      role: "Student",
      email: "jane@example.com",
      phone: "+1234567891",
      status: "active",
    },
    {
      id: 3,
      name: "Dr. Smith",
      role: "Teacher",
      email: "smith@example.com",
      phone: "+1234567892",
      status: "active",
    },
  ];

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                {t("totalMembers")}
              </p>
              <p className="text-2xl font-bold text-gray-900 mt-2">35</p>
            </div>
            <Users className="w-10 h-10 text-blue-500" />
          </div>
        </div>
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                {t("students")}
              </p>
              <p className="text-2xl font-bold text-gray-900 mt-2">32</p>
            </div>
            <Users className="w-10 h-10 text-green-500" />
          </div>
        </div>
        <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                {t("teachers")}
              </p>
              <p className="text-2xl font-bold text-gray-900 mt-2">3</p>
            </div>
            <Users className="w-10 h-10 text-purple-500" />
          </div>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-sm border border-gray-200">
        <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
          <h3 className="text-lg font-semibold text-gray-900">
            {t("allMembers")}
          </h3>
          <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2">
            <UserPlus className="w-4 h-4" />
            <span>{t("addMember")}</span>
          </button>
        </div>
        <div className="divide-y divide-gray-200">
          {members.map((member) => (
            <div key={member.id} className="px-6 py-4 hover:bg-gray-50">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-4">
                  <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                    <span className="text-blue-600 font-semibold">
                      {member.name.charAt(0)}
                    </span>
                  </div>
                  <div>
                    <h4 className="text-sm font-medium text-gray-900">
                      {member.name}
                    </h4>
                    <p className="text-sm text-gray-500">{member.role}</p>
                  </div>
                </div>
                <div className="flex items-center space-x-6">
                  <div className="flex items-center text-sm text-gray-600">
                    <Mail className="w-4 h-4 mr-2" />
                    {member.email}
                  </div>
                  <div className="flex items-center text-sm text-gray-600">
                    <Phone className="w-4 h-4 mr-2" />
                    {member.phone}
                  </div>
                  <span className="px-3 py-1 bg-green-100 text-green-800 text-xs font-semibold rounded-full">
                    {member.status}
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ClassMembers;
