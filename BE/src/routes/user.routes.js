const express = require("express");
const { body } = require("express-validator");
const {
  getAllUsers,
  getUserById,
  updateUser,
  deleteUser,
} = require("../controllers/user.controller");
const { authMiddleware, checkRole } = require("../middleware/auth.middleware");
const validate = require("../middleware/validator.middleware");

const router = express.Router();

// Validation rules
const updateUserValidation = [
  body("full_name")
    .optional()
    .notEmpty()
    .withMessage("Full name cannot be empty"),
  body("role")
    .optional()
    .isIn(["admin", "teacher", "student", "parent"])
    .withMessage("Invalid role"),
];

// All routes require authentication
router.use(authMiddleware);

// Routes
router.get("/", checkRole("admin", "teacher"), getAllUsers);
router.get("/:id", getUserById);
router.put(
  "/:id",
  checkRole("admin"),
  updateUserValidation,
  validate,
  updateUser
);
router.delete("/:id", checkRole("admin"), deleteUser);

module.exports = router;
