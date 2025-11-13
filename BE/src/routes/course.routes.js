const express = require("express");
const { body } = require("express-validator");
const {
  getAllCourses,
  getCourseById,
  createCourse,
  updateCourse,
  deleteCourse,
} = require("../controllers/course.controller");
const { authMiddleware, checkRole } = require("../middleware/auth.middleware");
const validate = require("../middleware/validator.middleware");

const router = express.Router();

// Validation rules
const courseValidation = [
  body("name").notEmpty().withMessage("Course name is required"),
  body("description").optional(),
  body("category").notEmpty().withMessage("Category is required"),
  body("duration")
    .optional()
    .isInt({ min: 1 })
    .withMessage("Duration must be a positive integer"),
  body("status")
    .optional()
    .isIn(["draft", "published", "archived"])
    .withMessage("Invalid status"),
];

// All routes require authentication
router.use(authMiddleware);

// Routes
router.get("/", getAllCourses);
router.get("/:id", getCourseById);
router.post(
  "/",
  checkRole("admin", "teacher"),
  courseValidation,
  validate,
  createCourse
);
router.put(
  "/:id",
  checkRole("admin", "teacher"),
  courseValidation,
  validate,
  updateCourse
);
router.delete("/:id", checkRole("admin"), deleteCourse);

module.exports = router;
