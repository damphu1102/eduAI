const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function testTeacherUpdate() {
  try {
    console.log("🔍 Testing Teacher Update (Add/Remove)...\n");

    // 1. Login
    console.log("1️⃣ Logging in...");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Login successful\n");

    const config = {
      headers: { Authorization: `Bearer ${token}` },
    };

    // 2. Get teachers list
    console.log("2️⃣ Fetching teachers...");
    const teachersResponse = await axios.get(`${API_URL}/users`, {
      ...config,
      params: { role: "teacher", limit: 10 },
    });

    const teachers = teachersResponse.data.data.users;
    console.log(`✅ Found ${teachers.length} teachers\n`);

    if (teachers.length < 3) {
      console.log("⚠️  Need at least 3 teachers for this test.");
      process.exit(0);
    }

    // 3. Get first class
    console.log("3️⃣ Fetching classes...");
    const classesResponse = await axios.get(`${API_URL}/classes`, {
      ...config,
      params: { limit: 1 },
    });

    const testClass = classesResponse.data.data.classes[0];
    if (!testClass) {
      console.log("⚠️  No classes found.");
      process.exit(0);
    }

    console.log(`✅ Using class: ${testClass.name} (ID: ${testClass.id})\n`);

    // 4. Initial assignment - 2 teachers
    console.log("4️⃣ Initial assignment: 2 teachers...");
    const initialTeachers = [teachers[0].id, teachers[1].id];
    console.log(`   Teacher IDs: ${initialTeachers.join(", ")}`);

    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: initialTeachers },
      config
    );

    console.log("✅ Initial assignment successful\n");

    // Verify
    let verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log(
      `   Verified: ${verifyResponse.data.data.teachers.length} teacher(s)`
    );
    verifyResponse.data.data.teachers.forEach((t) => {
      console.log(`   - ${t.full_name}`);
    });
    console.log("");

    // 5. Add one more teacher (now 3 teachers)
    console.log("5️⃣ Adding one more teacher (total 3)...");
    const addTeachers = [teachers[0].id, teachers[1].id, teachers[2].id];
    console.log(`   Teacher IDs: ${addTeachers.join(", ")}`);

    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: addTeachers },
      config
    );

    console.log("✅ Teacher added successfully\n");

    // Verify
    verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log(
      `   Verified: ${verifyResponse.data.data.teachers.length} teacher(s)`
    );
    verifyResponse.data.data.teachers.forEach((t) => {
      console.log(`   - ${t.full_name}`);
    });
    console.log("");

    // 6. Remove one teacher (back to 2 teachers)
    console.log("6️⃣ Removing one teacher (back to 2)...");
    const removeTeachers = [teachers[0].id, teachers[2].id];
    console.log(`   Teacher IDs: ${removeTeachers.join(", ")}`);

    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: removeTeachers },
      config
    );

    console.log("✅ Teacher removed successfully\n");

    // Verify
    verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log(
      `   Verified: ${verifyResponse.data.data.teachers.length} teacher(s)`
    );
    verifyResponse.data.data.teachers.forEach((t) => {
      console.log(`   - ${t.full_name}`);
    });
    console.log("");

    // 7. Remove all teachers
    console.log("7️⃣ Removing all teachers...");
    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: [] },
      config
    );

    console.log("✅ All teachers removed\n");

    // Verify
    verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );
    console.log(
      `   Verified: ${verifyResponse.data.data.teachers.length} teacher(s)`
    );
    console.log("");

    console.log("✅ All tests passed!");
    process.exit(0);
  } catch (error) {
    console.error("\n❌ Test failed:");
    if (error.response) {
      console.error("Status:", error.response.status);
      console.error("Data:", JSON.stringify(error.response.data, null, 2));
      console.error("\nRequest URL:", error.config.url);
      console.error(
        "Request Data:",
        JSON.stringify(error.config.data, null, 2)
      );
    } else {
      console.error(error.message);
      console.error(error.stack);
    }
    process.exit(1);
  }
}

testTeacherUpdate();
