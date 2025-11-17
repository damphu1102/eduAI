/**
 * Seed Teachers and Assign to Classes
 * Run: node tests/seed-teachers.js
 */

const mysql = require("mysql2/promise");
const bcrypt = require("bcryptjs");
require("dotenv").config();

const colors = {
  reset: "\x1b[0m",
  green: "\x1b[32m",
  red: "\x1b[31m",
  blue: "\x1b[34m",
  cyan: "\x1b[36m",
};

const log = {
  success: (msg) => console.log(`${colors.green}✅ ${msg}${colors.reset}`),
  error: (msg) => console.log(`${colors.red}❌ ${msg}${colors.reset}`),
  info: (msg) => console.log(`${colors.blue}ℹ️  ${msg}${colors.reset}`),
};

// Sample teachers data
const teachers = [
  {
    email: "john.smith@sysedu.com",
    full_name: "John Smith",
    specialization: "English A1-A2",
  },
  {
    email: "sarah.johnson@sysedu.com",
    full_name: "Sarah Johnson",
    specialization: "English B1-B2",
  },
  {
    email: "michael.brown@sysedu.com",
    full_name: "Michael Brown",
    specialization: "English C1-C2",
  },
  {
    email: "nguyen.van.a@sysedu.com",
    full_name: "Nguyễn Văn A",
    specialization: "Vietnamese",
  },
  {
    email: "li.wei@sysedu.com",
    full_name: "Li Wei (李伟)",
    specialization: "Chinese",
  },
  {
    email: "kim.minsoo@sysedu.com",
    full_name: "Kim Min-soo (김민수)",
    specialization: "Korean",
  },
  {
    email: "tanaka.yuki@sysedu.com",
    full_name: "Tanaka Yuki (田中優希)",
    specialization: "Japanese",
  },
  {
    email: "emily.davis@sysedu.com",
    full_name: "Emily Davis",
    specialization: "English A1-B1",
  },
];

async function seedTeachers() {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
  });

  try {
    console.log("\n" + "=".repeat(60));
    console.log("👨‍🏫 SEEDING TEACHERS");
    console.log("=".repeat(60) + "\n");

    // Hash password for all teachers
    const passwordHash = await bcrypt.hash("teacher123", 10);

    let created = 0;
    let skipped = 0;
    const teacherIds = [];

    // Create teachers
    for (const teacher of teachers) {
      try {
        // Check if exists
        const [existing] = await conn.query(
          "SELECT id FROM users WHERE email = ?",
          [teacher.email]
        );

        if (existing.length > 0) {
          skipped++;
          teacherIds.push(existing[0].id);
          log.info(`Skipped (exists): ${teacher.full_name} (${teacher.email})`);
        } else {
          const [result] = await conn.query(
            `INSERT INTO users (tenant_id, email, full_name, role, password_hash, is_active)
             VALUES (?, ?, ?, ?, ?, ?)`,
            [1, teacher.email, teacher.full_name, "teacher", passwordHash, 1]
          );
          created++;
          teacherIds.push(result.insertId);
          log.success(`Created: ${teacher.full_name} (${teacher.email})`);
        }
      } catch (error) {
        log.error(`Failed to create ${teacher.full_name}: ${error.message}`);
      }
    }

    console.log("\n" + "=".repeat(60));
    console.log("🎓 ASSIGNING TEACHERS TO CLASSES");
    console.log("=".repeat(60) + "\n");

    // Get all classes
    const [classes] = await conn.query(
      "SELECT id, code, name, language FROM classes"
    );

    let assigned = 0;
    let assignFailed = 0;

    // Assignment logic based on language and level
    for (const cls of classes) {
      let teacherId = null;

      // Assign based on language
      if (cls.language === "vi") {
        teacherId = teacherIds[3]; // Nguyễn Văn A
      } else if (cls.language === "zh") {
        teacherId = teacherIds[4]; // Li Wei
      } else if (cls.language === "ko") {
        teacherId = teacherIds[5]; // Kim Min-soo
      } else if (cls.language === "ja") {
        teacherId = teacherIds[6]; // Tanaka Yuki
      } else if (cls.language === "en") {
        // Assign based on level in code
        if (cls.code.includes("A1") || cls.code.includes("A2")) {
          teacherId = teacherIds[0]; // John Smith (A1-A2)
        } else if (cls.code.includes("B1") || cls.code.includes("B2")) {
          teacherId = teacherIds[1]; // Sarah Johnson (B1-B2)
        } else if (cls.code.includes("C1") || cls.code.includes("C2")) {
          teacherId = teacherIds[2]; // Michael Brown (C1-C2)
        } else {
          teacherId = teacherIds[7]; // Emily Davis (fallback)
        }
      }

      if (teacherId) {
        try {
          // Check if already assigned
          const [existing] = await conn.query(
            "SELECT id FROM class_teachers WHERE class_id = ? AND user_id = ?",
            [cls.id, teacherId]
          );

          if (existing.length === 0) {
            await conn.query(
              `INSERT INTO class_teachers (class_id, user_id, role, start_date)
               VALUES (?, ?, ?, CURDATE())`,
              [cls.id, teacherId, "teacher"]
            );
            assigned++;

            // Get teacher name
            const [teacher] = await conn.query(
              "SELECT full_name FROM users WHERE id = ?",
              [teacherId]
            );

            log.success(`Assigned: ${cls.code} -> ${teacher[0].full_name}`);
          } else {
            log.info(`Skipped (exists): ${cls.code}`);
          }
        } catch (error) {
          assignFailed++;
          log.error(`Failed to assign ${cls.code}: ${error.message}`);
        }
      }
    }

    // Summary
    console.log("\n" + "=".repeat(60));
    console.log("📊 SUMMARY");
    console.log("=".repeat(60));
    console.log(`Teachers Created: ${created}`);
    console.log(`Teachers Skipped: ${skipped}`);
    console.log(`Total Teachers: ${teacherIds.length}`);
    console.log(`Classes Assigned: ${assigned}`);
    console.log(`Assignment Failed: ${assignFailed}`);
    console.log("=".repeat(60) + "\n");

    if (created > 0 || assigned > 0) {
      log.success("Teachers seeded and assigned successfully!");
      log.info("Teacher login credentials:");
      log.info("  Email: [teacher-email]@sysedu.com");
      log.info("  Password: teacher123");
    }
  } finally {
    await conn.end();
  }
}

seedTeachers().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
