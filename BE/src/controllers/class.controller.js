const { promisePool } = require("../config/database");

// Get all classes
const getAllClasses = async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    const offset = (page - 1) * limit;

    let query = "SELECT * FROM classes WHERE deleted_at IS NULL";
    const params = [];

    if (status) {
      query += " AND status = ?";
      params.push(status);
    }

    query += " ORDER BY created_at DESC LIMIT ? OFFSET ?";
    params.push(parseInt(limit), parseInt(offset));

    const [classes] = await promisePool.query(query, params);

    // Get total count
    let countQuery =
      "SELECT COUNT(*) as total FROM classes WHERE deleted_at IS NULL";
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
        classes,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          totalPages: Math.ceil(total / limit),
        },
      },
    });
  } catch (error) {
    console.error("Get all classes error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Get class by ID
const getClassById = async (req, res) => {
  try {
    const { id } = req.params;

    const [classes] = await promisePool.query(
      "SELECT * FROM classes WHERE id = ? AND deleted_at IS NULL",
      [id]
    );

    if (classes.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Class not found",
      });
    }

    res.json({
      success: true,
      data: classes[0],
    });
  } catch (error) {
    console.error("Get class by ID error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Create class
const createClass = async (req, res) => {
  try {
    const { name, description, status = "active" } = req.body;

    const [result] = await promisePool.query(
      "INSERT INTO classes (name, description, status, created_at) VALUES (?, ?, ?, NOW())",
      [name, description, status]
    );

    res.status(201).json({
      success: true,
      message: "Class created successfully",
      data: {
        id: result.insertId,
        name,
        description,
        status,
      },
    });
  } catch (error) {
    console.error("Create class error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Update class
const updateClass = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, status } = req.body;

    const [result] = await promisePool.query(
      "UPDATE classes SET name = ?, description = ?, status = ?, updated_at = NOW() WHERE id = ? AND deleted_at IS NULL",
      [name, description, status, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Class not found",
      });
    }

    res.json({
      success: true,
      message: "Class updated successfully",
    });
  } catch (error) {
    console.error("Update class error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Delete class (soft delete)
const deleteClass = async (req, res) => {
  try {
    const { id } = req.params;

    const [result] = await promisePool.query(
      "UPDATE classes SET deleted_at = NOW() WHERE id = ? AND deleted_at IS NULL",
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Class not found",
      });
    }

    res.json({
      success: true,
      message: "Class deleted successfully",
    });
  } catch (error) {
    console.error("Delete class error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

module.exports = {
  getAllClasses,
  getClassById,
  createClass,
  updateClass,
  deleteClass,
};
