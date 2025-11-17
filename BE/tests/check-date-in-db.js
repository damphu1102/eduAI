const { promisePool } = require("../src/config/database");
require("dotenv").config();

async function checkDates() {
  try {
    console.log("🔍 Checking dates in database...\n");

    // Get a class with teachers
    const [classes] = await promisePool.query(
      `SELECT id, name, start_date, end_date 
       FROM classes 
       WHERE id IN (SELECT DISTINCT class_id FROM class_teachers)
       LIMIT 1`
    );

    if (classes.length === 0) {
      console.log("⚠️  No classes with teachers found.");
      process.exit(0);
    }

    const classData = classes[0];
    console.log("📚 Class:");
    console.log(`   ID: ${classData.id}`);
    console.log(`   Name: ${classData.name}`);
    console.log(`   Start Date (raw): ${classData.start_date}`);
    console.log(`   Start Date (type): ${typeof classData.start_date}`);
    console.log(`   End Date (raw): ${classData.end_date}`);
    console.log(`   End Date (type): ${typeof classData.end_date}`);
    console.log("");

    // Get teachers for this class
    const [teachers] = await promisePool.query(
      `SELECT ct.*, u.full_name
       FROM class_teachers ct
       JOIN users u ON ct.user_id = u.id
       WHERE ct.class_id = ?`,
      [classData.id]
    );

    console.log("👨‍🏫 Teachers:");
    teachers.forEach((t, i) => {
      console.log(`   ${i + 1}. ${t.full_name}`);
      console.log(`      Start Date (raw): ${t.start_date}`);
      console.log(`      Start Date (type): ${typeof t.start_date}`);
      console.log(`      End Date (raw): ${t.end_date}`);
      console.log(`      End Date (type): ${typeof t.end_date}`);
      console.log("");
    });

    // Check raw SQL
    console.log("📊 Raw SQL Query:");
    const [rawData] = await promisePool.query(
      `SELECT 
        c.id as class_id,
        c.start_date as class_start,
        c.end_date as class_end,
        ct.start_date as teacher_start,
        ct.end_date as teacher_end,
        DATE_FORMAT(c.start_date, '%Y-%m-%d') as class_start_formatted,
        DATE_FORMAT(ct.start_date, '%Y-%m-%d') as teacher_start_formatted
       FROM classes c
       JOIN class_teachers ct ON c.id = ct.class_id
       WHERE c.id = ?`,
      [classData.id]
    );

    console.log("   Results:");
    rawData.forEach((row, i) => {
      console.log(`   Row ${i + 1}:`);
      console.log(`      Class Start: ${row.class_start}`);
      console.log(`      Teacher Start: ${row.teacher_start}`);
      console.log(
        `      Class Start (formatted): ${row.class_start_formatted}`
      );
      console.log(
        `      Teacher Start (formatted): ${row.teacher_start_formatted}`
      );
      console.log(
        `      Match: ${
          row.class_start_formatted === row.teacher_start_formatted
            ? "✅"
            : "❌"
        }`
      );
      console.log("");
    });

    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
}

checkDates();
