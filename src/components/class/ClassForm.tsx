import React, { useState, useEffect } from "react";
import type {
  Class,
  ClassStatus,
  ClassSchedule,
} from "../../types/class.types";
import { userService, type Teacher } from "../../services/userService";

interface ClassFormProps {
  initialData?: Class;
  onSubmit: (data: any) => void;
  onCancel: () => void;
  loading?: boolean;
}

const ClassForm: React.FC<ClassFormProps> = ({
  initialData,
  onSubmit,
  onCancel,
  loading = false,
}) => {
  // Helper to format date for input[type="date"]
  const formatDateForInput = (
    dateString: string | null | undefined
  ): string => {
    if (!dateString) return "";
    try {
      const date = new Date(dateString);
      if (isNaN(date.getTime())) return "";
      return date.toISOString().split("T")[0];
    } catch {
      return "";
    }
  };

  const [formData, setFormData] = useState({
    name: initialData?.name || "",
    code: initialData?.code || "",
    description: initialData?.description || "",
    level: initialData?.level || "",
    language: initialData?.language || "",
    max_students: initialData?.max_students || 20,
    status: initialData?.status || ("draft" as ClassStatus),
    start_date: formatDateForInput(initialData?.start_date),
    end_date: formatDateForInput(initialData?.end_date),
    room: initialData?.room || "",
    schedule_days: initialData?.schedule?.days || [],
    schedule_time: initialData?.schedule?.time || "",
    schedule_timezone: initialData?.schedule?.timezone || "Asia/Ho_Chi_Minh",
    teacher_ids: initialData?.teachers?.map((t) => t.id) || [],
  });

  const [teachers, setTeachers] = useState<Teacher[]>([]);
  const [loadingTeachers, setLoadingTeachers] = useState(true);

  // Fetch teachers on mount
  useEffect(() => {
    const fetchTeachers = async () => {
      try {
        const response = await userService.getTeachers();
        if (response.success) {
          setTeachers(response.data.users);
        }
      } catch (error) {
        console.error("Failed to fetch teachers:", error);
      } finally {
        setLoadingTeachers(false);
      }
    };
    fetchTeachers();
  }, []);

  // Define levels for each language
  const levelsByLanguage: Record<string, string[]> = {
    en: ["A1", "A2", "B1", "B2", "C1", "C2"],
    vi: ["Beginner", "Elementary", "Intermediate", "Advanced"],
    zh: ["HSK 1", "HSK 2", "HSK 3", "HSK 4", "HSK 5", "HSK 6"],
    ko: [
      "TOPIK I Level 1",
      "TOPIK I Level 2",
      "TOPIK II Level 3",
      "TOPIK II Level 4",
      "TOPIK II Level 5",
      "TOPIK II Level 6",
    ],
    ja: ["N5", "N4", "N3", "N2", "N1"],
  };

  const handleChange = (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement
    >
  ) => {
    const { name, value } = e.target;

    // If language changes, reset level
    if (name === "language") {
      setFormData((prev) => ({
        ...prev,
        [name]: value,
        level: "", // Reset level when language changes
      }));
    } else {
      setFormData((prev) => ({
        ...prev,
        [name]: value,
      }));
    }
  };

  const handleDayToggle = (day: string) => {
    setFormData((prev) => ({
      ...prev,
      schedule_days: prev.schedule_days.includes(day)
        ? prev.schedule_days.filter((d) => d !== day)
        : [...prev.schedule_days, day],
    }));
  };

  const handleTeacherToggle = (teacherId: number) => {
    setFormData((prev) => ({
      ...prev,
      teacher_ids: prev.teacher_ids.includes(teacherId)
        ? prev.teacher_ids.filter((id) => id !== teacherId)
        : [...prev.teacher_ids, teacherId],
    }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    const schedule: ClassSchedule = {
      days: formData.schedule_days,
      time: formData.schedule_time,
      timezone: formData.schedule_timezone,
    };

    const submitData = {
      name: formData.name,
      code: formData.code || null,
      description: formData.description || null,
      level: formData.level || null,
      language: formData.language,
      max_students: Number(formData.max_students),
      status: formData.status,
      start_date: formData.start_date || null,
      end_date: formData.end_date || null,
      room: formData.room || null,
      schedule: formData.schedule_days.length > 0 ? schedule : null,
      teacher_ids: formData.teacher_ids,
    };

    onSubmit(submitData);
  };

  const weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      {/* Basic Information */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">
          Basic Information
        </h3>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Class Name *
            </label>
            <input
              type="text"
              name="name"
              value={formData.name}
              onChange={handleChange}
              required
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="e.g., English A1 Morning Fall 2025"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Class Code
            </label>
            <input
              type="text"
              name="code"
              value={formData.code}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="e.g., EN-A1-M-F25"
            />
          </div>

          <div className="md:col-span-2">
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Description
            </label>
            <textarea
              name="description"
              value={formData.description}
              onChange={handleChange}
              rows={3}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="Brief description of the class"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Language *
            </label>
            <select
              name="language"
              value={formData.language}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">Select Language</option>
              <option value="en">English</option>
              <option value="vi">Vietnamese</option>
              <option value="zh">Chinese</option>
              <option value="ko">Korean</option>
              <option value="ja">Japanese</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Level
            </label>
            <select
              name="level"
              value={formData.level}
              onChange={handleChange}
              disabled={!formData.language}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-100 disabled:cursor-not-allowed"
            >
              <option value="">
                {formData.language ? "Select Level" : "Select Language First"}
              </option>
              {formData.language &&
                levelsByLanguage[formData.language]?.map((level) => (
                  <option key={level} value={level}>
                    {level}
                  </option>
                ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Max Students
            </label>
            <input
              type="number"
              name="max_students"
              value={formData.max_students}
              onChange={handleChange}
              min="1"
              max="100"
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Status
            </label>
            <select
              name="status"
              value={formData.status}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="draft">Draft</option>
              <option value="active">Active</option>
              <option value="completed">Completed</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>
        </div>
      </div>

      {/* Teachers */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">
          Assign Teachers ({teachers.length})
        </h3>

        {loadingTeachers ? (
          <div className="text-gray-500">Loading teachers...</div>
        ) : teachers.length === 0 ? (
          <div className="text-gray-500">No teachers available</div>
        ) : (
          <div className="max-h-80 overflow-y-auto space-y-2 pr-2">
            {teachers.map((teacher) => (
              <label
                key={teacher.id}
                className="flex items-center space-x-3 p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer"
              >
                <input
                  type="checkbox"
                  checked={formData.teacher_ids.includes(teacher.id)}
                  onChange={() => handleTeacherToggle(teacher.id)}
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                />
                <div className="flex-1">
                  <div className="text-sm font-medium text-gray-900">
                    {teacher.full_name}
                  </div>
                  <div className="text-xs text-gray-500">{teacher.email}</div>
                </div>
              </label>
            ))}
          </div>
        )}
      </div>

      {/* Schedule */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Schedule</h3>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Start Date
            </label>
            <input
              type="date"
              name="start_date"
              value={formData.start_date}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              End Date
            </label>
            <input
              type="date"
              name="end_date"
              value={formData.end_date}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div className="md:col-span-2">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Class Days
            </label>
            <div className="flex flex-wrap gap-2">
              {weekDays.map((day) => (
                <button
                  key={day}
                  type="button"
                  onClick={() => handleDayToggle(day)}
                  className={`px-4 py-2 rounded-lg border transition-colors ${
                    formData.schedule_days.includes(day)
                      ? "bg-blue-600 text-white border-blue-600"
                      : "bg-white text-gray-700 border-gray-300 hover:bg-gray-50"
                  }`}
                >
                  {day.substring(0, 3)}
                </button>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Time
            </label>
            <input
              type="text"
              name="schedule_time"
              value={formData.schedule_time}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="e.g., 09:00-11:00"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Timezone
            </label>
            <select
              name="schedule_timezone"
              value={formData.schedule_timezone}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="Asia/Ho_Chi_Minh">Asia/Ho Chi Minh</option>
              <option value="Asia/Tokyo">Asia/Tokyo</option>
              <option value="Asia/Seoul">Asia/Seoul</option>
              <option value="Asia/Shanghai">Asia/Shanghai</option>
              <option value="America/New_York">America/New York</option>
              <option value="Europe/London">Europe/London</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Room
            </label>
            <input
              type="text"
              name="room"
              value={formData.room}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="e.g., Room 101"
            />
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="flex justify-end space-x-4">
        <button
          type="button"
          onClick={onCancel}
          className="px-6 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors"
          disabled={loading}
        >
          Cancel
        </button>
        <button
          type="submit"
          className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          disabled={loading}
        >
          {loading
            ? "Saving..."
            : initialData
            ? "Update Class"
            : "Create Class"}
        </button>
      </div>
    </form>
  );
};

export default ClassForm;
