/**
 * Floating AI Assistant Widget
 *
 * A floating chat-style AI assistant that appears in the bottom-right corner
 * Similar to common chat widgets on websites
 */

import React, { useState } from "react";
import { Bot, X, Send, Sparkles } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { useTranslation } from "../../hooks/useTranslation";

const FloatingAIAssistant: React.FC = () => {
  const { t } = useTranslation();
  const [isOpen, setIsOpen] = useState(false);
  const [message, setMessage] = useState("");
  const [isTyping, setIsTyping] = useState(false);
  const [messages, setMessages] = useState<
    Array<{ role: "user" | "assistant"; content: string; timestamp?: Date }>
  >([
    {
      role: "assistant",
      content: t("aiAssistantWelcome"),
      timestamp: new Date(),
    },
  ]);

  // Mock AI responses based on keywords
  const getAIResponse = (userMessage: string): string => {
    const msg = userMessage.toLowerCase();

    // Class-related queries
    if (msg.includes("lớp") || msg.includes("class")) {
      return "Hiện tại hệ thống có 24 lớp học, trong đó 18 lớp đang hoạt động. Bạn có thể xem chi tiết tại trang Quản lý lớp học. Bạn cần tôi giúp gì thêm về lớp học không?";
    }

    // Student-related queries
    if (msg.includes("học sinh") || msg.includes("student")) {
      return "Hệ thống hiện có 1,248 học sinh đang theo học. Có 12 học sinh đang cần hỗ trợ đặc biệt. Bạn muốn xem danh sách chi tiết không?";
    }

    // Course-related queries
    if (msg.includes("khóa học") || msg.includes("course")) {
      return "Có 156 khóa học đang hoạt động với tỷ lệ hoàn thành trung bình là 87%. Bạn có thể quản lý khóa học tại menu bên trái.";
    }

    // Attendance queries
    if (
      msg.includes("điểm danh") ||
      msg.includes("attendance") ||
      msg.includes("vắng")
    ) {
      return "Có 3 lớp có tỷ lệ vắng mặt cao cần quan tâm:\n• Lớp Văn 11B2: 42%\n• Lớp Anh 12C3: 38%\n• Lớp Toán 10A1: 35%\n\nBạn có muốn xem chi tiết không?";
    }

    // Assignment/homework queries
    if (
      msg.includes("bài tập") ||
      msg.includes("homework") ||
      msg.includes("assignment")
    ) {
      return "Có 2 lớp có tỷ lệ nộp bài tập thấp:\n• Lớp Lý 10B1: 45%\n• Lớp Hóa 11A2: 38%\n\nTôi khuyên bạn nên kiểm tra và nhắc nhở học sinh các lớp này.";
    }

    // Help queries
    if (
      msg.includes("help") ||
      msg.includes("giúp") ||
      msg.includes("hướng dẫn")
    ) {
      return "Tôi có thể giúp bạn:\n• Xem thống kê lớp học và học sinh\n• Kiểm tra tình trạng điểm danh\n• Theo dõi bài tập và tiến độ học tập\n• Phân tích dữ liệu và đưa ra đề xuất\n\nBạn muốn biết thêm về vấn đề gì?";
    }

    // Greeting
    if (
      msg.includes("xin chào") ||
      msg.includes("hello") ||
      msg.includes("hi")
    ) {
      return "Xin chào! Tôi là trợ lý AI của SysEdu. Tôi có thể giúp bạn quản lý lớp học, theo dõi học sinh, và phân tích dữ liệu giáo dục. Bạn cần hỗ trợ gì?";
    }

    // Default response
    return "Cảm ơn câu hỏi của bạn! Tôi đang học cách trả lời tốt hơn. Hiện tại tôi có thể giúp bạn về:\n• Thông tin lớp học và học sinh\n• Tình trạng điểm danh\n• Bài tập và tiến độ học tập\n\nBạn có thể hỏi cụ thể hơn không?";
  };

  const handleSend = () => {
    if (!message.trim()) return;

    const userMsg = message.trim();
    setMessages((prev) => [
      ...prev,
      {
        role: "user",
        content: userMsg,
        timestamp: new Date(),
      },
    ]);
    setMessage("");
    setIsTyping(true);

    // Simulate AI thinking and response
    setTimeout(() => {
      const aiResponse = getAIResponse(userMsg);
      setMessages((prev) => [
        ...prev,
        {
          role: "assistant",
          content: aiResponse,
          timestamp: new Date(),
        },
      ]);
      setIsTyping(false);
    }, 1000 + Math.random() * 1000); // Random delay 1-2s for realism
  };

  return (
    <>
      {/* Chat Panel */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 20, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 20, scale: 0.95 }}
            transition={{ duration: 0.2 }}
            className="fixed bottom-24 right-4 md:right-6 w-[90vw] md:w-96 h-[500px] bg-white rounded-2xl shadow-2xl border border-gray-200 flex flex-col z-50"
          >
            {/* Header */}
            <div className="bg-gradient-to-r from-emerald-500 to-teal-600 text-white px-6 py-4 rounded-t-2xl flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-sm">
                  <Sparkles className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-semibold text-base">
                    {t("aiAssistant")}
                  </h3>
                  <p className="text-xs text-emerald-50">
                    {t("aiAssistantReady")}
                  </p>
                </div>
              </div>
              <button
                onClick={() => setIsOpen(false)}
                className="p-2 hover:bg-white/20 rounded-lg transition-colors"
                aria-label={t("closeChat")}
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Messages */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-gray-50">
              {messages.map((msg, idx) => (
                <div
                  key={idx}
                  className={`flex ${
                    msg.role === "user" ? "justify-end" : "justify-start"
                  }`}
                >
                  <div
                    className={`max-w-[80%] rounded-2xl px-4 py-2 ${
                      msg.role === "user"
                        ? "bg-emerald-500 text-white rounded-br-sm"
                        : "bg-white text-gray-800 shadow-sm border border-gray-200 rounded-bl-sm"
                    }`}
                  >
                    <p className="text-sm whitespace-pre-line">{msg.content}</p>
                  </div>
                </div>
              ))}

              {/* Typing indicator */}
              {isTyping && (
                <div className="flex justify-start">
                  <div className="bg-white text-gray-800 shadow-sm border border-gray-200 rounded-2xl rounded-bl-sm px-4 py-3">
                    <div className="flex gap-1">
                      <div
                        className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"
                        style={{ animationDelay: "0ms" }}
                      ></div>
                      <div
                        className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"
                        style={{ animationDelay: "150ms" }}
                      ></div>
                      <div
                        className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"
                        style={{ animationDelay: "300ms" }}
                      ></div>
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Input */}
            <div className="p-4 border-t border-gray-200 bg-white rounded-b-2xl">
              <div className="flex gap-2">
                <input
                  type="text"
                  value={message}
                  onChange={(e) => setMessage(e.target.value)}
                  onKeyDown={(e) =>
                    e.key === "Enter" && !e.shiftKey && handleSend()
                  }
                  placeholder={t("typeMessage")}
                  className="flex-1 px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent text-sm"
                />
                <button
                  onClick={handleSend}
                  className="p-2 bg-emerald-500 text-white rounded-full hover:bg-emerald-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                  disabled={!message.trim()}
                  aria-label={t("sendMessage")}
                >
                  <Send className="w-5 h-5" />
                </button>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Floating Button */}
      <motion.button
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        onClick={() => setIsOpen(!isOpen)}
        className="fixed bottom-6 right-4 md:right-6 w-14 h-14 bg-gradient-to-br from-emerald-500 to-teal-600 text-white rounded-full shadow-lg hover:shadow-xl transition-shadow flex items-center justify-center z-50"
        aria-label={isOpen ? t("closeAIAssistant") : t("openAIAssistant")}
      >
        <AnimatePresence mode="wait">
          {isOpen ? (
            <motion.div
              key="close"
              initial={{ rotate: -90, opacity: 0 }}
              animate={{ rotate: 0, opacity: 1 }}
              exit={{ rotate: 90, opacity: 0 }}
              transition={{ duration: 0.2 }}
            >
              <X className="w-6 h-6" />
            </motion.div>
          ) : (
            <motion.div
              key="open"
              initial={{ rotate: 90, opacity: 0 }}
              animate={{ rotate: 0, opacity: 1 }}
              exit={{ rotate: -90, opacity: 0 }}
              transition={{ duration: 0.2 }}
            >
              <Bot className="w-6 h-6" />
            </motion.div>
          )}
        </AnimatePresence>
      </motion.button>
    </>
  );
};

export default FloatingAIAssistant;
