const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function testDateConsistency() {
  try {
    console.log(
      "🔍 Testing Date Consistency between classes and class_teachers...\n"
    );

    // 1. Login
    console.log("1️⃣ Logging in...");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Login successful\n");

    const config = {
      headers: { Authorization: `Bearer ${token}` },
    };

    // 2. Create a test class with specific dates
    console.log("2️⃣ Creating test class with specific dates...");
    const testDates = {
      start_date: "2025-11-01",
      end_date: "2025-12-31",
    };

    const createResponse = await axios.post(
      `${API_URL}/classes`,
      {
        name: "Date Consistency Test",
        code: "DATE-TEST",
        description: "Testing date consistency",
        level: "A1",
        language: "en",
        max_students: 20,
        status: "draft",
        start_date: testDates.start_date,
        end_date: testDates.end_date,
      },
      config
    );

    const testClass = createResponse.data.data;
    console.log("✅ Class created");
    console.log(`   Class ID: ${testClass.id}`);
    console.log(`   Start Date: ${testClass.start_date}`);
    console.log(`   End Date: ${testClass.end_date}\n`);

    // 3. Get teacher
    const teachersResponse = await axios.get(`${API_URL}/users`, {
      ...config,
      params: { role: "teacher", limit: 1 },
    });

    const teacher = teachersResponse.data.data.users[0];
    if (!teacher) {
      console.log("⚠️  No teachers found.");
      process.exit(0);
    }

    // 4. Assign teacher (should use class dates)
    console.log("3️⃣ Assigning teacher (should use class dates)...");
    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: [teacher.id] },
      config
    );
    console.log("✅ Teacher assigned\n");

    // 5. Verify dates match
    console.log("4️⃣ Verifying date consistency...");
    const verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );

    const classData = verifyResponse.data.data;
    const assignedTeacher = classData.teachers[0];

    console.log("📅 Class Dates:");
    console.log(`   Start: ${classData.start_date}`);
    console.log(`   End: ${classData.end_date}`);
    console.log("");
    console.log("📅 Teacher Assignment Dates:");
    console.log(`   Start: ${assignedTeacher.start_date}`);
    console.log(`   End: ${assignedTeacher.end_date}`);
    console.log("");

    // Extract date part only (ignore time)
    const extractDate = (dateStr) => {
      if (!dateStr) return null;
      return dateStr.split("T")[0];
    };

    const classStart = extractDate(classData.start_date);
    const classEnd = extractDate(classData.end_date);
    const teacherStart = extractDate(assignedTeacher.start_date);
    const teacherEnd = extractDate(assignedTeacher.end_date);

    console.log("📊 Comparison (date part only):");
    console.log(`   Class Start:   ${classStart}`);
    console.log(`   Teacher Start: ${teacherStart}`);
    console.log(`   Match: ${classStart === teacherStart ? "✅" : "❌"}`);
    console.log("");
    console.log(`   Class End:     ${classEnd}`);
    console.log(`   Teacher End:   ${teacherEnd}`);
    console.log(`   Match: ${classEnd === teacherEnd ? "✅" : "❌"}`);
    console.log("");

    // Check if dates match
    if (classStart === teacherStart && classEnd === teacherEnd) {
      console.log("✅ Dates are consistent!");
    } else {
      console.log("❌ Dates are NOT consistent!");
      console.log("\n⚠️  Expected:");
      console.log(`   Teacher dates should match class dates`);
      console.log(`   Class: ${classStart} to ${classEnd}`);
      console.log(`   Teacher: ${teacherStart} to ${teacherEnd}`);

      // Clean up
      await axios.delete(`${API_URL}/classes/${testClass.id}`, config);
      process.exit(1);
    }

    // 6. Test with custom dates
    console.log("\n5️⃣ Testing with custom teacher dates...");
    const customDates = {
      start_date: "2025-11-15",
      end_date: "2025-12-15",
    };

    await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      {
        teachers: [
          {
            id: teacher.id,
            start_date: customDates.start_date,
            end_date: customDates.end_date,
          },
        ],
      },
      config
    );
    console.log("✅ Teacher assigned with custom dates\n");

    // Verify custom dates
    const verifyCustom = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );

    const customTeacher = verifyCustom.data.data.teachers[0];
    const customTeacherStart = extractDate(customTeacher.start_date);
    const customTeacherEnd = extractDate(customTeacher.end_date);

    console.log("📅 Custom Teacher Dates:");
    console.log(`   Expected Start: ${customDates.start_date}`);
    console.log(`   Actual Start:   ${customTeacherStart}`);
    console.log(
      `   Match: ${customDates.start_date === customTeacherStart ? "✅" : "❌"}`
    );
    console.log("");
    console.log(`   Expected End:   ${customDates.end_date}`);
    console.log(`   Actual End:     ${customTeacherEnd}`);
    console.log(
      `   Match: ${customDates.end_date === customTeacherEnd ? "✅" : "❌"}`
    );
    console.log("");

    if (
      customDates.start_date === customTeacherStart &&
      customDates.end_date === customTeacherEnd
    ) {
      console.log("✅ Custom dates are correct!");
    } else {
      console.log("❌ Custom dates are NOT correct!");

      // Clean up
      await axios.delete(`${API_URL}/classes/${testClass.id}`, config);
      process.exit(1);
    }

    // 7. Clean up
    console.log("\n6️⃣ Cleaning up...");
    await axios.delete(`${API_URL}/classes/${testClass.id}`, config);
    console.log("✅ Test class deleted\n");

    console.log("✅ All date consistency tests passed!");
    console.log("\n📝 Summary:");
    console.log("   - Class dates and teacher dates match");
    console.log("   - No date offset issues");
    console.log("   - Custom dates work correctly\n");

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

testDateConsistency();
