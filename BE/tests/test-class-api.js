/**
 * Test Class API Endpoints
 * Run: node tests/test-class-api.js
 */

const axios = require("axios");

const API_BASE = "http://localhost:5000/api";
let authToken = "";
let testClassId = null;

// Colors for console output
const colors = {
  reset: "\x1b[0m",
  green: "\x1b[32m",
  red: "\x1b[31m",
  yellow: "\x1b[33m",
  blue: "\x1b[34m",
  cyan: "\x1b[36m",
};

const log = {
  success: (msg) => console.log(`${colors.green}✅ ${msg}${colors.reset}`),
  error: (msg) => console.log(`${colors.red}❌ ${msg}${colors.reset}`),
  info: (msg) => console.log(`${colors.blue}ℹ️  ${msg}${colors.reset}`),
  test: (msg) => console.log(`${colors.cyan}🔍 ${msg}${colors.reset}`),
  warn: (msg) => console.log(`${colors.yellow}⚠️  ${msg}${colors.reset}`),
};

// Test 1: Login to get token
async function testLogin() {
  log.test("Test 1: Login to get authentication token");

  try {
    const response = await axios.post(`${API_BASE}/auth/login`, {
      email: "admin@example.com",
      password: "password123",
    });

    if (response.data.success && response.data.data.token) {
      authToken = response.data.data.token;
      log.success("Login successful");
      log.info(`Token: ${authToken.substring(0, 20)}...`);
      log.info(
        `User: ${response.data.data.user.email} (${response.data.data.user.role})`
      );
      return true;
    } else {
      log.error("Login failed: Invalid response format");
      return false;
    }
  } catch (error) {
    log.error(
      `Login failed: ${error.response?.data?.message || error.message}`
    );
    return false;
  }
}

// Test 2: Get all classes (with pagination)
async function testGetClasses() {
  log.test("Test 2: Get all classes with pagination");

  try {
    const response = await axios.get(`${API_BASE}/classes`, {
      params: { page: 1, limit: 5 },
      headers: { Authorization: `Bearer ${authToken}` },
    });

    if (response.data.success) {
      const { classes, pagination } = response.data.data;
      log.success(`Retrieved ${classes.length} classes`);
      log.info(
        `Total: ${pagination.total}, Page: ${pagination.page}/${pagination.totalPages}`
      );

      if (classes.length > 0) {
        log.info(`First class: ${classes[0].name} (${classes[0].code})`);
        testClassId = classes[0].id; // Save for later tests
      }
      return true;
    } else {
      log.error("Get classes failed: Invalid response");
      return false;
    }
  } catch (error) {
    log.error(
      `Get classes failed: ${error.response?.data?.message || error.message}`
    );
    return false;
  }
}

// Test 3: Get class by ID
async function testGetClassById() {
  if (!testClassId) {
    log.warn("Test 3: Skipped (no class ID available)");
    return true;
  }

  log.test(`Test 3: Get class by ID (${testClassId})`);

  try {
    const response = await axios.get(`${API_BASE}/classes/${testClassId}`, {
      headers: { Authorization: `Bearer ${authToken}` },
    });

    if (response.data.success) {
      const classData = response.data.data;
      log.success("Retrieved class details");
      log.info(`Name: ${classData.name}`);
      log.info(`Code: ${classData.code}`);
      log.info(`Status: ${classData.status}`);
      log.info(`Level: ${classData.level}`);
      log.info(`Max Students: ${classData.max_students}`);
      return true;
    } else {
      log.error("Get class by ID failed: Invalid response");
      return false;
    }
  } catch (error) {
    log.error(
      `Get class by ID failed: ${
        error.response?.data?.message || error.message
      }`
    );
    return false;
  }
}

// Test 4: Create new class
async function testCreateClass() {
  log.test("Test 4: Create new class");

  const newClass = {
    name: "Test API Class",
    code: `TEST-API-${Date.now()}`,
    description: "Class created by API test script",
    level: "A1",
    language: "en",
    max_students: 15,
    status: "draft",
    start_date: "2025-02-01",
    end_date: "2025-05-31",
    room: "Test Room 999",
    schedule: {
      days: ["Monday", "Wednesday", "Friday"],
      time: "10:00-12:00",
      timezone: "Asia/Ho_Chi_Minh",
    },
  };

  try {
    const response = await axios.post(`${API_BASE}/classes`, newClass, {
      headers: { Authorization: `Bearer ${authToken}` },
    });

    if (response.data.success) {
      const createdClass = response.data.data;
      testClassId = createdClass.id; // Update test class ID
      log.success("Class created successfully");
      log.info(`ID: ${createdClass.id}`);
      log.info(`Name: ${createdClass.name}`);
      log.info(`Code: ${createdClass.code}`);
      return true;
    } else {
      log.error("Create class failed: Invalid response");
      return false;
    }
  } catch (error) {
    log.error(
      `Create class failed: ${error.response?.data?.message || error.message}`
    );
    if (error.response?.data?.errors) {
      console.log("Validation errors:", error.response.data.errors);
    }
    return false;
  }
}

// Test 5: Update class
async function testUpdateClass() {
  if (!testClassId) {
    log.warn("Test 5: Skipped (no class ID available)");
    return true;
  }

  log.test(`Test 5: Update class (${testClassId})`);

  const updates = {
    name: "Test API Class - UPDATED",
    description: "Updated by API test script",
    max_students: 20,
    status: "active",
  };

  try {
    const response = await axios.put(
      `${API_BASE}/classes/${testClassId}`,
      updates,
      {
        headers: { Authorization: `Bearer ${authToken}` },
      }
    );

    if (response.data.success) {
      const updatedClass = response.data.data;
      log.success("Class updated successfully");
      log.info(`Name: ${updatedClass.name}`);
      log.info(`Status: ${updatedClass.status}`);
      log.info(`Max Students: ${updatedClass.max_students}`);
      return true;
    } else {
      log.error("Update class failed: Invalid response");
      return false;
    }
  } catch (error) {
    log.error(
      `Update class failed: ${error.response?.data?.message || error.message}`
    );
    return false;
  }
}

// Test 6: Filter classes by status
async function testFilterByStatus() {
  log.test("Test 6: Filter classes by status");

  try {
    const response = await axios.get(`${API_BASE}/classes`, {
      params: { status: "active", page: 1, limit: 10 },
      headers: { Authorization: `Bearer ${authToken}` },
    });

    if (response.data.success) {
      const { classes, pagination } = response.data.data;
      log.success(`Retrieved ${classes.length} active classes`);
      log.info(`Total active: ${pagination.total}`);
      return true;
    } else {
      log.error("Filter by status failed: Invalid response");
      return false;
    }
  } catch (error) {
    log.error(
      `Filter by status failed: ${
        error.response?.data?.message || error.message
      }`
    );
    return false;
  }
}

// Test 7: Delete class
async function testDeleteClass() {
  if (!testClassId) {
    log.warn("Test 7: Skipped (no class ID available)");
    return true;
  }

  log.test(`Test 7: Delete class (${testClassId})`);

  try {
    const response = await axios.delete(`${API_BASE}/classes/${testClassId}`, {
      headers: { Authorization: `Bearer ${authToken}` },
    });

    if (response.data.success) {
      log.success("Class deleted successfully");
      log.info(response.data.message);
      return true;
    } else {
      log.error("Delete class failed: Invalid response");
      return false;
    }
  } catch (error) {
    log.error(
      `Delete class failed: ${error.response?.data?.message || error.message}`
    );
    return false;
  }
}

// Test 8: Verify deletion
async function testVerifyDeletion() {
  if (!testClassId) {
    log.warn("Test 8: Skipped (no class ID available)");
    return true;
  }

  log.test(`Test 8: Verify class deletion (${testClassId})`);

  try {
    await axios.get(`${API_BASE}/classes/${testClassId}`, {
      headers: { Authorization: `Bearer ${authToken}` },
    });

    log.error("Class still exists after deletion!");
    return false;
  } catch (error) {
    if (error.response?.status === 404) {
      log.success("Class successfully deleted (404 Not Found)");
      return true;
    } else {
      log.error(
        `Unexpected error: ${error.response?.data?.message || error.message}`
      );
      return false;
    }
  }
}

// Run all tests
async function runAllTests() {
  console.log("\n" + "=".repeat(60));
  console.log("🧪 CLASS API TEST SUITE");
  console.log("=".repeat(60) + "\n");

  const tests = [
    { name: "Login", fn: testLogin },
    { name: "Get Classes", fn: testGetClasses },
    { name: "Get Class By ID", fn: testGetClassById },
    { name: "Create Class", fn: testCreateClass },
    { name: "Update Class", fn: testUpdateClass },
    { name: "Filter By Status", fn: testFilterByStatus },
    { name: "Delete Class", fn: testDeleteClass },
    { name: "Verify Deletion", fn: testVerifyDeletion },
  ];

  let passed = 0;
  let failed = 0;

  for (const test of tests) {
    try {
      const result = await test.fn();
      if (result) {
        passed++;
      } else {
        failed++;
      }
      console.log(""); // Empty line between tests
    } catch (error) {
      log.error(`Test "${test.name}" threw an error: ${error.message}`);
      failed++;
      console.log("");
    }
  }

  // Summary
  console.log("=".repeat(60));
  console.log("📊 TEST SUMMARY");
  console.log("=".repeat(60));
  console.log(`Total Tests: ${tests.length}`);
  console.log(`${colors.green}Passed: ${passed}${colors.reset}`);
  console.log(`${colors.red}Failed: ${failed}${colors.reset}`);
  console.log(`Success Rate: ${((passed / tests.length) * 100).toFixed(1)}%`);
  console.log("=".repeat(60) + "\n");

  process.exit(failed > 0 ? 1 : 0);
}

// Run tests
runAllTests().catch((error) => {
  log.error(`Fatal error: ${error.message}`);
  process.exit(1);
});
