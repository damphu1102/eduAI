const { promisePool } = require("../src/config/database");
require("dotenv").config();

async function checkSchema() {
  try {
    console.log("🔍 Checking class_teachers table schema...\n");

    const [rows] = await promisePool.query("DESCRIBE class_teachers");

    console.log("📋 Table structure:");
    console.table(rows);

    console.log("\n✅ Schema check complete!");
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
}

checkSchema();
