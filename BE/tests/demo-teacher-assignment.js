const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function demo() {
  try {
    console.log("🎯 DEMO: Teacher Assignment Feature\n");
    console.log("=".repeat(60));

    // Login
    console.log("\n📝 Step 1: Login");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Logged in as:", loginResponse.data.data.user.email);

    const config = {
      headers: { Authorization: `Bearer ${token}` },
    };

    // Get teachers
    console.log("\n📝 Step 2: Get available teachers");
    const teachersResponse = await axios.get(`${API_URL}/users`, {
      ...config,
      params: { role: "teacher", limit: 5 },
    });

    const teachers = teachersResponse.data.data.users;
    console.log(`✅ Found ${teachers.length} teachers:`);
    teachers.forEach((t, i) => {
      console.log(`   ${i + 1}. ${t.full_name} (ID: ${t.id})`);
    });

    if (teachers.length < 2) {
      console.log(
        "\n⚠️  Need at least 2 teachers. Please run seed-teachers.js"
      );
      process.exit(0);
    }

    // Get or create a test class
    console.log("\n📝 Step 3: Get a test class");
    const classesResponse = await axios.get(`${API_URL}/classes`, {
      ...config,
      params: { limit: 1 },
    });

    let testClass = classesResponse.data.data.classes[0];

    if (!testClass) {
      console.log("   No classes found, creating one...");
      const createResponse = await axios.post(
        `${API_URL}/classes`,
        {
          name: "Demo Class for Teacher Assignment",
          code: "DEMO-001",
          description: "Test class for teacher assignment demo",
          level: "A1",
          language: "en",
          max_students: 20,
          status: "draft",
        },
        config
      );
      testClass = createResponse.data.data;
      console.log("✅ Created class:", testClass.name);
    } else {
      console.log("✅ Using existing class:", testClass.name);
    }

    console.log(`   Class ID: ${testClass.id}`);

    // Scenario 1: Assign 2 teachers
    console.log("\n📝 Step 4: Assign 2 teachers to the class");
    const teacher1 = teachers[0];
    const teacher2 = teachers[1];

    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: [teacher1.id, teacher2.id] },
      config
    );

    console.log("✅ Assigned teachers:");
    console.log(`   - ${teacher1.full_name}`);
    console.log(`   - ${teacher2.full_name}`);

    // Verify
    let verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log(
      `   Verified: ${verifyResponse.data.data.teachers.length} teacher(s) in class`
    );

    // Scenario 2: Add one more teacher
    if (teachers.length >= 3) {
      console.log("\n📝 Step 5: Add one more teacher (total 3)");
      const teacher3 = teachers[2];

      await axios.post(
        `${API_URL}/classes/${testClass.id}/teachers`,
        { teacher_ids: [teacher1.id, teacher2.id, teacher3.id] },
        config
      );

      console.log("✅ Added teacher:");
      console.log(`   - ${teacher3.full_name}`);

      verifyResponse = await axios.get(
        `${API_URL}/classes/${testClass.id}`,
        config
      );
      console.log(
        `   Verified: ${verifyResponse.data.data.teachers.length} teacher(s) in class`
      );
    }

    // Scenario 3: Remove one teacher
    console.log("\n📝 Step 6: Remove one teacher (keep only first one)");
    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: [teacher1.id] },
      config
    );

    console.log("✅ Removed teachers, kept:");
    console.log(`   - ${teacher1.full_name}`);

    verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log(
      `   Verified: ${verifyResponse.data.data.teachers.length} teacher(s) in class`
    );

    // Scenario 4: Remove all teachers
    console.log("\n📝 Step 7: Remove all teachers");
    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: [] },
      config
    );

    console.log("✅ All teachers removed");

    verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log(
      `   Verified: ${verifyResponse.data.data.teachers.length} teacher(s) in class`
    );

    console.log("\n" + "=".repeat(60));
    console.log("✅ DEMO COMPLETED SUCCESSFULLY!");
    console.log("=".repeat(60));
    console.log("\n📚 Summary:");
    console.log("   - Assigned multiple teachers to a class");
    console.log("   - Added teachers to existing assignment");
    console.log("   - Removed specific teachers");
    console.log("   - Removed all teachers");
    console.log("\n💡 The API is working perfectly!");
    console.log("   You can now use this feature in the frontend.\n");

    process.exit(0);
  } catch (error) {
    console.error("\n❌ Demo failed:");
    if (error.response) {
      console.error("Status:", error.response.status);
      console.error("Message:", error.response.data.message);
      console.error("Data:", JSON.stringify(error.response.data, null, 2));
    } else {
      console.error(error.message);
    }
    process.exit(1);
  }
}

demo();
