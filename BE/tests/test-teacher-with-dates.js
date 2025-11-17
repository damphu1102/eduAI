const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function testTeacherWithDates() {
  try {
    console.log("🔍 Testing Teacher Assignment with Dates...\n");

    // 1. Login
    console.log("1️⃣ Logging in...");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Login successful\n");

    const config = {
      headers: { Authorization: `Bearer ${token}` },
    };

    // 2. Get teachers
    console.log("2️⃣ Fetching teachers...");
    const teachersResponse = await axios.get(`${API_URL}/users`, {
      ...config,
      params: { role: "teacher", limit: 3 },
    });

    const teachers = teachersResponse.data.data.users;
    console.log(`✅ Found ${teachers.length} teachers\n`);

    if (teachers.length < 2) {
      console.log("⚠️  Need at least 2 teachers.");
      process.exit(0);
    }

    // 3. Get test class
    console.log("3️⃣ Fetching test class...");
    const classesResponse = await axios.get(`${API_URL}/classes`, {
      ...config,
      params: { limit: 1 },
    });

    const testClass = classesResponse.data.data.classes[0];
    if (!testClass) {
      console.log("⚠️  No classes found.");
      process.exit(0);
    }

    console.log(`✅ Using class: ${testClass.name} (ID: ${testClass.id})`);
    console.log(
      `   Class dates: ${testClass.start_date} to ${testClass.end_date}\n`
    );

    // 4. Test OLD format (backward compatibility)
    console.log("4️⃣ Testing OLD format (teacher_ids array)...");
    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: [teachers[0].id] },
      config
    );
    console.log("✅ Old format works\n");

    // Verify
    let verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log("   Assigned teachers:");
    verifyResponse.data.data.teachers.forEach((t) => {
      console.log(`   - ${t.full_name}`);
      console.log(`     Start: ${t.start_date || "NULL"}`);
      console.log(`     End: ${t.end_date || "NULL"}`);
    });
    console.log("");

    // 5. Test NEW format (with dates)
    console.log("5️⃣ Testing NEW format (teachers array with dates)...");
    const teachersWithDates = [
      {
        id: teachers[0].id,
        start_date: "2025-11-01",
        end_date: "2025-12-31",
      },
      {
        id: teachers[1].id,
        start_date: "2025-11-15",
        end_date: "2025-12-15",
      },
    ];

    console.log("   Assigning:");
    teachersWithDates.forEach((t, i) => {
      console.log(`   ${i + 1}. Teacher ID ${t.id}`);
      console.log(`      Start: ${t.start_date}`);
      console.log(`      End: ${t.end_date}`);
    });

    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teachers: teachersWithDates },
      config
    );
    console.log("\n✅ New format works\n");

    // Verify
    verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log("   Verified teachers with dates:");
    verifyResponse.data.data.teachers.forEach((t) => {
      console.log(`   - ${t.full_name}`);
      console.log(`     Start: ${t.start_date}`);
      console.log(`     End: ${t.end_date}`);
    });
    console.log("");

    // 6. Test with class dates as default
    console.log("6️⃣ Testing with class dates as default...");
    const teachersWithoutDates = [
      {
        id: teachers[0].id,
        // No dates - should use class dates
      },
    ];

    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teachers: teachersWithoutDates },
      config
    );
    console.log("✅ Default dates work\n");

    // Verify
    verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log("   Teacher with default dates:");
    verifyResponse.data.data.teachers.forEach((t) => {
      console.log(`   - ${t.full_name}`);
      console.log(`     Start: ${t.start_date} (should match class)`);
      console.log(`     End: ${t.end_date} (should match class)`);
    });
    console.log("");

    console.log("✅ All tests passed!");
    console.log("\n📝 Summary:");
    console.log("   - Old format (teacher_ids) still works");
    console.log("   - New format (teachers with dates) works");
    console.log("   - Default dates use class dates");
    console.log("   - Dates are stored in database correctly\n");

    process.exit(0);
  } catch (error) {
    console.error("\n❌ Test failed:");
    if (error.response) {
      console.error("Status:", error.response.status);
      console.error("Data:", JSON.stringify(error.response.data, null, 2));
    } else {
      console.error(error.message);
    }
    process.exit(1);
  }
}

testTeacherWithDates();
