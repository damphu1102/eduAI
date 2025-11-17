/**
 * AI Insight Card Component
 *
 * Displays the Vietnamese summary text from AI analysis
 * with expand/collapse functionality and timestamp.
 */

import React from "react";
import { ChevronDown, ChevronUp, Sparkles } from "lucide-react";
import type { AIInsightCardProps } from "../../../types/ai-assistant.types";

const AIInsightCard: React.FC<AIInsightCardProps> = ({
  summary,
  timestamp,
  isExpanded = false,
  onToggle,
}) => {
  // Format timestamp
  const formatTimestamp = (date: Date): string => {
    const now = new Date();
    const diff = now.getTime() - date.getTime();
    const minutes = Math.floor(diff / 60000);

    if (minutes < 1) return "Vừa xong";
    if (minutes < 60) return `${minutes} phút trước`;

    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `${hours} giờ trước`;

    return date.toLocaleDateString("vi-VN", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  // Truncate summary for collapsed state
  const truncatedSummary =
    summary.length > 150 && !isExpanded
      ? summary.substring(0, 150) + "..."
      : summary;

  const shouldShowToggle = summary.length > 150;

  return (
    <div className="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-lg p-6 shadow-sm border border-blue-200">
      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center">
            <Sparkles className="w-5 h-5 text-white" />
          </div>
          <div>
            <h3 className="text-sm font-semibold text-gray-900">
              Phân tích AI
            </h3>
            <p className="text-xs text-gray-500">
              {formatTimestamp(timestamp)}
            </p>
          </div>
        </div>
      </div>

      {/* Summary Text */}
      <div className="text-sm text-gray-700 leading-relaxed whitespace-pre-wrap">
        {truncatedSummary}
      </div>

      {/* Expand/Collapse Button */}
      {shouldShowToggle && onToggle && (
        <button
          onClick={onToggle}
          className="mt-3 flex items-center gap-1 text-xs font-medium text-blue-600 hover:text-blue-700 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 rounded"
          aria-expanded={isExpanded}
          aria-label={isExpanded ? "Thu gọn nội dung" : "Xem thêm nội dung"}
        >
          {isExpanded ? (
            <>
              Thu gọn <ChevronUp className="w-4 h-4" />
            </>
          ) : (
            <>
              Xem thêm <ChevronDown className="w-4 h-4" />
            </>
          )}
        </button>
      )}
    </div>
  );
};

export default AIInsightCard;
