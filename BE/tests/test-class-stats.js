const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function testClassStats() {
  try {
    console.log("🔍 Testing Class Stats API...\n");

    // 1. Login
    console.log("1️⃣ Logging in...");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Login successful\n");

    // 2. Get class stats
    console.log("2️⃣ Fetching class statistics...");
    const statsResponse = await axios.get(`${API_URL}/classes/stats`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    console.log("✅ Stats fetched successfully:");
    console.log(JSON.stringify(statsResponse.data, null, 2));
    console.log("");

    const stats = statsResponse.data.data;
    console.log("📊 Summary:");
    console.log(`   Total Classes: ${stats.total}`);
    console.log(`   Active: ${stats.active}`);
    console.log(`   Draft: ${stats.draft}`);
    console.log(`   Completed: ${stats.completed}`);
    console.log(`   Cancelled: ${stats.cancelled}`);

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

testClassStats();
