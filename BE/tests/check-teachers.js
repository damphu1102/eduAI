const mysql = require("mysql2/promise");
require("dotenv").config();

async function checkTeachers() {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
  });

  try {
    console.log("\n=== TEACHERS (role=teacher) ===");
    const [teachers] = await conn.query(
      "SELECT id, email, full_name, role FROM users WHERE role = ? AND deleted_at IS NULL",
      ["teacher"]
    );
    console.log("Count:", teachers.length);
    teachers.forEach((t) => {
      console.log(`  ${t.id}: ${t.full_name} (${t.email})`);
    });

    console.log("\n=== CLASS_TEACHERS ===");
    const [ct] = await conn.query("SELECT * FROM class_teachers");
    console.log("Count:", ct.length);
    if (ct.length > 0) {
      ct.forEach((c) => {
        console.log(`  Class ${c.class_id} -> User ${c.user_id} (${c.role})`);
      });
    }

    console.log("\n=== CLASSES ===");
    const [classes] = await conn.query(
      "SELECT id, code, name FROM classes LIMIT 5"
    );
    console.log("Sample classes:", classes.length);
    classes.forEach((c) => {
      console.log(`  ${c.id}: ${c.code} - ${c.name}`);
    });
  } finally {
    await conn.end();
  }
}

checkTeachers().catch(console.error);
