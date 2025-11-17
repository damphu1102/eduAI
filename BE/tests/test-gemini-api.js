/**
 * Test Script for Gemini API Integration
 *
 * This script tests the Gemini API connectivity and response format
 * for the AI Assistant feature.
 *
 * Usage: node BE/tests/test-gemini-api.js
 */

const https = require("https");

// ============================================================================
// Configuration
// ============================================================================

const GEMINI_API_KEY = process.env.VITE_GEMINI_API_KEY || "";
const GEMINI_MODEL = process.env.VITE_GEMINI_MODEL || "gemini-2.5-flash";
const API_BASE_URL = "generativelanguage.googleapis.com";

// ============================================================================
// Test Data
// ============================================================================

const SYSTEM_PROMPT = `You are an AI assistant for an educational management system (SysEdu AI). 
Your role is to analyze dashboard data and provide actionable insights for educational administrators, teachers, and academic staff.

CRITICAL INSTRUCTIONS:
1. Generate a Vietnamese-language summary (max 120 words) based ONLY on the provided data
2. Use a professional and friendly tone
3. Create 3-5 action items with priorities (1=high, 2=medium, 3=low)
4. Each action must include: id (snake_case), label (Vietnamese), target (route path), reason (Vietnamese), priority
5. Base all recommendations on the actual data provided - do not infer or assume
6. Return ONLY valid JSON in this exact format:

{
  "summary": "Vietnamese text summary here...",
  "actions": [
    {
      "id": "action_identifier",
      "label": "Action label in Vietnamese",
      "target": "/route/path",
      "reason": "Explanation in Vietnamese",
      "priority": 1
    }
  ]
}

Do not include any text outside the JSON structure.`;

const TEST_CONTEXT = {
  currentUser: {
    id: 1,
    role: "admin",
    name: "Nguyễn Văn An",
  },
  dashboardData: {
    totalClasses: 24,
    activeClasses: 18,
    draftClasses: 3,
    completedClasses: 3,
    riskyClasses: [
      {
        name: "Lớp Toán 10A1",
        absenceRate: 0.35,
        teacher: "Nguyễn Thị Lan",
      },
      {
        name: "Lớp Văn 11B2",
        absenceRate: 0.42,
        teacher: "Trần Văn Minh",
      },
    ],
    lowHomeworkClasses: [
      {
        name: "Lớp Lý 10B1",
        submitRate: 0.45,
      },
    ],
    studentsAtRisk: 12,
  },
};

// ============================================================================
// Helper Functions
// ============================================================================

function makeRequest(data) {
  return new Promise((resolve, reject) => {
    const postData = JSON.stringify(data);

    const options = {
      hostname: API_BASE_URL,
      path: `/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}`,
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(postData),
      },
      timeout: 10000,
    };

    const req = https.request(options, (res) => {
      let responseData = "";

      res.on("data", (chunk) => {
        responseData += chunk;
      });

      res.on("end", () => {
        if (res.statusCode === 200) {
          try {
            const parsed = JSON.parse(responseData);
            resolve({ statusCode: res.statusCode, data: parsed });
          } catch (err) {
            reject(new Error(`Failed to parse JSON: ${err.message}`));
          }
        } else {
          reject(
            new Error(
              `HTTP ${res.statusCode}: ${responseData.substring(0, 200)}`
            )
          );
        }
      });
    });

    req.on("error", (err) => {
      reject(new Error(`Request failed: ${err.message}`));
    });

    req.on("timeout", () => {
      req.destroy();
      reject(new Error("Request timed out after 10 seconds"));
    });

    req.write(postData);
    req.end();
  });
}

function validateResponse(response) {
  const errors = [];

  // Check for candidates
  if (!response.candidates || response.candidates.length === 0) {
    errors.push("❌ No candidates in response");
    return errors;
  }

  const candidate = response.candidates[0];

  // Check for content
  if (
    !candidate.content ||
    !candidate.content.parts ||
    candidate.content.parts.length === 0
  ) {
    errors.push("❌ No content parts in response");
    return errors;
  }

  const textContent = candidate.content.parts[0].text;

  // Try to parse JSON
  let aiResponse;
  try {
    aiResponse = JSON.parse(textContent);
  } catch (err) {
    errors.push(`❌ Failed to parse JSON: ${err.message}`);
    return errors;
  }

  // Validate structure
  if (!aiResponse.summary) {
    errors.push("❌ Missing 'summary' field");
  } else if (typeof aiResponse.summary !== "string") {
    errors.push("❌ 'summary' must be a string");
  } else {
    console.log(`✅ Summary: ${aiResponse.summary.substring(0, 100)}...`);
  }

  if (!Array.isArray(aiResponse.actions)) {
    errors.push("❌ Missing or invalid 'actions' array");
  } else {
    console.log(`✅ Actions count: ${aiResponse.actions.length}`);

    // Validate each action
    aiResponse.actions.forEach((action, index) => {
      if (!action.id) errors.push(`❌ Action ${index}: missing 'id'`);
      if (!action.label) errors.push(`❌ Action ${index}: missing 'label'`);
      if (!action.target) errors.push(`❌ Action ${index}: missing 'target'`);
      if (!action.reason) errors.push(`❌ Action ${index}: missing 'reason'`);
      if (![1, 2, 3].includes(action.priority)) {
        errors.push(
          `❌ Action ${index}: invalid priority (must be 1, 2, or 3)`
        );
      }
    });

    if (errors.length === 0) {
      console.log("✅ All actions have valid structure");
    }
  }

  return errors;
}

// ============================================================================
// Main Test Function
// ============================================================================

async function runTests() {
  console.log("🔍 Gemini API Integration Test");
  console.log("================================\n");

  // Check API key
  if (!GEMINI_API_KEY) {
    console.error("❌ VITE_GEMINI_API_KEY environment variable is not set");
    console.log(
      "\n💡 Get your API key from: https://aistudio.google.com/app/apikey"
    );
    process.exit(1);
  }

  console.log(`✅ API Key: ${GEMINI_API_KEY.substring(0, 10)}...`);
  console.log(`✅ Model: ${GEMINI_MODEL}\n`);

  // Prepare request
  const requestBody = {
    contents: [
      {
        parts: [
          {
            text: `${SYSTEM_PROMPT}\n\nContext Data:\n${JSON.stringify(
              TEST_CONTEXT,
              null,
              2
            )}`,
          },
        ],
      },
    ],
    generationConfig: {
      temperature: 0.7,
      maxOutputTokens: 1024,
      responseMimeType: "application/json",
    },
  };

  console.log("📝 Sending request to Gemini API...\n");

  try {
    const startTime = Date.now();
    const result = await makeRequest(requestBody);
    const duration = Date.now() - startTime;

    console.log(`✅ Request successful (${duration}ms)`);
    console.log(`✅ Status Code: ${result.statusCode}\n`);

    console.log("📋 Validating response format...\n");
    const errors = validateResponse(result.data);

    if (errors.length === 0) {
      console.log("\n✅ All validation checks passed!");
      console.log("\n🎉 Gemini API integration is working correctly!");
    } else {
      console.log("\n⚠️  Validation errors found:");
      errors.forEach((error) => console.log(`   ${error}`));
      process.exit(1);
    }
  } catch (error) {
    console.error("\n❌ Test failed:");
    console.error(`   ${error.message}`);

    if (error.message.includes("401") || error.message.includes("403")) {
      console.log(
        "\n💡 API key may be invalid. Get a new one from: https://aistudio.google.com/app/apikey"
      );
    } else if (error.message.includes("429")) {
      console.log("\n💡 Rate limit exceeded. Please wait and try again.");
    } else if (error.message.includes("timeout")) {
      console.log("\n💡 Request timed out. Check your internet connection.");
    }

    process.exit(1);
  }
}

// ============================================================================
// Run Tests
// ============================================================================

runTests();
