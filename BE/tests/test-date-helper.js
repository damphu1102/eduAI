// Test the date formatting helper function

const formatDateForMySQL = (dateString) => {
  if (!dateString) return null;
  const date = new Date(dateString);
  if (isNaN(date.getTime())) return null;
  return date.toISOString().split("T")[0];
};

console.log("🔍 Testing Date Format Helper Function\n");

const testCases = [
  {
    input: "2025-10-31T17:00:00.000Z",
    expected: "2025-10-31",
    description: "ISO format with time",
  },
  {
    input: "2025-11-29T17:00:00.000Z",
    expected: "2025-11-29",
    description: "ISO format with time",
  },
  {
    input: "2025-12-01",
    expected: "2025-12-01",
    description: "Date only format",
  },
  {
    input: null,
    expected: null,
    description: "Null input",
  },
  {
    input: "",
    expected: null,
    description: "Empty string",
  },
  {
    input: "invalid-date",
    expected: null,
    description: "Invalid date string",
  },
];

let passed = 0;
let failed = 0;

testCases.forEach((testCase, index) => {
  const result = formatDateForMySQL(testCase.input);
  const success = result === testCase.expected;

  if (success) {
    console.log(`✅ Test ${index + 1}: ${testCase.description}`);
    console.log(`   Input: ${testCase.input}`);
    console.log(`   Output: ${result}`);
    passed++;
  } else {
    console.log(`❌ Test ${index + 1}: ${testCase.description}`);
    console.log(`   Input: ${testCase.input}`);
    console.log(`   Expected: ${testCase.expected}`);
    console.log(`   Got: ${result}`);
    failed++;
  }
  console.log("");
});

console.log("=".repeat(50));
console.log(`Results: ${passed} passed, ${failed} failed`);
console.log("=".repeat(50));

if (failed === 0) {
  console.log("\n✅ All tests passed!");
  console.log("\n📝 The helper function correctly converts:");
  console.log("   - ISO 8601 format → MySQL DATE format");
  console.log("   - Handles null and invalid inputs");
  process.exit(0);
} else {
  console.log("\n❌ Some tests failed!");
  process.exit(1);
}
