const bcrypt = require("bcryptjs");
const { promisePool } = require("../src/config/database");

async function addDemoUser() {
  try {
    console.log("🔍 Checking for demo user...");

    // Check if demo user exists
    const [existingUsers] = await promisePool.query(
      "SELECT * FROM users WHERE email = 'admin@sysedu.ai'"
    );

    if (existingUsers.length > 0) {
      console.log("⚠️  Demo user already exists");
      console.log("📝 Updating password to 'admin123'...");

      // Update password
      const hashedPassword = await bcrypt.hash("admin123", 10);
      await promisePool.query(
        "UPDATE users SET password_hash = ?, full_name = ?, role = ?, is_active = ?, deleted_at = NULL, updated_at = NOW() WHERE email = ?",
        [hashedPassword, "Admin User", "admin", 1, "admin@sysedu.ai"]
      );

      console.log("✅ Demo user updated successfully");
    } else {
      console.log("📝 Creating demo user...");

      // Hash password
      const hashedPassword = await bcrypt.hash("admin123", 10);

      // Insert demo user (tenant_id = 1 for default tenant)
      await promisePool.query(
        "INSERT INTO users (tenant_id, email, password_hash, full_name, role, is_active, mfa_enabled, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())",
        [1, "admin@sysedu.ai", hashedPassword, "Admin User", "admin", 1, 0]
      );

      console.log("✅ Demo user created successfully");
    }

    // Verify
    const [users] = await promisePool.query(
      "SELECT id, email, full_name, role, created_at FROM users WHERE email = 'admin@sysedu.ai'"
    );

    console.log("\n📋 Demo User Details:");
    console.log("Email:", users[0].email);
    console.log("Password: admin123");
    console.log("Full Name:", users[0].full_name);
    console.log("Role:", users[0].role);

    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error);
    process.exit(1);
  }
}

addDemoUser();
