const { promisePool } = require("../src/config/database");
const bcrypt = require("bcryptjs");

async function cleanupDatabase() {
  try {
    console.log("🔍 Checking database schema...\n");

    // Check if password column exists
    const [columns] = await promisePool.query("DESCRIBE users");
    const hasPassword = columns.some((col) => col.Field === "password");

    if (hasPassword) {
      console.log("📝 Removing password column...");
      await promisePool.query("ALTER TABLE users DROP COLUMN password");
      console.log("✅ Password column removed");
    } else {
      console.log("✅ Password column does not exist (already clean)");
    }

    // Update admin user password_hash
    console.log("\n📝 Updating admin user password_hash...");
    const hashedPassword = await bcrypt.hash("password123", 10);

    const [result] = await promisePool.query(
      "UPDATE users SET password_hash = ? WHERE email = ?",
      [hashedPassword, "admin@example.com"]
    );

    if (result.affectedRows > 0) {
      console.log("✅ Admin user password_hash updated");
      console.log("   Email: admin@example.com");
      console.log("   Password: password123");
    } else {
      console.log("⚠️  Admin user not found");
    }

    // Verify final schema
    console.log("\n📋 Final users table schema:");
    const [finalColumns] = await promisePool.query("DESCRIBE users");
    finalColumns.forEach((col) => {
      if (
        col.Field === "password_hash" ||
        col.Field === "email" ||
        col.Field === "full_name" ||
        col.Field === "role"
      ) {
        console.log(`  ✓ ${col.Field} (${col.Type})`);
      }
    });

    console.log("\n✅ Database cleanup completed successfully!");
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
}

cleanupDatabase();
