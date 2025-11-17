/**
 * AI Action List Component
 *
 * Displays a list of AI-generated action recommendations
 * with priority-based color coding and click handlers.
 */

import React from "react";
import {
  ArrowRight,
  AlertCircle,
  AlertTriangle,
  Info,
  type LucideIcon,
} from "lucide-react";
import type { AIActionListProps } from "../../../types/ai-assistant.types";

const AIActionList: React.FC<AIActionListProps> = ({
  actions,
  onActionClick,
}) => {
  // Get priority badge styling
  const getPriorityConfig = (
    priority: 1 | 2 | 3
  ): {
    icon: LucideIcon;
    bgColor: string;
    textColor: string;
    borderColor: string;
    label: string;
  } => {
    switch (priority) {
      case 1:
        return {
          icon: AlertCircle,
          bgColor: "bg-red-50",
          textColor: "text-red-700",
          borderColor: "border-red-200",
          label: "Ưu tiên cao",
        };
      case 2:
        return {
          icon: AlertTriangle,
          bgColor: "bg-yellow-50",
          textColor: "text-yellow-700",
          borderColor: "border-yellow-200",
          label: "Ưu tiên trung bình",
        };
      case 3:
        return {
          icon: Info,
          bgColor: "bg-blue-50",
          textColor: "text-blue-700",
          borderColor: "border-blue-200",
          label: "Gợi ý",
        };
    }
  };

  if (actions.length === 0) {
    return (
      <div className="text-center py-8 text-gray-500">
        <Info className="w-12 h-12 mx-auto mb-3 text-gray-400" />
        <p className="text-sm">Không có hành động được đề xuất</p>
      </div>
    );
  }

  return (
    <div className="space-y-3">
      {actions.map((action) => {
        const config = getPriorityConfig(action.priority);
        const Icon = config.icon;

        return (
          <button
            key={action.id}
            onClick={() => onActionClick(action)}
            onKeyDown={(e) => {
              if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                onActionClick(action);
              }
            }}
            className={`w-full text-left p-4 rounded-lg border ${config.borderColor} ${config.bgColor} hover:shadow-md transition-all duration-200 group focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2`}
            aria-label={`${config.label}: ${action.label}`}
            role="button"
            tabIndex={0}
          >
            <div className="flex items-start gap-3">
              {/* Priority Icon */}
              <div
                className={`flex-shrink-0 w-8 h-8 rounded-lg ${config.bgColor} border ${config.borderColor} flex items-center justify-center`}
              >
                <Icon className={`w-4 h-4 ${config.textColor}`} />
              </div>

              {/* Content */}
              <div className="flex-1 min-w-0">
                {/* Priority Badge */}
                <span
                  className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${config.textColor} mb-2`}
                >
                  {config.label}
                </span>

                {/* Action Label */}
                <h4 className="text-sm font-semibold text-gray-900 mb-1 group-hover:text-blue-600 transition-colors">
                  {action.label}
                </h4>

                {/* Action Reason */}
                <p className="text-xs text-gray-600 leading-relaxed">
                  {action.reason}
                </p>
              </div>

              {/* Arrow Icon */}
              <div className="flex-shrink-0">
                <ArrowRight className="w-5 h-5 text-gray-400 group-hover:text-blue-600 group-hover:translate-x-1 transition-all" />
              </div>
            </div>
          </button>
        );
      })}
    </div>
  );
};

export default AIActionList;
