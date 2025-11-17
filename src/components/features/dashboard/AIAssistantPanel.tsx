/**
 * AI Assistant Panel Component
 *
 * Main container component that integrates AIInsightCard and AIActionList.
 * Handles loading states, errors, and empty states.
 */

import React, { useState } from "react";
import { RefreshCw, AlertCircle, ChevronDown, ChevronUp } from "lucide-react";
import AIInsightCard from "./AIInsightCard";
import AIActionList from "./AIActionList";
import type { AIAssistantPanelProps } from "../../../types/ai-assistant.types";

const AIAssistantPanel: React.FC<AIAssistantPanelProps> = ({
  dashboardData,
  isLoading = false,
  onActionClick,
}) => {
  const [isExpanded, setIsExpanded] = useState(false);
  const [isInsightExpanded, setIsInsightExpanded] = useState(false);

  // Mock data for now - will be replaced with real AI data
  const mockInsights = {
    summary:
      "Hệ thống hiện có 18 lớp đang hoạt động với tổng cộng 24 lớp. Có 3 lớp có tỷ lệ vắng mặt cao cần được quan tâm đặc biệt, bao gồm Lớp Toán 10A1 (35%), Lớp Văn 11B2 (42%), và Lớp Anh 12C3 (38%). Ngoài ra, có 2 lớp có tỷ lệ nộp bài tập thấp: Lớp Lý 10B1 (45%) và Lớp Hóa 11A2 (38%). Hiện có 12 học sinh đang trong tình trạng cần hỗ trợ. Khuyến nghị ưu tiên kiểm tra và hỗ trợ các lớp có vấn đề về điểm danh và bài tập.",
    timestamp: new Date(),
    actions: [
      {
        id: "check_risky_class_1",
        label: "Kiểm tra Lớp Văn 11B2 - Tỷ lệ vắng cao",
        target: "/classes/detail/2",
        reason: "Lớp có tỷ lệ vắng mặt 42%, cao nhất trong hệ thống",
        priority: 1 as const,
      },
      {
        id: "check_risky_class_2",
        label: "Kiểm tra Lớp Anh 12C3 - Tỷ lệ vắng cao",
        target: "/classes/detail/3",
        reason: "Lớp có tỷ lệ vắng mặt 38%, cần theo dõi sát",
        priority: 1 as const,
      },
      {
        id: "check_homework_class_1",
        label: "Xem lại Lớp Lý 10B1 - Nộp bài thấp",
        target: "/classes/detail/4",
        reason: "Chỉ 45% học sinh nộp bài tập đầy đủ",
        priority: 1 as const,
      },
      {
        id: "check_homework_class_2",
        label: "Xem lại Lớp Hóa 11A2 - Nộp bài thấp",
        target: "/classes/detail/5",
        reason: "Tỷ lệ nộp bài 38%, cần cải thiện",
        priority: 2 as const,
      },
      {
        id: "review_at_risk_students",
        label: "Xem danh sách học sinh cần hỗ trợ",
        target: "/students?filter=at-risk",
        reason: "Có 12 học sinh đang cần sự quan tâm đặc biệt",
        priority: 2 as const,
      },
    ],
  };

  const hasData = dashboardData !== null;

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
      {/* Header */}
      <div className="px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-indigo-50">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center">
              <span className="text-white text-lg">🤖</span>
            </div>
            <div>
              <h2 className="text-lg font-bold text-gray-900">
                Trợ lý AI Homeroom
              </h2>
              <p className="text-xs text-gray-600">
                Phân tích thông minh và đề xuất hành động
              </p>
            </div>
          </div>

          <button
            onClick={() => setIsExpanded(!isExpanded)}
            className="p-2 hover:bg-white/50 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            aria-label={
              isExpanded
                ? "Thu gọn bảng điều khiển AI"
                : "Mở rộng bảng điều khiển AI"
            }
            aria-expanded={isExpanded}
          >
            {isExpanded ? (
              <ChevronUp className="w-5 h-5 text-gray-600" />
            ) : (
              <ChevronDown className="w-5 h-5 text-gray-600" />
            )}
          </button>
        </div>
      </div>

      {/* Content */}
      {isExpanded && (
        <div className="p-6">
          {/* Loading State */}
          {isLoading && (
            <div
              className="flex flex-col items-center justify-center py-12"
              role="status"
              aria-live="polite"
              aria-label="Đang tải phân tích AI"
            >
              <RefreshCw
                className="w-12 h-12 text-blue-500 animate-spin mb-4"
                aria-hidden="true"
              />
              <p className="text-sm text-gray-600">
                Đang phân tích dữ liệu dashboard...
              </p>
            </div>
          )}

          {/* Error State */}
          {!isLoading && !hasData && (
            <div className="flex flex-col items-center justify-center py-12">
              <AlertCircle className="w-12 h-12 text-gray-400 mb-4" />
              <p className="text-sm text-gray-600 mb-4">
                Không thể tải dữ liệu phân tích
              </p>
              <button
                onClick={() => window.location.reload()}
                className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
                aria-label="Thử lại tải dữ liệu phân tích"
              >
                Thử lại
              </button>
            </div>
          )}

          {/* Content State */}
          {!isLoading && hasData && (
            <div className="space-y-6">
              {/* Insight Card */}
              <AIInsightCard
                summary={mockInsights.summary}
                timestamp={mockInsights.timestamp}
                isExpanded={isInsightExpanded}
                onToggle={() => setIsInsightExpanded(!isInsightExpanded)}
              />

              {/* Actions Section */}
              <div>
                <h3 className="text-sm font-semibold text-gray-900 mb-3">
                  Hành động được đề xuất ({mockInsights.actions.length})
                </h3>
                <AIActionList
                  actions={mockInsights.actions}
                  onActionClick={
                    onActionClick || ((action) => console.log(action))
                  }
                />
              </div>

              {/* Refresh Button */}
              <div className="pt-4 border-t border-gray-200">
                <button
                  onClick={() => window.location.reload()}
                  className="w-full flex items-center justify-center gap-2 px-4 py-2 text-sm font-medium text-gray-700 bg-gray-50 hover:bg-gray-100 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
                  aria-label="Làm mới phân tích AI"
                >
                  <RefreshCw className="w-4 h-4" aria-hidden="true" />
                  Làm mới phân tích
                </button>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default AIAssistantPanel;
