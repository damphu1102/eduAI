const { promisePool } = require("../src/config/database");
const bcrypt = require("bcryptjs");

async function testDatabase() {
  try {
    console.log("🔍 Checking database tables...");

    // Check if users table exists
    const [tables] = await promisePool.query("SHOW TABLES LIKE 'users'");

    if (tables.length === 0) {
      console.log("📝 Creating users table...");
      await promisePool.query(`
        CREATE TABLE users (
          id INT PRIMARY KEY AUTO_INCREMENT,
          email VARCHAR(255) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          full_name VARCHAR(255) NOT NULL,
          role ENUM('admin', 'teacher', 'student', 'parent') DEFAULT 'student',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP NULL,
          deleted_at TIMESTAMP NULL
        )
      `);
      console.log("✅ Users table created");
    } else {
      console.log("✅ Users table exists");
    }

    // Check if test user exists
    const [users] = await promisePool.query(
      "SELECT * FROM users WHERE email = 'admin@example.com'"
    );

    if (users.length === 0) {
      console.log("📝 Creating test admin user...");
      const hashedPassword = await bcrypt.hash("password123", 10);

      await promisePool.query(
        "INSERT INTO users (email, password_hash, full_name, role) VALUES (?, ?, ?, ?)",
        ["admin@example.com", hashedPassword, "Admin User", "admin"]
      );
      console.log("✅ Test admin user created");
      console.log("   Email: admin@example.com");
      console.log("   Password: password123");
    } else {
      console.log("✅ Test admin user already exists");
      console.log("   Email: admin@example.com");
      console.log("   Password: password123");
    }

    // Create classes table
    const [classTables] = await promisePool.query("SHOW TABLES LIKE 'classes'");
    if (classTables.length === 0) {
      console.log("📝 Creating classes table...");
      await promisePool.query(`
        CREATE TABLE classes (
          id INT PRIMARY KEY AUTO_INCREMENT,
          name VARCHAR(255) NOT NULL,
          description TEXT,
          status ENUM('active', 'inactive') DEFAULT 'active',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP NULL,
          deleted_at TIMESTAMP NULL
        )
      `);
      console.log("✅ Classes table created");
    }

    // Create courses table
    const [courseTables] = await promisePool.query(
      "SHOW TABLES LIKE 'courses'"
    );
    if (courseTables.length === 0) {
      console.log("📝 Creating courses table...");
      await promisePool.query(`
        CREATE TABLE courses (
          id INT PRIMARY KEY AUTO_INCREMENT,
          name VARCHAR(255) NOT NULL,
          description TEXT,
          category VARCHAR(100),
          duration INT,
          status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP NULL,
          deleted_at TIMESTAMP NULL
        )
      `);
      console.log("✅ Courses table created");
    }

    console.log("\n✅ Database setup completed successfully!");
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
}

testDatabase();
