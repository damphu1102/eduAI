const express = require("express");
const { body } = require("express-validator");
const {
  login,
  register,
  getCurrentUser,
} = require("../controllers/auth.controller");
const { authMiddleware } = require("../middleware/auth.middleware");
const validate = require("../middleware/validator.middleware");

const router = express.Router();

// Validation rules
const loginValidation = [
  body("email").isEmail().withMessage("Invalid email format"),
  body("password").notEmpty().withMessage("Password is required"),
];

const registerValidation = [
  body("email").isEmail().withMessage("Invalid email format"),
  body("password")
    .isLength({ min: 6 })
    .withMessage("Password must be at least 6 characters"),
  body("full_name").notEmpty().withMessage("Full name is required"),
  body("role")
    .optional()
    .isIn(["admin", "teacher", "student", "parent"])
    .withMessage("Invalid role"),
];

// Routes
router.post("/login", loginValidation, validate, login);
router.post("/register", registerValidation, validate, register);
router.get("/me", authMiddleware, getCurrentUser);

module.exports = router;
