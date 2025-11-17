const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function testValidation() {
  try {
    console.log("🔍 Testing Teacher Assignment Validation...\n");

    // 1. Login
    console.log("1️⃣ Logging in...");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Login successful\n");

    const config = {
      headers: { Authorization: `Bearer ${token}` },
    };

    // Get a test class
    const classesResponse = await axios.get(`${API_URL}/classes`, {
      ...config,
      params: { limit: 1 },
    });
    const testClass = classesResponse.data.data.classes[0];

    if (!testClass) {
      console.log("⚠️  No classes found.");
      process.exit(0);
    }

    console.log(`Using class: ${testClass.name} (ID: ${testClass.id})\n`);

    // Test 1: Invalid input - not an array
    console.log("2️⃣ Test: teacher_ids is not an array...");
    try {
      await axios.post(
        `${API_URL}/classes/${testClass.id}/teachers`,
        { teacher_ids: "invalid" },
        config
      );
      console.log("❌ Should have failed but didn't\n");
    } catch (error) {
      if (error.response?.status === 400) {
        console.log("✅ Correctly rejected:", error.response.data.message);
        console.log("");
      } else {
        throw error;
      }
    }

    // Test 2: Invalid teacher ID (negative number)
    console.log("3️⃣ Test: Negative teacher ID...");
    try {
      await axios.post(
        `${API_URL}/classes/${testClass.id}/teachers`,
        { teacher_ids: [-1, 1] },
        config
      );
      console.log("❌ Should have failed but didn't\n");
    } catch (error) {
      if (error.response?.status === 400) {
        console.log("✅ Correctly rejected:", error.response.data.message);
        console.log("");
      } else {
        throw error;
      }
    }

    // Test 3: Non-existent teacher ID
    console.log("4️⃣ Test: Non-existent teacher ID...");
    try {
      await axios.post(
        `${API_URL}/classes/${testClass.id}/teachers`,
        { teacher_ids: [999999] },
        config
      );
      console.log("❌ Should have failed but didn't\n");
    } catch (error) {
      if (error.response?.status === 400) {
        console.log("✅ Correctly rejected:", error.response.data.message);
        console.log("");
      } else {
        throw error;
      }
    }

    // Test 4: User ID that is not a teacher (try admin user)
    console.log("5️⃣ Test: User is not a teacher...");
    const adminResponse = await axios.get(`${API_URL}/users`, {
      ...config,
      params: { role: "admin", limit: 1 },
    });

    if (adminResponse.data.data.users.length > 0) {
      const adminId = adminResponse.data.data.users[0].id;
      try {
        await axios.post(
          `${API_URL}/classes/${testClass.id}/teachers`,
          { teacher_ids: [adminId] },
          config
        );
        console.log("❌ Should have failed but didn't\n");
      } catch (error) {
        if (error.response?.status === 400) {
          console.log("✅ Correctly rejected:", error.response.data.message);
          console.log("");
        } else {
          throw error;
        }
      }
    } else {
      console.log("⚠️  Skipped: No admin users found\n");
    }

    // Test 5: Non-existent class ID
    console.log("6️⃣ Test: Non-existent class ID...");
    try {
      await axios.post(
        `${API_URL}/classes/999999/teachers`,
        { teacher_ids: [] },
        config
      );
      console.log("❌ Should have failed but didn't\n");
    } catch (error) {
      if (error.response?.status === 404) {
        console.log("✅ Correctly rejected:", error.response.data.message);
        console.log("");
      } else {
        throw error;
      }
    }

    // Test 6: Empty array (should succeed - removes all teachers)
    console.log("7️⃣ Test: Empty array (valid - removes all)...");
    const emptyResponse = await axios.post(
      `${API_URL}/classes/${testClass.id}/teachers`,
      { teacher_ids: [] },
      config
    );
    console.log("✅ Success:", emptyResponse.data.message);
    console.log(`   Teacher count: ${emptyResponse.data.data.teacher_count}\n`);

    console.log("✅ All validation tests passed!");
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

testValidation();
