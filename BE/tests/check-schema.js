const { promisePool } = require("../src/config/database");

async function checkSchema() {
  try {
    console.log("🔍 Checking users table schema...\n");

    const [columns] = await promisePool.query("DESCRIBE users");

    console.log("Current columns:");
    columns.forEach((col) => {
      console.log(
        `  - ${col.Field} (${col.Type}) ${
          col.Null === "NO" ? "NOT NULL" : "NULL"
        }`
      );
    });

    console.log("\n📝 Checking if password_hash column exists...");
    const hasPasswordHash = columns.some(
      (col) => col.Field === "password_hash"
    );

    if (!hasPasswordHash) {
      console.log("❌ password_hash column does not exist");
      console.log("📝 Adding password_hash column...");

      await promisePool.query(
        "ALTER TABLE users ADD COLUMN password_hash VARCHAR(255) AFTER email"
      );
      console.log("✅ password_hash column added");
    } else {
      console.log("✅ password_hash column exists");
    }

    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
}

checkSchema();
