const { promisePool } = require("../config/database");

// Get all courses
const getAllCourses = async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    const offset = (page - 1) * limit;

    let query = "SELECT * FROM courses WHERE deleted_at IS NULL";
    const params = [];

    if (status) {
      query += " AND status = ?";
      params.push(status);
    }

    query += " ORDER BY created_at DESC LIMIT ? OFFSET ?";
    params.push(parseInt(limit), parseInt(offset));

    const [courses] = await promisePool.query(query, params);

    // Get total count
    let countQuery =
      "SELECT COUNT(*) as total FROM courses WHERE deleted_at IS NULL";
    const countParams = [];

    if (status) {
      countQuery += " AND status = ?";
      countParams.push(status);
    }

    const [countResult] = await promisePool.query(countQuery, countParams);
    const total = countResult[0].total;

    res.json({
      success: true,
      data: {
        courses,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          totalPages: Math.ceil(total / limit),
        },
      },
    });
  } catch (error) {
    console.error("Get all courses error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Get course by ID
const getCourseById = async (req, res) => {
  try {
    const { id } = req.params;

    const [courses] = await promisePool.query(
      "SELECT * FROM courses WHERE id = ? AND deleted_at IS NULL",
      [id]
    );

    if (courses.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Course not found",
      });
    }

    res.json({
      success: true,
      data: courses[0],
    });
  } catch (error) {
    console.error("Get course by ID error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Create course
const createCourse = async (req, res) => {
  try {
    const {
      name,
      description,
      category,
      duration,
      status = "draft",
    } = req.body;

    const [result] = await promisePool.query(
      "INSERT INTO courses (name, description, category, duration, status, created_at) VALUES (?, ?, ?, ?, ?, NOW())",
      [name, description, category, duration, status]
    );

    res.status(201).json({
      success: true,
      message: "Course created successfully",
      data: {
        id: result.insertId,
        name,
        description,
        category,
        duration,
        status,
      },
    });
  } catch (error) {
    console.error("Create course error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Update course
const updateCourse = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, category, duration, status } = req.body;

    const [result] = await promisePool.query(
      "UPDATE courses SET name = ?, description = ?, category = ?, duration = ?, status = ?, updated_at = NOW() WHERE id = ? AND deleted_at IS NULL",
      [name, description, category, duration, status, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Course not found",
      });
    }

    res.json({
      success: true,
      message: "Course updated successfully",
    });
  } catch (error) {
    console.error("Update course error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Delete course (soft delete)
const deleteCourse = async (req, res) => {
  try {
    const { id } = req.params;

    const [result] = await promisePool.query(
      "UPDATE courses SET deleted_at = NOW() WHERE id = ? AND deleted_at IS NULL",
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Course not found",
      });
    }

    res.json({
      success: true,
      message: "Course deleted successfully",
    });
  } catch (error) {
    console.error("Delete course error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

module.exports = {
  getAllCourses,
  getCourseById,
  createCourse,
  updateCourse,
  deleteCourse,
};
