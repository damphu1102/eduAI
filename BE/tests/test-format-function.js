// Test the formatDateForMySQL function directly

const formatDateForMySQL = (dateString) => {
  if (!dateString) return null;

  // If it's already in YYYY-MM-DD format, return as is
  if (
    typeof dateString === "string" &&
    /^\d{4}-\d{2}-\d{2}$/.test(dateString)
  ) {
    console.log(`  → Already in YYYY-MM-DD format, returning as is`);
    return dateString;
  }

  // If it's a Date object from MySQL, extract the date part directly
  if (dateString instanceof Date) {
    console.log(`  → Date object, extracting with local timezone`);
    const year = dateString.getFullYear();
    const month = String(dateString.getMonth() + 1).padStart(2, "0");
    const day = String(dateString.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }

  // For ISO strings or other formats, parse and extract date part
  console.log(`  → Other format, parsing and using UTC`);
  const date = new Date(dateString);
  if (isNaN(date.getTime())) return null;

  // Use UTC to avoid timezone issues
  const year = date.getUTCFullYear();
  const month = String(date.getUTCMonth() + 1).padStart(2, "0");
  const day = String(date.getUTCDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

console.log("🔍 Testing formatDateForMySQL function\n");

const testCases = [
  {
    input: "2025-11-15",
    expected: "2025-11-15",
    description: "YYYY-MM-DD string",
  },
  {
    input: "2025-12-31",
    expected: "2025-12-31",
    description: "YYYY-MM-DD string",
  },
  {
    input: "2025-11-15T00:00:00.000Z",
    expected: "2025-11-15",
    description: "ISO string",
  },
  {
    input: new Date("2025-11-15"),
    expected: "2025-11-15",
    description: "Date object",
  },
  {
    input: null,
    expected: null,
    description: "Null",
  },
];

let passed = 0;
let failed = 0;

testCases.forEach((testCase, index) => {
  console.log(`Test ${index + 1}: ${testCase.description}`);
  console.log(`  Input: ${testCase.input}`);

  const result = formatDateForMySQL(testCase.input);
  const success = result === testCase.expected;

  if (success) {
    console.log(`  ✅ Output: ${result}`);
    passed++;
  } else {
    console.log(`  ❌ Expected: ${testCase.expected}`);
    console.log(`  ❌ Got: ${result}`);
    failed++;
  }
  console.log("");
});

console.log("=".repeat(50));
console.log(`Results: ${passed} passed, ${failed} failed`);
console.log("=".repeat(50));

if (failed === 0) {
  console.log("\n✅ All tests passed!");
  process.exit(0);
} else {
  console.log("\n❌ Some tests failed!");
  process.exit(1);
}
