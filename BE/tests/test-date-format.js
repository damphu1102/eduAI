const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function testDateFormat() {
  try {
    console.log("🔍 Testing Date Format Fix...\n");

    // 1. Login
    console.log("1️⃣ Logging in...");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Login successful\n");

    const config = {
      headers: { Authorization: `Bearer ${token}` },
    };

    // 2. Create class with ISO date format
    console.log("2️⃣ Creating class with ISO date format...");
    const createData = {
      name: "Date Format Test Class",
      code: "DATE-TEST-001",
      description: "Testing date format conversion",
      level: "A1",
      language: "en",
      max_students: 20,
      status: "draft",
      start_date: "2025-10-31T17:00:00.000Z", // ISO format
      end_date: "2025-11-29T17:00:00.000Z", // ISO format
      schedule: {
        days: ["Monday", "Wednesday", "Friday"],
        time: "09:00-11:00",
        timezone: "Asia/Ho_Chi_Minh",
      },
      room: "Room 101",
    };

    console.log("   Start date (ISO):", createData.start_date);
    console.log("   End date (ISO):", createData.end_date);

    const createResponse = await axios.post(
      `${API_URL}/classes`,
      createData,
      config
    );

    const createdClass = createResponse.data.data;
    console.log("✅ Class created successfully");
    console.log("   Class ID:", createdClass.id);
    console.log("   Start date (stored):", createdClass.start_date);
    console.log("   End date (stored):", createdClass.end_date);
    console.log("");

    // 3. Update class with ISO date format
    console.log("3️⃣ Updating class with ISO date format...");
    const updateData = {
      name: "Date Format Test Class (Updated)",
      description: "Updated with new dates",
      start_date: "2025-12-01T17:00:00.000Z", // New ISO format date
      end_date: "2025-12-31T17:00:00.000Z", // New ISO format date
    };

    console.log("   New start date (ISO):", updateData.start_date);
    console.log("   New end date (ISO):", updateData.end_date);

    const updateResponse = await axios.put(
      `${API_URL}/classes/${createdClass.id}`,
      updateData,
      config
    );

    const updatedClass = updateResponse.data.data;
    console.log("✅ Class updated successfully");
    console.log("   Start date (stored):", updatedClass.start_date);
    console.log("   End date (stored):", updatedClass.end_date);
    console.log("");

    // 4. Verify dates are in correct format
    console.log("4️⃣ Verifying date format...");
    const verifyResponse = await axios.get(
      `${API_URL}/classes/${createdClass.id}`,
      config
    );

    const verifiedClass = verifyResponse.data.data;
    const startDate = verifiedClass.start_date;
    const endDate = verifiedClass.end_date;

    console.log("   Start date:", startDate);
    console.log("   End date:", endDate);

    // Check if dates are in YYYY-MM-DD format
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    const startDateValid = dateRegex.test(startDate);
    const endDateValid = dateRegex.test(endDate);

    if (startDateValid && endDateValid) {
      console.log("✅ Dates are in correct MySQL format (YYYY-MM-DD)\n");
    } else {
      console.log("❌ Dates are not in correct format\n");
      process.exit(1);
    }

    // 5. Clean up - delete test class
    console.log("5️⃣ Cleaning up...");
    await axios.delete(`${API_URL}/classes/${createdClass.id}`, config);
    console.log("✅ Test class deleted\n");

    console.log("✅ All date format tests passed!");
    console.log("\n📝 Summary:");
    console.log("   - ISO format dates are accepted");
    console.log("   - Dates are converted to MySQL DATE format");
    console.log("   - Both create and update work correctly");
    process.exit(0);
  } catch (error) {
    console.error("\n❌ Test failed:");
    if (error.response) {
      console.error("Status:", error.response.status);
      console.error("Message:", error.response.data.message);
      console.error("Error:", error.response.data.error);
      if (error.response.data.error) {
        console.error("\nSQL Error:", error.response.data.error);
      }
    } else {
      console.error(error.message);
    }
    process.exit(1);
  }
}

testDateFormat();
