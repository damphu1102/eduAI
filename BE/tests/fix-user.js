const { promisePool } = require("../src/config/database");
const bcrypt = require("bcryptjs");

async function fixUser() {
  try {
    console.log("🔍 Checking user...");

    // Check current user
    const [users] = await promisePool.query(
      "SELECT id, email, password_hash FROM users WHERE email = 'admin@example.com'"
    );

    if (users.length > 0) {
      console.log("Current user:", users[0]);

      // Update password
      console.log("📝 Updating password_hash...");
      const hashedPassword = await bcrypt.hash("password123", 10);

      await promisePool.query(
        "UPDATE users SET password_hash = ? WHERE email = ?",
        [hashedPassword, "admin@example.com"]
      );

      console.log("✅ password_hash updated successfully");
      console.log("   Email: admin@example.com");
      console.log("   Password: password123");

      // Verify
      const [updatedUsers] = await promisePool.query(
        "SELECT id, email, password_hash FROM users WHERE email = 'admin@example.com'"
      );
      console.log("Updated user:", updatedUsers[0]);
    } else {
      console.log("❌ User not found");
    }

    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
}

fixUser();
