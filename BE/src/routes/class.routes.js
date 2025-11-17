const express = require("express");
const { body } = require("express-validator");
const {
  getAllClasses,
  getClassById,
  createClass,
  updateClass,
  deleteClass,
} = require("../controllers/class.controller");
const { authMiddleware, checkRole } = require("../middleware/auth.middleware");
const validate = require("../middleware/validator.middleware");

const router = express.Router();

// Validation rules
const classValidation = [
  body("name").notEmpty().withMessage("Class name is required"),
  body("code").optional(),
  body("description").optional(),
  body("level").optional(),
  body("language").optional(),
  body("max_students")
    .optional()
    .isInt({ min: 1 })
    .withMessage("Max students must be a positive integer"),
  body("status")
    .optional()
    .isIn(["draft", "active", "completed", "cancelled"])
    .withMessage("Invalid status"),
  body("start_date").optional().isISO8601().withMessage("Invalid start date"),
  body("end_date").optional().isISO8601().withMessage("Invalid end date"),
  body("schedule").optional(),
  body("room").optional(),
];

// All routes require authentication
router.use(authMiddleware);

// Routes
router.get("/", getAllClasses);
router.get("/:id", getClassById);
router.post(
  "/",
  checkRole("admin", "teacher"),
  classValidation,
  validate,
  createClass
);
router.put(
  "/:id",
  checkRole("admin", "teacher"),
  classValidation,
  validate,
  updateClass
);
router.delete("/:id", checkRole("admin"), deleteClass);

module.exports = router;
