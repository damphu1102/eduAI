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
  body("description").optional(),
  body("status")
    .optional()
    .isIn(["active", "inactive"])
    .withMessage("Invalid status"),
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
