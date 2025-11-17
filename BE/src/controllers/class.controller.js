const { promisePool } = require("../config/database");

// Helper function to convert date to MySQL DATE format (YYYY-MM-DD)
const formatDateForMySQL = (dateString) => {
  if (!dateString) return null;

  // If it's already a Date object from MySQL, extract the date part directly
  if (dateString instanceof Date) {
    const year = dateString.getFullYear();
    const month = String(dateString.getMonth() + 1).padStart(2, "0");
    const day = String(dateString.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }

  // If it's already in YYYY-MM-DD format, return as is
  if (
    typeof dateString === "string" &&
    /^\d{4}-\d{2}-\d{2}$/.test(dateString)
  ) {
    return dateString;
  }

  // Otherwise, parse and format
  const date = new Date(dateString);
  if (isNaN(date.getTime())) return null;

  // Use UTC to avoid timezone issues
  const year = date.getUTCFullYear();
  const month = String(date.getUTCMonth() + 1).padStart(2, "0");
  const day = String(date.getUTCDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

// Get all classes
const getAllClasses = async (req, res) => {
  try {
    const { page = 1, limit = 10, status, search } = req.query;
    const offset = (page - 1) * limit;

    let query = "SELECT * FROM classes WHERE 1=1";
    const params = [];

    if (status) {
      query += " AND status = ?";
      params.push(status);
    }

    if (search) {
      query += " AND (name LIKE ? OR code LIKE ?)";
      params.push(`%${search}%`, `%${search}%`);
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

    if (search) {
      countQuery += " AND (name LIKE ? OR code LIKE ?)";
      countParams.push(`%${search}%`, `%${search}%`);
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
      `SELECT c.*, t.name as tenant_name, t.code as tenant_code
       FROM classes c
       LEFT JOIN tenants t ON c.tenant_id = t.id
       WHERE c.id = ?`,
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
        formatDateForMySQL(start_date),
        formatDateForMySQL(end_date),
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
      params.push(formatDateForMySQL(start_date));
    }
    if (end_date !== undefined) {
      updates.push("end_date = ?");
      params.push(formatDateForMySQL(end_date));
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

// Get class statistics
const getClassStats = async (req, res) => {
  try {
    const [stats] = await promisePool.query(
      `SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active,
        SUM(CASE WHEN status = 'draft' THEN 1 ELSE 0 END) as draft,
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed,
        SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) as cancelled
      FROM classes`
    );

    res.json({
      success: true,
      data: stats[0],
    });
  } catch (error) {
    console.error("Get class stats error:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Assign teachers to class
const assignTeachers = async (req, res) => {
  try {
    const { id } = req.params;
    const { teacher_ids, teachers } = req.body;

    // Support both old format (teacher_ids array) and new format (teachers array with dates)
    let teacherData = [];

    if (teachers && Array.isArray(teachers)) {
      // New format: array of objects with id, start_date, end_date
      teacherData = teachers;
    } else if (teacher_ids && Array.isArray(teacher_ids)) {
      // Old format: array of IDs (backward compatibility)
      teacherData = teacher_ids.map((id) => ({
        id: id,
        start_date: null,
        end_date: null,
      }));
    } else {
      return res.status(400).json({
        success: false,
        message: "Either teacher_ids or teachers array is required",
      });
    }

    // Validate all entries have valid IDs
    if (teacherData.some((t) => !Number.isInteger(t.id) || t.id <= 0)) {
      return res.status(400).json({
        success: false,
        message: "All teacher IDs must be positive integers",
      });
    }

    // Check if class exists
    const [classes] = await promisePool.query(
      "SELECT id, start_date, end_date FROM classes WHERE id = ?",
      [id]
    );

    if (classes.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Class not found",
      });
    }

    const classInfo = classes[0];

    // Extract teacher IDs for validation
    const teacherIds = teacherData.map((t) => t.id);

    // Validate all teachers exist and have teacher role
    if (teacherIds.length > 0) {
      const [teachers] = await promisePool.query(
        `SELECT id FROM users 
         WHERE id IN (?) AND role = 'teacher' AND deleted_at IS NULL`,
        [teacherIds]
      );

      if (teachers.length !== teacherIds.length) {
        return res.status(400).json({
          success: false,
          message:
            "One or more teacher IDs are invalid or users are not teachers",
        });
      }
    }

    // Remove existing teachers
    await promisePool.query("DELETE FROM class_teachers WHERE class_id = ?", [
      id,
    ]);

    // Add new teachers with dates
    if (teacherData.length > 0) {
      for (const teacher of teacherData) {
        const startDate = teacher.start_date
          ? formatDateForMySQL(teacher.start_date)
          : formatDateForMySQL(classInfo.start_date);
        const endDate = teacher.end_date
          ? formatDateForMySQL(teacher.end_date)
          : formatDateForMySQL(classInfo.end_date);

        await promisePool.query(
          "INSERT INTO class_teachers (class_id, user_id, role, start_date, end_date) VALUES (?, ?, ?, ?, ?)",
          [id, teacher.id, "teacher", startDate, endDate]
        );
      }
    }

    res.json({
      success: true,
      message: "Teachers assigned successfully",
      data: {
        class_id: parseInt(id),
        teacher_count: teacherData.length,
      },
    });
  } catch (error) {
    console.error("Assign teachers error:", error);
    console.error("Error details:", {
      message: error.message,
      code: error.code,
      sqlMessage: error.sqlMessage,
    });
    res.status(500).json({
      success: false,
      message: "Server error",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

module.exports = {
  getAllClasses,
  getClassById,
  createClass,
  updateClass,
  deleteClass,
  getClassStats,
  assignTeachers,
};
