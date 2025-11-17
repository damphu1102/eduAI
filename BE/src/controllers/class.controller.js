const { promisePool } = require("../config/database");

// Get all classes
const getAllClasses = async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    const offset = (page - 1) * limit;

    let query = "SELECT * FROM classes WHERE 1=1";
    const params = [];

    if (status) {
      query += " AND status = ?";
      params.push(status);
    }

    query += " ORDER BY created_at DESC LIMIT ? OFFSET ?";
    params.push(parseInt(limit), parseInt(offset));

    const [classes] = await promisePool.query(query, params);

    // Get teachers for each class
    for (const cls of classes) {
      const [teachers] = await promisePool.query(
        `SELECT u.id, u.full_name, u.email, ct.role, ct.start_date, ct.end_date
         FROM class_teachers ct
         JOIN users u ON ct.user_id = u.id
         WHERE ct.class_id = ? AND u.deleted_at IS NULL
         ORDER BY ct.role, u.full_name`,
        [cls.id]
      );
      cls.teachers = teachers;
    }

    // Get total count
    let countQuery = "SELECT COUNT(*) as total FROM classes WHERE 1=1";
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
      "SELECT * FROM classes WHERE id = ?",
      [id]
    );

    if (classes.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Class not found",
      });
    }

    const classData = classes[0];

    // Get teachers for this class
    const [teachers] = await promisePool.query(
      `SELECT u.id, u.full_name, u.email, ct.role, ct.start_date, ct.end_date
       FROM class_teachers ct
       JOIN users u ON ct.user_id = u.id
       WHERE ct.class_id = ? AND u.deleted_at IS NULL
       ORDER BY ct.role, u.full_name`,
      [id]
    );
    classData.teachers = teachers;

    res.json({
      success: true,
      data: classData,
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
    const {
      tenant_id = 1,
      campus_id = null,
      course_blueprint_id = null,
      code,
      name,
      description,
      level,
      language,
      max_students = 20,
      status = "draft",
      start_date,
      end_date,
      schedule,
      room,
      created_by = req.user?.id || null,
    } = req.body;

    const [result] = await promisePool.query(
      `INSERT INTO classes (
        tenant_id, campus_id, course_blueprint_id, code, name, description,
        level, language, max_students, status, start_date, end_date,
        schedule, room, created_by
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        tenant_id,
        campus_id,
        course_blueprint_id,
        code,
        name,
        description,
        level,
        language,
        max_students,
        status,
        start_date,
        end_date,
        JSON.stringify(schedule),
        room,
        created_by,
      ]
    );

    // Get the created class
    const [classes] = await promisePool.query(
      "SELECT * FROM classes WHERE id = ?",
      [result.insertId]
    );

    res.status(201).json({
      success: true,
      message: "Class created successfully",
      data: classes[0],
    });
  } catch (error) {
    console.error("Create class error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
      error: error.message,
    });
  }
};

// Update class
const updateClass = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      code,
      name,
      description,
      level,
      language,
      max_students,
      status,
      start_date,
      end_date,
      schedule,
      room,
    } = req.body;

    // Build dynamic update query
    const updates = [];
    const params = [];

    if (code !== undefined) {
      updates.push("code = ?");
      params.push(code);
    }
    if (name !== undefined) {
      updates.push("name = ?");
      params.push(name);
    }
    if (description !== undefined) {
      updates.push("description = ?");
      params.push(description);
    }
    if (level !== undefined) {
      updates.push("level = ?");
      params.push(level);
    }
    if (language !== undefined) {
      updates.push("language = ?");
      params.push(language);
    }
    if (max_students !== undefined) {
      updates.push("max_students = ?");
      params.push(max_students);
    }
    if (status !== undefined) {
      updates.push("status = ?");
      params.push(status);
    }
    if (start_date !== undefined) {
      updates.push("start_date = ?");
      params.push(start_date);
    }
    if (end_date !== undefined) {
      updates.push("end_date = ?");
      params.push(end_date);
    }
    if (schedule !== undefined) {
      updates.push("schedule = ?");
      params.push(JSON.stringify(schedule));
    }
    if (room !== undefined) {
      updates.push("room = ?");
      params.push(room);
    }

    if (updates.length === 0) {
      return res.status(400).json({
        success: false,
        message: "No fields to update",
      });
    }

    updates.push("updated_by = ?");
    params.push(req.user?.id || null);
    params.push(id);

    const [result] = await promisePool.query(
      `UPDATE classes SET ${updates.join(", ")} WHERE id = ?`,
      params
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Class not found",
      });
    }

    // Get the updated class
    const [classes] = await promisePool.query(
      "SELECT * FROM classes WHERE id = ?",
      [id]
    );

    res.json({
      success: true,
      message: "Class updated successfully",
      data: classes[0],
    });
  } catch (error) {
    console.error("Update class error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Delete class (hard delete - since no deleted_at column)
const deleteClass = async (req, res) => {
  try {
    const { id } = req.params;

    const [result] = await promisePool.query(
      "DELETE FROM classes WHERE id = ?",
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
