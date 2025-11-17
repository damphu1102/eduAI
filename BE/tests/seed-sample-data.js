/**
 * Seed Sample Data for Classes
 * Run: node tests/seed-sample-data.js
 */

const axios = require("axios");

const API_BASE = "http://localhost:5000/api";
let authToken = "";

// Colors for console output
const colors = {
  reset: "\x1b[0m",
  green: "\x1b[32m",
  red: "\x1b[31m",
  yellow: "\x1b[33m",
  blue: "\x1b[34m",
  cyan: "\x1b[36m",
};

const log = {
  success: (msg) => console.log(`${colors.green}✅ ${msg}${colors.reset}`),
  error: (msg) => console.log(`${colors.red}❌ ${msg}${colors.reset}`),
  info: (msg) => console.log(`${colors.blue}ℹ️  ${msg}${colors.reset}`),
  warn: (msg) => console.log(`${colors.yellow}⚠️  ${msg}${colors.reset}`),
};

// Sample classes data
const sampleClasses = [
  {
    code: "EN-A1-M-F25",
    name: "English A1 Morning Fall 2025",
    description:
      "Beginner English class for students with no prior knowledge. Focus on basic grammar, vocabulary, and conversation skills.",
    level: "A1",
    language: "en",
    max_students: 20,
    status: "active",
    start_date: "2025-09-01",
    end_date: "2025-12-15",
    room: "Room 101",
    schedule: {
      days: ["Monday", "Wednesday", "Friday"],
      time: "09:00-11:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "EN-A2-A-F25",
    name: "English A2 Afternoon Fall 2025",
    description:
      "Elementary English class for students who have completed A1 level. Emphasis on practical communication and reading comprehension.",
    level: "A2",
    language: "en",
    max_students: 18,
    status: "active",
    start_date: "2025-09-01",
    end_date: "2025-12-15",
    room: "Room 102",
    schedule: {
      days: ["Tuesday", "Thursday"],
      time: "14:00-17:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "EN-B1-E-F25",
    name: "English B1 Evening Fall 2025",
    description:
      "Intermediate English class for working professionals. Focus on business English and advanced conversation.",
    level: "B1",
    language: "en",
    max_students: 15,
    status: "active",
    start_date: "2025-09-01",
    end_date: "2025-12-15",
    room: "Room 201",
    schedule: {
      days: ["Monday", "Wednesday", "Friday"],
      time: "18:00-20:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "EN-B2-W-F25",
    name: "English B2 Weekend Fall 2025",
    description:
      "Upper-intermediate English class. Preparation for IELTS and TOEFL exams.",
    level: "B2",
    language: "en",
    max_students: 12,
    status: "active",
    start_date: "2025-09-06",
    end_date: "2025-12-20",
    room: "Room 202",
    schedule: {
      days: ["Saturday", "Sunday"],
      time: "09:00-12:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "EN-C1-M-F25",
    name: "English C1 Morning Fall 2025",
    description:
      "Advanced English class for near-native speakers. Focus on academic writing and critical thinking.",
    level: "C1",
    language: "en",
    max_students: 10,
    status: "active",
    start_date: "2025-09-01",
    end_date: "2025-12-15",
    room: "Room 301",
    schedule: {
      days: ["Tuesday", "Thursday"],
      time: "09:00-12:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "VI-A1-M-F25",
    name: "Vietnamese A1 Morning Fall 2025",
    description:
      "Beginner Vietnamese class for foreigners. Learn basic Vietnamese for daily communication.",
    level: "A1",
    language: "vi",
    max_students: 15,
    status: "active",
    start_date: "2025-09-01",
    end_date: "2025-12-15",
    room: "Room 103",
    schedule: {
      days: ["Monday", "Wednesday", "Friday"],
      time: "10:00-12:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "ZH-A1-A-F25",
    name: "Chinese A1 Afternoon Fall 2025",
    description:
      "Beginner Chinese (Mandarin) class. Learn pinyin, basic characters, and simple conversations.",
    level: "A1",
    language: "zh",
    max_students: 20,
    status: "active",
    start_date: "2025-09-01",
    end_date: "2025-12-15",
    room: "Room 104",
    schedule: {
      days: ["Tuesday", "Thursday"],
      time: "14:00-16:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "KO-A1-E-F25",
    name: "Korean A1 Evening Fall 2025",
    description:
      "Beginner Korean class. Learn Hangul, basic grammar, and K-pop culture.",
    level: "A1",
    language: "ko",
    max_students: 25,
    status: "active",
    start_date: "2025-09-01",
    end_date: "2025-12-15",
    room: "Room 105",
    schedule: {
      days: ["Monday", "Wednesday", "Friday"],
      time: "18:00-20:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "JA-A1-W-F25",
    name: "Japanese A1 Weekend Fall 2025",
    description:
      "Beginner Japanese class. Learn Hiragana, Katakana, and basic Kanji.",
    level: "A1",
    language: "ja",
    max_students: 20,
    status: "active",
    start_date: "2025-09-06",
    end_date: "2025-12-20",
    room: "Room 106",
    schedule: {
      days: ["Saturday", "Sunday"],
      time: "13:00-16:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "EN-A1-M-S26",
    name: "English A1 Morning Spring 2026",
    description: "Beginner English class for Spring 2026 semester.",
    level: "A1",
    language: "en",
    max_students: 20,
    status: "draft",
    start_date: "2026-02-01",
    end_date: "2026-05-31",
    room: "Room 101",
    schedule: {
      days: ["Monday", "Wednesday", "Friday"],
      time: "09:00-11:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "EN-B1-A-S26",
    name: "English B1 Afternoon Spring 2026",
    description: "Intermediate English class for Spring 2026 semester.",
    level: "B1",
    language: "en",
    max_students: 18,
    status: "draft",
    start_date: "2026-02-01",
    end_date: "2026-05-31",
    room: "Room 201",
    schedule: {
      days: ["Tuesday", "Thursday"],
      time: "14:00-17:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "EN-A2-M-SU24",
    name: "English A2 Morning Summer 2024",
    description:
      "Elementary English class - Summer intensive course (COMPLETED).",
    level: "A2",
    language: "en",
    max_students: 15,
    status: "completed",
    start_date: "2024-06-01",
    end_date: "2024-08-31",
    room: "Room 102",
    schedule: {
      days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      time: "09:00-12:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "EN-B2-E-SU24",
    name: "English B2 Evening Summer 2024",
    description:
      "Upper-intermediate English class - Summer intensive (COMPLETED).",
    level: "B2",
    language: "en",
    max_students: 12,
    status: "completed",
    start_date: "2024-06-01",
    end_date: "2024-08-31",
    room: "Room 202",
    schedule: {
      days: ["Monday", "Wednesday", "Friday"],
      time: "18:00-21:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "VI-A2-M-SP25",
    name: "Vietnamese A2 Morning Spring 2025",
    description:
      "Elementary Vietnamese class - CANCELLED due to low enrollment.",
    level: "A2",
    language: "vi",
    max_students: 15,
    status: "cancelled",
    start_date: "2025-02-01",
    end_date: "2025-05-31",
    room: "Room 103",
    schedule: {
      days: ["Tuesday", "Thursday"],
      time: "10:00-12:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
  {
    code: "ZH-B1-W-SP25",
    name: "Chinese B1 Weekend Spring 2025",
    description:
      "Intermediate Chinese class - CANCELLED due to instructor unavailability.",
    level: "B1",
    language: "zh",
    max_students: 18,
    status: "cancelled",
    start_date: "2025-02-01",
    end_date: "2025-05-31",
    room: "Room 104",
    schedule: {
      days: ["Saturday", "Sunday"],
      time: "09:00-12:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  },
];

// Login to get token
async function login() {
  try {
    log.info("Logging in...");
    const response = await axios.post(`${API_BASE}/auth/login`, {
      email: "admin@example.com",
      password: "password123",
    });

    if (response.data.success && response.data.data.token) {
      authToken = response.data.data.token;
      log.success("Login successful");
      return true;
    } else {
      log.error("Login failed");
      return false;
    }
  } catch (error) {
    log.error(
      `Login failed: ${error.response?.data?.message || error.message}`
    );
    return false;
  }
}

// Create sample classes
async function seedClasses() {
  log.info(`Creating ${sampleClasses.length} sample classes...`);

  let created = 0;
  let failed = 0;

  for (const classData of sampleClasses) {
    try {
      const response = await axios.post(`${API_BASE}/classes`, classData, {
        headers: { Authorization: `Bearer ${authToken}` },
      });

      if (response.data.success) {
        created++;
        log.success(`Created: ${classData.name} (${classData.code})`);
      } else {
        failed++;
        log.error(`Failed to create: ${classData.name}`);
      }
    } catch (error) {
      failed++;
      log.error(
        `Failed to create ${classData.name}: ${
          error.response?.data?.message || error.message
        }`
      );
    }
  }

  return { created, failed };
}

// Main function
async function main() {
  console.log("\n" + "=".repeat(60));
  console.log("🌱 SEEDING SAMPLE DATA");
  console.log("=".repeat(60) + "\n");

  // Login
  const loginSuccess = await login();
  if (!loginSuccess) {
    log.error("Cannot proceed without authentication");
    process.exit(1);
  }

  console.log("");

  // Seed classes
  const { created, failed } = await seedClasses();

  // Summary
  console.log("\n" + "=".repeat(60));
  console.log("📊 SEEDING SUMMARY");
  console.log("=".repeat(60));
  console.log(`Total Classes: ${sampleClasses.length}`);
  console.log(`${colors.green}Created: ${created}${colors.reset}`);
  console.log(`${colors.red}Failed: ${failed}${colors.reset}`);
  console.log(
    `Success Rate: ${((created / sampleClasses.length) * 100).toFixed(1)}%`
  );
  console.log("=".repeat(60) + "\n");

  if (created > 0) {
    log.success("Sample data seeded successfully!");
    log.info("You can now test the frontend with real data");
    log.info("Navigate to: http://localhost:5173/classes");
  }

  process.exit(failed > 0 ? 1 : 0);
}

// Run
main().catch((error) => {
  log.error(`Fatal error: ${error.message}`);
  process.exit(1);
});
