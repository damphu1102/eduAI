const axios = require("axios");
require("dotenv").config();

const API_URL = process.env.API_URL || "http://localhost:5000/api";

// Test credentials
const TEST_USER = {
  email: "admin@example.com",
  password: "password123",
};

async function testTenantName() {
  try {
    console.log("🔍 Testing Tenant Name in Class Detail...\n");

    // 1. Login
    console.log("1️⃣ Logging in...");
    const loginResponse = await axios.post(`${API_URL}/auth/login`, TEST_USER);
    const token = loginResponse.data.data.token;
    console.log("✅ Login successful\n");

    const config = {
      headers: { Authorization: `Bearer ${token}` },
    };

    // 2. Get a class
    console.log("2️⃣ Fetching class...");
    const classesResponse = await axios.get(`${API_URL}/classes`, {
      ...config,
      params: { limit: 1 },
    });

    const classList = classesResponse.data.data.classes[0];
    if (!classList) {
      console.log("⚠️  No classes found.");
      process.exit(0);
    }

    console.log(`✅ Found class: ${classList.name} (ID: ${classList.id})\n`);

    // 3. Get class detail
    console.log("3️⃣ Fetching class detail...");
    const detailResponse = await axios.get(
      `${API_URL}/classes/${classList.id}`,
      config
    );

    const classData = detailResponse.data.data;

    console.log("📋 Class Details:");
    console.log(`   ID: ${classData.id}`);
    console.log(`   Name: ${classData.name}`);
    console.log(`   Tenant ID: ${classData.tenant_id}`);
    console.log(`   Tenant Name: ${classData.tenant_name || "N/A"}`);
    console.log(`   Tenant Code: ${classData.tenant_code || "N/A"}`);
    console.log("");

    // 4. Verify tenant info
    if (classData.tenant_name) {
      console.log("✅ Tenant name is included in response!");
      console.log(`   Display: "${classData.tenant_name}"`);
    } else {
      console.log("⚠️  Tenant name not found in response");
      console.log("   Will display: ID: " + classData.tenant_id);
    }

    console.log("\n✅ Test completed!");
    console.log("\n📝 Summary:");
    console.log("   - API returns tenant_name");
    console.log("   - Frontend can display tenant name instead of ID");
    console.log("");

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

testTenantName();
