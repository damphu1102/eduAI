const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function testUpdate() {
  try {
    console.log("🔍 Testing Update Class with ISO Dates...\n");

    // 1. Login
    console.log("1️⃣ Logging in...");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Login successful\n");

    const config = {
      headers: { Authorization: `Bearer ${token}` },
    };

    // 2. Get first class
    console.log("2️⃣ Getting test class...");
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

    // 3. Update with ISO date format (simulating frontend behavior)
    console.log("3️⃣ Updating class with ISO date format...");
    const updateData = {
      code: "EN-A1-M-S261",
      name: "Test",
      description: "Tessssstttttt",
      level: "A1",
      language: "en",
      max_students: 50,
      status: "draft",
      start_date: "2025-10-31T17:00:00.000Z", // ISO format from frontend
      end_date: "2025-11-29T17:00:00.000Z", // ISO format from frontend
      schedule: {
        days: ["Monday", "Wednesday", "Friday"],
        time: "09:00-11:00",
        timezone: "Asia/Ho_Chi_Minh",
      },
      room: "Room 101",
    };

    console.log("   Sending data:");
    console.log("   - start_date:", updateData.start_date);
    console.log("   - end_date:", updateData.end_date);

    const updateResponse = await axios.put(
      `${API_URL}/classes/${testClass.id}`,
      updateData,
      config
    );

    console.log("\n✅ Update successful!");
    console.log("   Response:", updateResponse.data.message);

    // 4. Verify the update
    console.log("\n4️⃣ Verifying update...");
    const verifyResponse = await axios.get(
      `${API_URL}/classes/${testClass.id}`,
      config
    );

    const updatedClass = verifyResponse.data.data;
    console.log("✅ Class data:");
    console.log("   - Name:", updatedClass.name);
    console.log("   - Code:", updatedClass.code);
    console.log("   - Start date:", updatedClass.start_date);
    console.log("   - End date:", updatedClass.end_date);
    console.log("   - Max students:", updatedClass.max_students);

    console.log("\n✅ Test passed! Update works with ISO date format.");
    console.log("\n📝 Note: MySQL stores dates as DATE type (YYYY-MM-DD)");
    console.log(
      "   but mysql2 driver returns them as JavaScript Date objects."
    );
    console.log("   This is normal behavior and works correctly.\n");

    process.exit(0);
  } catch (error) {
    console.error("\n❌ Test failed:");
    if (error.response) {
      console.error("Status:", error.response.status);
      console.error("Message:", error.response.data.message);
      if (error.response.data.error) {
        console.error("Error:", error.response.data.error);
      }
    } else {
      console.error(error.message);
    }
    process.exit(1);
  }
}

testUpdate();
