import React from "react";
import { Calendar, Clock, MapPin, Plus } from "lucide-react";
import { useTranslation } from "../../hooks/useTranslation";

const ClassSchedule: React.FC = () => {
  const { t } = useTranslation();

  const schedules = [
    {
      id: 1,
      subject: "Mathematics",
      time: "08:00 - 09:30",
      room: "Room 101",
      teacher: "Dr. Smith",
      day: "Monday",
    },
    {
      id: 2,
      subject: "Physics",
      time: "10:00 - 11:30",
      room: "Lab 203",
      teacher: "Prof. Johnson",
      day: "Monday",
    },
    {
      id: 3,
      subject: "Chemistry",
      time: "13:00 - 14:30",
      room: "Lab 105",
      teacher: "Dr. Brown",
      day: "Tuesday",
    },
  ];

  return (
    <div className="space-y-6">
      <div className="flex justify-end">
        <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2">
          <Plus className="w-4 h-4" />
          <span>{t("addSchedule")}</span>
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {schedules.map((schedule) => (
          <div
            key={schedule.id}
            className="bg-white rounded-lg p-6 shadow-sm border border-gray-200 hover:shadow-md transition-shadow"
          >
            <div className="flex items-start justify-between mb-4">
              <div>
                <h3 className="text-lg font-semibold text-gray-900">
                  {schedule.subject}
                </h3>
                <p className="text-sm text-gray-500">{schedule.day}</p>
              </div>
              <span className="px-3 py-1 bg-blue-100 text-blue-800 text-xs font-semibold rounded-full">
                {schedule.day}
              </span>
            </div>
            <div className="space-y-2">
              <div className="flex items-center text-sm text-gray-600">
                <Clock className="w-4 h-4 mr-2" />
                {schedule.time}
              </div>
              <div className="flex items-center text-sm text-gray-600">
                <MapPin className="w-4 h-4 mr-2" />
                {schedule.room}
              </div>
              <div className="flex items-center text-sm text-gray-600">
                <Calendar className="w-4 h-4 mr-2" />
                {schedule.teacher}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ClassSchedule;
