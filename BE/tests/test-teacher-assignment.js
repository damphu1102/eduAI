const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function testTeacherAssignment() {
  try {
    console.log("🔍 Testing Teacher Assignment API...\n");

    // 1. Login
    console.log("1️⃣ Logging in...");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Login successful\n");

    // 2. Get teachers list
    console.log("2️⃣ Fetching teachers...");
    const teachersResponse = await axios.get(`${API_URL}/users`, {
      headers: { Authorization: `Bearer ${token}` },
      params: { role: "teacher", limit: 10 },
    });

    const teachers = teachersResponse.data.data.users;
    console.log(`✅ Found ${teachers.length} teachers:`);
    teachers.forEach((t) => {
      console.log(`   - ${t.full_name} (${t.email})`);
    });
    console.log("");

    if (teachers.length === 0) {
      console.log("⚠️  No teachers found. Please seed teachers first.");
      process.exit(0);
    }

    // 3. Get first class
    console.log("3️⃣ Fetching classes...");
    const classesResponse = await axios.get(`${API_URL}/classes`, {
      headers: { Authorization: `Bearer ${token}` },
      params: { limit: 1 },
    });

    const firstClass = classesResponse.data.data.classes[0];
    if (!firstClass) {
      console.log("⚠️  No classes found. Please create a class first.");
      process.exit(0);
    }

    console.log(`✅ Using class: ${firstClass.name} (ID: ${firstClass.id})\n`);

    // 4. Assign teachers to class
    console.log("4️⃣ Assigning teachers to class...");
    const teacherIds = teachers.slice(0, 2).map((t) => t.id); // Assign first 2 teachers
    console.log(`   Assigning teacher IDs: ${teacherIds.join(", ")}`);

    const assignResponse = await axios.post(
      `${API_URL}/classes/${firstClass.id}/teachers`,
      { teacher_ids: teacherIds },
      { headers: { Authorization: `Bearer ${token}` } }
    );

    console.log("✅ Teachers assigned successfully\n");

    // 5. Verify assignment
    console.log("5️⃣ Verifying assignment...");
    const verifyResponse = await axios.get(
      `${API_URL}/classes/${firstClass.id}`,
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );

    const assignedTeachers = verifyResponse.data.data.teachers;
    console.log(`✅ Class now has ${assignedTeachers.length} teacher(s):`);
    assignedTeachers.forEach((t) => {
      console.log(`   - ${t.full_name} (${t.email}) - Role: ${t.role}`);
    });

    console.log("\n✅ All tests passed!");
    process.exit(0);
  } catch (error) {
    console.error("❌ Test failed:");
    if (error.response) {
      console.error("Status:", error.response.status);
      console.error("Data:", error.response.data);
    } else {
      console.error(error.message);
    }
    process.exit(1);
  }
}

testTeacherAssignment();
