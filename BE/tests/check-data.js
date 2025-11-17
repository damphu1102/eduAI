const axios = require("axios");

async function checkData() {
  try {
    // Login
    const loginRes = await axios.post("http://localhost:5000/api/auth/login", {
      email: "admin@example.com",
      password: "password123",
    });

    const token = loginRes.data.data.token;

    // Get all classes
    const classesRes = await axios.get(
      "http://localhost:5000/api/classes?page=1&limit=20",
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );

    const { classes, pagination } = classesRes.data.data;

    console.log("\n📊 DATABASE SUMMARY\n");
    console.log(`Total Classes: ${pagination.total}`);

    // Count by status
    const byStatus = {};
    classes.forEach((c) => {
      byStatus[c.status] = (byStatus[c.status] || 0) + 1;
    });

    console.log("\nClasses by Status:");
    Object.entries(byStatus).forEach(([status, count]) => {
      console.log(`  ${status}: ${count}`);
    });

    // Count by language
    const byLanguage = {};
    classes.forEach((c) => {
      byLanguage[c.language] = (byLanguage[c.language] || 0) + 1;
    });

    console.log("\nClasses by Language:");
    Object.entries(byLanguage).forEach(([lang, count]) => {
      console.log(`  ${lang}: ${count}`);
    });

    // Count by level
    const byLevel = {};
    classes.forEach((c) => {
      byLevel[c.level] = (byLevel[c.level] || 0) + 1;
    });

    console.log("\nClasses by Level:");
    Object.entries(byLevel).forEach(([level, count]) => {
      console.log(`  ${level}: ${count}`);
    });

    console.log("\n✅ Data check complete!\n");
  } catch (error) {
    console.error("Error:", error.message);
  }
}

checkData();
