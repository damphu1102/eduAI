/*
 Navicat Premium Dump SQL

 Source Server         : edusys_ai_2025_v1
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42-0ubuntu0.22.04.1)
 Source Host           : 45.32.100.86:3306
 Source Schema         : edusys_ai_2025_v1

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42-0ubuntu0.22.04.1)
 File Encoding         : 65001

 Date: 14/11/2025 10:54:05
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity_participation
-- ----------------------------
DROP TABLE IF EXISTS `activity_participation`;
CREATE TABLE `activity_participation`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `participation_type` enum('activity','speak','submit','answer','group','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'activity',
  `reference_id` bigint UNSIGNED NULL DEFAULT NULL,
  `score` decimal(6, 2) NULL DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ap_session_student`(`class_session_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE,
  CONSTRAINT `activity_participation_ibfk_1` FOREIGN KEY (`class_session_id`) REFERENCES `class_sessions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `activity_participation_ibfk_2` FOREIGN KEY (`student_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_response_files
-- ----------------------------
DROP TABLE IF EXISTS `activity_response_files`;
CREATE TABLE `activity_response_files`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `response_id` bigint UNSIGNED NOT NULL,
  `document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `mime_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `file_size` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_arf_response`(`response_id` ASC) USING BTREE,
  CONSTRAINT `activity_response_files_ibfk_1` FOREIGN KEY (`response_id`) REFERENCES `activity_responses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `activity_response_files_ibfk_2` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_responses
-- ----------------------------
DROP TABLE IF EXISTS `activity_responses`;
CREATE TABLE `activity_responses`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_activity_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `response_json` json NULL,
  `score` decimal(8, 2) NULL DEFAULT NULL,
  `feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ar_unique`(`session_activity_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_ar_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `activity_responses_ibfk_1` FOREIGN KEY (`session_activity_id`) REFERENCES `session_activities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `activity_responses_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_template_assets
-- ----------------------------
DROP TABLE IF EXISTS `activity_template_assets`;
CREATE TABLE `activity_template_assets`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `template_id` bigint UNSIGNED NOT NULL,
  `document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_ataa_template`(`template_id` ASC) USING BTREE,
  CONSTRAINT `activity_template_assets_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `activity_templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `activity_template_assets_ibfk_2` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_template_roles
-- ----------------------------
DROP TABLE IF EXISTS `activity_template_roles`;
CREATE TABLE `activity_template_roles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `template_id` bigint UNSIGNED NOT NULL,
  `role_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_atr_template`(`template_id` ASC) USING BTREE,
  CONSTRAINT `activity_template_roles_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `activity_templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_template_steps
-- ----------------------------
DROP TABLE IF EXISTS `activity_template_steps`;
CREATE TABLE `activity_template_steps`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `template_id` bigint UNSIGNED NOT NULL,
  `step_type` enum('warm_up','instruction','pair_work','group_work','individual','assessment','wrap_up','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `duration_minutes` int UNSIGNED NULL DEFAULT NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ats_template_order`(`template_id` ASC, `order_index` ASC) USING BTREE,
  CONSTRAINT `activity_template_steps_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `activity_templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_template_tags
-- ----------------------------
DROP TABLE IF EXISTS `activity_template_tags`;
CREATE TABLE `activity_template_tags`  (
  `template_id` bigint UNSIGNED NOT NULL,
  `tag_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`template_id`, `tag_id`) USING BTREE,
  INDEX `tag_id`(`tag_id` ASC) USING BTREE,
  CONSTRAINT `activity_template_tags_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `activity_templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `activity_template_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_templates
-- ----------------------------
DROP TABLE IF EXISTS `activity_templates`;
CREATE TABLE `activity_templates`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `activity_kind` enum('discussion','role_play','presentation','listening_drill','quick_quiz','flashcards','writing_log','debate','e_learning','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `phase_hint` enum('pre','in','post') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `skill` enum('listening','speaking','reading','writing','vocabulary','grammar','general') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `duration_minutes` int UNSIGNED NULL DEFAULT NULL,
  `objectives` json NULL,
  `instructions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `configuration` json NULL,
  `owner_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `visibility` enum('private','tenant','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'tenant',
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_activity_tpl_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_act_tpl_kind`(`activity_kind` ASC) USING BTREE,
  INDEX `idx_act_tpl_skill`(`skill` ASC) USING BTREE,
  INDEX `owner_user_id`(`owner_user_id` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE,
  CONSTRAINT `activity_templates_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `activity_templates_ibfk_2` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `activity_templates_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `activity_templates_ibfk_4` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for applications
-- ----------------------------
DROP TABLE IF EXISTS `applications`;
CREATE TABLE `applications`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `lead_id` bigint UNSIGNED NULL DEFAULT NULL,
  `student_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `desired_program_id` bigint UNSIGNED NULL DEFAULT NULL,
  `status` enum('draft','submitted','accepted','rejected','withdrawn') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'submitted',
  `submitted_at` timestamp NULL DEFAULT NULL,
  `decision_at` timestamp NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `desired_program_id`(`desired_program_id` ASC) USING BTREE,
  INDEX `idx_applications_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE,
  INDEX `lead_id`(`lead_id` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE,
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `applications_ibfk_3` FOREIGN KEY (`student_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `applications_ibfk_4` FOREIGN KEY (`desired_program_id`) REFERENCES `program_definitions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for approvals
-- ----------------------------
DROP TABLE IF EXISTS `approvals`;
CREATE TABLE `approvals`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `version_id` bigint UNSIGNED NOT NULL,
  `requested_by` bigint UNSIGNED NULL DEFAULT NULL,
  `assigned_reviewer_id` bigint UNSIGNED NULL DEFAULT NULL,
  `status` enum('requested','in_review','approved','rejected','escalated') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'requested',
  `priority` enum('low','normal','high','urgent') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal',
  `review_deadline` timestamp NULL DEFAULT NULL,
  `decision` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `decision_made_by` bigint UNSIGNED NULL DEFAULT NULL,
  `decision_made_at` timestamp NULL DEFAULT NULL,
  `escalation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `escalated_to` bigint UNSIGNED NULL DEFAULT NULL,
  `escalated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `approvals_assigned_reviewer_id_idx`(`assigned_reviewer_id` ASC) USING BTREE,
  INDEX `approvals_decision_made_by_fkey`(`decision_made_by` ASC) USING BTREE,
  INDEX `approvals_escalated_to_fkey`(`escalated_to` ASC) USING BTREE,
  INDEX `approvals_priority_idx`(`priority` ASC) USING BTREE,
  INDEX `approvals_requested_by_fkey`(`requested_by` ASC) USING BTREE,
  INDEX `approvals_review_deadline_idx`(`review_deadline` ASC) USING BTREE,
  INDEX `approvals_tenant_id_fkey`(`tenant_id` ASC) USING BTREE,
  INDEX `approvals_version_id_status_idx`(`version_id` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `approvals_assigned_reviewer_id_fkey` FOREIGN KEY (`assigned_reviewer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `approvals_decision_made_by_fkey` FOREIGN KEY (`decision_made_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `approvals_escalated_to_fkey` FOREIGN KEY (`escalated_to`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `approvals_requested_by_fkey` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `approvals_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `approvals_version_id_fkey` FOREIGN KEY (`version_id`) REFERENCES `curriculum_framework_versions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assessment_items
-- ----------------------------
DROP TABLE IF EXISTS `assessment_items`;
CREATE TABLE `assessment_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `assessment_id` bigint UNSIGNED NOT NULL,
  `item_type` enum('section','question','task') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'question',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `max_score` decimal(8, 2) NULL DEFAULT 0.00,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  `payload` json NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ai_assessment`(`assessment_id` ASC) USING BTREE,
  CONSTRAINT `assessment_items_ibfk_1` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assessment_results
-- ----------------------------
DROP TABLE IF EXISTS `assessment_results`;
CREATE TABLE `assessment_results`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `assessment_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `score` decimal(8, 2) NULL DEFAULT NULL,
  `details` json NULL,
  `graded_at` timestamp NULL DEFAULT NULL,
  `graded_by` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_assessment_student`(`assessment_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `graded_by`(`graded_by` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE,
  CONSTRAINT `assessment_results_ibfk_1` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assessment_results_ibfk_2` FOREIGN KEY (`student_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assessment_results_ibfk_3` FOREIGN KEY (`graded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assessments
-- ----------------------------
DROP TABLE IF EXISTS `assessments`;
CREATE TABLE `assessments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `assessment_type` enum('pre','mid','final','project','quiz','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'other',
  `total_score` decimal(8, 2) NULL DEFAULT 100.00,
  `due_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_assessments_tenant`(`tenant_id` ASC) USING BTREE,
  CONSTRAINT `assessments_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assessments_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `assessments_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_attachments
-- ----------------------------
DROP TABLE IF EXISTS `assignment_attachments`;
CREATE TABLE `assignment_attachments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `document_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_aatt_assignment`(`assignment_id` ASC) USING BTREE,
  CONSTRAINT `assignment_attachments_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_attachments_ibfk_2` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_collection_items
-- ----------------------------
DROP TABLE IF EXISTS `assignment_collection_items`;
CREATE TABLE `assignment_collection_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `collection_id` bigint UNSIGNED NOT NULL,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_aci_unique`(`collection_id` ASC, `assignment_id` ASC) USING BTREE,
  INDEX `assignment_id`(`assignment_id` ASC) USING BTREE,
  CONSTRAINT `assignment_collection_items_ibfk_1` FOREIGN KEY (`collection_id`) REFERENCES `assignment_collections` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_collection_items_ibfk_2` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_collections
-- ----------------------------
DROP TABLE IF EXISTS `assignment_collections`;
CREATE TABLE `assignment_collections`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `owner_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `visibility` enum('private','tenant','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'private',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ac_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `owner_user_id`(`owner_user_id` ASC) USING BTREE,
  CONSTRAINT `assignment_collections_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_collections_ibfk_2` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_passages
-- ----------------------------
DROP TABLE IF EXISTS `assignment_passages`;
CREATE TABLE `assignment_passages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `kind` enum('reading','listening','prompt','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'reading',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_ap_tenant`(`tenant_id` ASC) USING BTREE,
  CONSTRAINT `assignment_passages_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_passages_ibfk_2` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `assignment_passages_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_permissions
-- ----------------------------
DROP TABLE IF EXISTS `assignment_permissions`;
CREATE TABLE `assignment_permissions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `subject_type` enum('user','role','org_unit') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_id` bigint UNSIGNED NOT NULL,
  `permission` enum('view','edit','assign','delete') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'view',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ap_assignment`(`assignment_id` ASC) USING BTREE,
  INDEX `idx_ap_subject`(`subject_type` ASC, `subject_id` ASC) USING BTREE,
  CONSTRAINT `assignment_permissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_practice_sessions
-- ----------------------------
DROP TABLE IF EXISTS `assignment_practice_sessions`;
CREATE TABLE `assignment_practice_sessions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `status` enum('in_progress','completed','abandoned') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'in_progress',
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `completed_at` timestamp NULL DEFAULT NULL,
  `time_spent_seconds` int NOT NULL DEFAULT 0,
  `answers` json NULL,
  `score` decimal(5, 2) NULL DEFAULT NULL,
  `feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `metadata` json NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `assignment_practice_sessions_assignment_id_idx`(`assignment_id` ASC) USING BTREE,
  INDEX `assignment_practice_sessions_started_at_idx`(`started_at` ASC) USING BTREE,
  INDEX `assignment_practice_sessions_status_idx`(`status` ASC) USING BTREE,
  INDEX `assignment_practice_sessions_tenant_id_user_id_idx`(`tenant_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `assignment_practice_sessions_user_id_fkey`(`user_id` ASC) USING BTREE,
  CONSTRAINT `assignment_practice_sessions_assignment_id_fkey` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_practice_sessions_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_practice_sessions_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_question_media
-- ----------------------------
DROP TABLE IF EXISTS `assignment_question_media`;
CREATE TABLE `assignment_question_media`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `question_id` bigint UNSIGNED NOT NULL,
  `kind` enum('image','audio','video','document','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image',
  `document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_aqm_question`(`question_id` ASC) USING BTREE,
  CONSTRAINT `assignment_question_media_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `assignment_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_question_media_ibfk_2` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_question_options
-- ----------------------------
DROP TABLE IF EXISTS `assignment_question_options`;
CREATE TABLE `assignment_question_options`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `question_id` bigint UNSIGNED NOT NULL,
  `label` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_correct` tinyint(1) NULL DEFAULT 0,
  `points` decimal(8, 2) NULL DEFAULT NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_aqo_question`(`question_id` ASC) USING BTREE,
  CONSTRAINT `assignment_question_options_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `assignment_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_questions
-- ----------------------------
DROP TABLE IF EXISTS `assignment_questions`;
CREATE TABLE `assignment_questions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `type` enum('mcq','true_false','matching','essay','short_answer','audio','speaking','reading') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `stem` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `passage_id` bigint UNSIGNED NULL DEFAULT NULL,
  `points` decimal(8, 2) NULL DEFAULT 1.00,
  `difficulty` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `metadata` json NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_aq_assignment`(`assignment_id` ASC) USING BTREE,
  INDEX `idx_aq_passage`(`passage_id` ASC) USING BTREE,
  CONSTRAINT `assignment_questions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_questions_ibfk_2` FOREIGN KEY (`passage_id`) REFERENCES `assignment_passages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_submissions
-- ----------------------------
DROP TABLE IF EXISTS `assignment_submissions`;
CREATE TABLE `assignment_submissions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `attempt_no` int UNSIGNED NULL DEFAULT 1,
  `status` enum('draft','submitted','graded','returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'submitted',
  `submitted_at` timestamp NULL DEFAULT NULL,
  `graded_at` timestamp NULL DEFAULT NULL,
  `graded_by` bigint UNSIGNED NULL DEFAULT NULL,
  `score` decimal(6, 2) NULL DEFAULT NULL,
  `feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_submission_unique`(`assignment_id` ASC, `student_user_id` ASC, `attempt_no` ASC) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `graded_by`(`graded_by` ASC) USING BTREE,
  INDEX `idx_asgsub_assignment`(`assignment_id` ASC) USING BTREE,
  INDEX `idx_asgsub_student`(`student_user_id` ASC) USING BTREE,
  CONSTRAINT `assignment_submissions_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `assignment_submissions_ibfk_2` FOREIGN KEY (`student_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_submissions_ibfk_3` FOREIGN KEY (`graded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `assignment_submissions_ibfk_4` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignment_tags
-- ----------------------------
DROP TABLE IF EXISTS `assignment_tags`;
CREATE TABLE `assignment_tags`  (
  `assignment_id` bigint UNSIGNED NOT NULL,
  `tag_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`assignment_id`, `tag_id`) USING BTREE,
  INDEX `tag_id`(`tag_id` ASC) USING BTREE,
  CONSTRAINT `assignment_tags_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for assignments
-- ----------------------------
DROP TABLE IF EXISTS `assignments`;
CREATE TABLE `assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `skill` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `duration_minutes` int NOT NULL DEFAULT 0,
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `tags` json NULL,
  `difficulty` enum('easy','medium','hard') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `visibility` enum('public','private','campus','tenant') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'private',
  `objectives` json NULL,
  `rubric` json NULL,
  `attachments` json NULL,
  `content_type` enum('mcq','true_false','matching','essay','audio','speaking','reading','project','worksheet','presentation','quiz','diagnostic') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` json NULL,
  `version_number` int NOT NULL DEFAULT 1,
  `parent_id` bigint UNSIGNED NULL DEFAULT NULL,
  `is_latest` tinyint(1) NOT NULL DEFAULT 1,
  `version_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `updated_by` bigint UNSIGNED NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `owner_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `assignments_created_by_fkey`(`created_by` ASC) USING BTREE,
  INDEX `assignments_tenant_id_level_idx`(`tenant_id` ASC, `level` ASC) USING BTREE,
  INDEX `assignments_tenant_id_skill_idx`(`tenant_id` ASC, `skill` ASC) USING BTREE,
  INDEX `assignments_title_idx`(`title` ASC) USING BTREE,
  INDEX `assignments_updated_by_fkey`(`updated_by` ASC) USING BTREE,
  INDEX `idx_assignments_difficulty`(`tenant_id` ASC, `difficulty` ASC) USING BTREE,
  INDEX `idx_assignments_owner`(`tenant_id` ASC, `owner_user_id` ASC) USING BTREE,
  INDEX `idx_assignments_visibility`(`tenant_id` ASC, `visibility` ASC) USING BTREE,
  CONSTRAINT `assignments_created_by_fkey` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `assignments_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignments_updated_by_fkey` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for attendance_adjustments
-- ----------------------------
DROP TABLE IF EXISTS `attendance_adjustments`;
CREATE TABLE `attendance_adjustments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `from_status` enum('present','absent','late','excused') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_status` enum('present','absent','late','excused') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `requested_by` bigint UNSIGNED NULL DEFAULT NULL,
  `approved_by` bigint UNSIGNED NULL DEFAULT NULL,
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_at` datetime NULL DEFAULT NULL,
  `status` enum('pending','approved','rejected','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_att_adj_unique`(`class_session_id` ASC, `student_user_id` ASC, `requested_at` ASC) USING BTREE,
  INDEX `approved_by`(`approved_by` ASC) USING BTREE,
  INDEX `idx_att_adj_status`(`status` ASC) USING BTREE,
  INDEX `requested_by`(`requested_by` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE,
  CONSTRAINT `attendance_adjustments_ibfk_1` FOREIGN KEY (`class_session_id`) REFERENCES `class_sessions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attendance_adjustments_ibfk_2` FOREIGN KEY (`student_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attendance_adjustments_ibfk_3` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `attendance_adjustments_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for attendance_checkins
-- ----------------------------
DROP TABLE IF EXISTS `attendance_checkins`;
CREATE TABLE `attendance_checkins`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `method` enum('qr','zoom','manual','device') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual',
  `device_info` json NULL,
  `geo_lat` decimal(9, 6) NULL DEFAULT NULL,
  `geo_lng` decimal(9, 6) NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ac_session`(`class_session_id` ASC) USING BTREE,
  INDEX `idx_ac_student`(`student_user_id` ASC) USING BTREE,
  CONSTRAINT `attendance_checkins_ibfk_1` FOREIGN KEY (`class_session_id`) REFERENCES `class_sessions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attendance_checkins_ibfk_2` FOREIGN KEY (`student_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for attendance_records
-- ----------------------------
DROP TABLE IF EXISTS `attendance_records`;
CREATE TABLE `attendance_records`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `status` enum('present','absent','late','excused') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'present',
  `check_in_at` datetime NULL DEFAULT NULL,
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_attendance_session_student`(`class_session_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `idx_attendance_status`(`status` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE,
  CONSTRAINT `attendance_records_ibfk_1` FOREIGN KEY (`class_session_id`) REFERENCES `class_sessions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attendance_records_ibfk_2` FOREIGN KEY (`student_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for attendance_summary
-- ----------------------------
DROP TABLE IF EXISTS `attendance_summary`;
CREATE TABLE `attendance_summary`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `sessions_attended` int UNSIGNED NULL DEFAULT 0,
  `sessions_total` int UNSIGNED NULL DEFAULT 0,
  `attendance_rate` decimal(6, 3) NULL DEFAULT NULL,
  `last_calculated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_attendance_summary`(`class_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE,
  CONSTRAINT `attendance_summary_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attendance_summary_ibfk_2` FOREIGN KEY (`student_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for audit_logs
-- ----------------------------
DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `actor_id` bigint UNSIGNED NULL DEFAULT NULL,
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `action` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` bigint UNSIGNED NOT NULL,
  `old_values` json NULL,
  `new_values` json NULL,
  `metadata` json NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `audit_logs_actor_id_action_idx`(`actor_id` ASC, `action` ASC) USING BTREE,
  INDEX `audit_logs_created_at_idx`(`created_at` ASC) USING BTREE,
  INDEX `audit_logs_entity_type_entity_id_idx`(`entity_type` ASC, `entity_id` ASC) USING BTREE,
  INDEX `audit_logs_session_id_idx`(`session_id` ASC) USING BTREE,
  INDEX `audit_logs_tenant_id_fkey`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3419 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for badges
-- ----------------------------
DROP TABLE IF EXISTS `badges`;
CREATE TABLE `badges`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `criteria` json NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_badge_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for billing_plans
-- ----------------------------
DROP TABLE IF EXISTS `billing_plans`;
CREATE TABLE `billing_plans`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `price_cents` bigint UNSIGNED NOT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `interval_unit` enum('day','week','month','year') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'month',
  `interval_count` int UNSIGNED NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for calendar_event_participants
-- ----------------------------
DROP TABLE IF EXISTS `calendar_event_participants`;
CREATE TABLE `calendar_event_participants`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `calendar_event_id` bigint UNSIGNED NOT NULL,
  `subject_type` enum('user','class','org_unit','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_id` bigint UNSIGNED NOT NULL,
  `role` enum('attendee','host','teacher','student','staff','proctor') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'attendee',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cep_event`(`calendar_event_id` ASC) USING BTREE,
  INDEX `idx_cep_subject`(`subject_type` ASC, `subject_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for calendar_events
-- ----------------------------
DROP TABLE IF EXISTS `calendar_events`;
CREATE TABLE `calendar_events`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `event_type` enum('class_session','exam_event','meeting','staff_shift','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ref_id` bigint UNSIGNED NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `visibility` enum('tenant','campus','class','private') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'tenant',
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `campus_id`(`campus_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_ce_tenant_time`(`tenant_id` ASC, `starts_at` ASC) USING BTREE,
  INDEX `idx_ce_type_ref`(`event_type` ASC, `ref_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for calendar_events_sync
-- ----------------------------
DROP TABLE IF EXISTS `calendar_events_sync`;
CREATE TABLE `calendar_events_sync`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `provider` enum('google','microsoft','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_event_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sync_status` enum('pending','synced','error','deleted') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `last_synced_at` datetime NULL DEFAULT NULL,
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_event_sync`(`class_session_id` ASC, `provider` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for campuses
-- ----------------------------
DROP TABLE IF EXISTS `campuses`;
CREATE TABLE `campuses`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `contact_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `contact_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `settings` json NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `campuses_tenant_id_code_key`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `campuses_tenant_id_is_active_idx`(`tenant_id` ASC, `is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for certificate_issuances
-- ----------------------------
DROP TABLE IF EXISTS `certificate_issuances`;
CREATE TABLE `certificate_issuances`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `template_id` bigint UNSIGNED NOT NULL,
  `verification_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `issue_date` date NOT NULL,
  `status` enum('pending','issued','revoked') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'issued',
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_cert_token`(`verification_token` ASC) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_ci_student`(`student_user_id` ASC) USING BTREE,
  INDEX `template_id`(`template_id` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for certificate_templates
-- ----------------------------
DROP TABLE IF EXISTS `certificate_templates`;
CREATE TABLE `certificate_templates`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `template_json` json NULL,
  `background_document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `signatory_names` json NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_cert_tpl_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `background_document_id`(`background_document_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for certificate_verifications
-- ----------------------------
DROP TABLE IF EXISTS `certificate_verifications`;
CREATE TABLE `certificate_verifications`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `issuance_id` bigint UNSIGNED NOT NULL,
  `verified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `outcome` enum('valid','invalid','revoked') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'valid',
  `metadata` json NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cv_iss`(`issuance_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_assignment_overrides
-- ----------------------------
DROP TABLE IF EXISTS `class_assignment_overrides`;
CREATE TABLE `class_assignment_overrides`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_assignment_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `extended_due_at` datetime NULL DEFAULT NULL,
  `late_policy_override` enum('allow','deduct','reject') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_override_unique`(`class_assignment_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_assignments
-- ----------------------------
DROP TABLE IF EXISTS `class_assignments`;
CREATE TABLE `class_assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `assigned_by` bigint UNSIGNED NULL DEFAULT NULL,
  `status` enum('draft','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `available_at` datetime NULL DEFAULT NULL,
  `due_at` datetime NULL DEFAULT NULL,
  `max_attempts` int UNSIGNED NULL DEFAULT NULL,
  `late_policy` enum('allow','deduct','reject') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'allow',
  `late_deduction_percent` decimal(5, 2) NULL DEFAULT NULL,
  `visibility` enum('class','private','hidden') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'class',
  `instructions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `assigned_by`(`assigned_by` ASC) USING BTREE,
  INDEX `idx_ca_assignment`(`assignment_id` ASC) USING BTREE,
  INDEX `idx_ca_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_ca_due`(`due_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_enrollments
-- ----------------------------
DROP TABLE IF EXISTS `class_enrollments`;
CREATE TABLE `class_enrollments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `status` enum('pending','active','completed','dropped','suspended') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'active',
  `enrolled_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_enrollment_class_student`(`class_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `idx_enrollments_status`(`status` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_game_assignment_groups
-- ----------------------------
DROP TABLE IF EXISTS `class_game_assignment_groups`;
CREATE TABLE `class_game_assignment_groups`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_game_assignment_id` bigint UNSIGNED NOT NULL,
  `student_group_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_cgag_unique`(`class_game_assignment_id` ASC, `student_group_id` ASC) USING BTREE,
  INDEX `student_group_id`(`student_group_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_game_assignment_overrides
-- ----------------------------
DROP TABLE IF EXISTS `class_game_assignment_overrides`;
CREATE TABLE `class_game_assignment_overrides`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_game_assignment_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `extended_due_at` datetime NULL DEFAULT NULL,
  `max_attempts_override` int UNSIGNED NULL DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_cgao_unique`(`class_game_assignment_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_game_assignments
-- ----------------------------
DROP TABLE IF EXISTS `class_game_assignments`;
CREATE TABLE `class_game_assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `game_id` bigint UNSIGNED NOT NULL,
  `assigned_by` bigint UNSIGNED NULL DEFAULT NULL,
  `status` enum('draft','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `group_mode` enum('individual','group') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'individual',
  `available_at` datetime NULL DEFAULT NULL,
  `due_at` datetime NULL DEFAULT NULL,
  `max_attempts` int UNSIGNED NULL DEFAULT NULL,
  `visibility` enum('class','private','hidden') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'class',
  `instructions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `assigned_by`(`assigned_by` ASC) USING BTREE,
  INDEX `idx_cga_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_cga_due`(`due_at` ASC) USING BTREE,
  INDEX `idx_cga_game`(`game_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_gamification_policies
-- ----------------------------
DROP TABLE IF EXISTS `class_gamification_policies`;
CREATE TABLE `class_gamification_policies`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `enable_bonus` tinyint(1) NULL DEFAULT 1,
  `bonus_cap_percent` decimal(5, 2) NOT NULL DEFAULT 5.00,
  `rules` json NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_cgp`(`class_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_observations
-- ----------------------------
DROP TABLE IF EXISTS `class_observations`;
CREATE TABLE `class_observations`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `class_session_id` bigint UNSIGNED NULL DEFAULT NULL,
  `observer_user_id` bigint UNSIGNED NOT NULL,
  `rubric_id` bigint UNSIGNED NULL DEFAULT NULL,
  `observation_date` date NOT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_session_id`(`class_session_id` ASC) USING BTREE,
  INDEX `idx_obs_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_obs_date`(`observation_date` ASC) USING BTREE,
  INDEX `observer_user_id`(`observer_user_id` ASC) USING BTREE,
  INDEX `rubric_id`(`rubric_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_policies
-- ----------------------------
DROP TABLE IF EXISTS `class_policies`;
CREATE TABLE `class_policies`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `attendance_required_percent` decimal(5, 2) NULL DEFAULT NULL,
  `late_submission_policy` enum('allow','deduct','reject') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'allow',
  `late_deduction_per_day` decimal(5, 2) NULL DEFAULT NULL,
  `max_late_days` int UNSIGNED NULL DEFAULT NULL,
  `grading_policy` json NULL,
  `exam_rules` json NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_policy_class`(`class_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_sessions
-- ----------------------------
DROP TABLE IF EXISTS `class_sessions`;
CREATE TABLE `class_sessions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `unit_blueprint_id` bigint UNSIGNED NULL DEFAULT NULL,
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `status` enum('scheduled','completed','canceled','no_show') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'scheduled',
  `room` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sessions_class_time`(`class_id` ASC, `starts_at` ASC) USING BTREE,
  INDEX `idx_sessions_status`(`status` ASC) USING BTREE,
  INDEX `unit_blueprint_id`(`unit_blueprint_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_teachers
-- ----------------------------
DROP TABLE IF EXISTS `class_teachers`;
CREATE TABLE `class_teachers`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role` enum('teacher','ta') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'teacher',
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_class_teacher_role`(`class_id` ASC, `user_id` ASC, `role` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for classes
-- ----------------------------
DROP TABLE IF EXISTS `classes`;
CREATE TABLE `classes`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `course_blueprint_id` bigint UNSIGNED NULL DEFAULT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `language` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `max_students` int UNSIGNED NULL DEFAULT 20,
  `status` enum('draft','active','completed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'draft',
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `schedule` json NULL,
  `room` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_class_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `course_blueprint_id`(`course_blueprint_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_classes_campus`(`campus_id` ASC) USING BTREE,
  INDEX `idx_classes_level`(`level` ASC) USING BTREE,
  INDEX `idx_classes_status`(`status` ASC) USING BTREE,
  INDEX `idx_classes_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `entity_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` bigint UNSIGNED NOT NULL,
  `author_id` bigint UNSIGNED NULL DEFAULT NULL,
  `parent_id` bigint UNSIGNED NULL DEFAULT NULL,
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mentions` json NULL,
  `attachments` json NULL,
  `is_resolved` tinyint(1) NOT NULL DEFAULT 0,
  `resolved_by` bigint UNSIGNED NULL DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `edited_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `comments_author_id_idx`(`author_id` ASC) USING BTREE,
  INDEX `comments_deleted_at_idx`(`deleted_at` ASC) USING BTREE,
  INDEX `comments_entity_type_entity_id_idx`(`entity_type` ASC, `entity_id` ASC) USING BTREE,
  INDEX `comments_is_resolved_idx`(`is_resolved` ASC) USING BTREE,
  INDEX `comments_parent_id_fkey`(`parent_id` ASC) USING BTREE,
  INDEX `comments_tenant_id_fkey`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for completion_tracking
-- ----------------------------
DROP TABLE IF EXISTS `completion_tracking`;
CREATE TABLE `completion_tracking`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `item_type` enum('unit','assignment','assessment','session') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_id` bigint UNSIGNED NOT NULL,
  `status` enum('not_started','in_progress','completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'in_progress',
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_completion_item`(`student_user_id` ASC, `item_type` ASC, `item_id` ASC) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `idx_ct_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for conflict_logs
-- ----------------------------
DROP TABLE IF EXISTS `conflict_logs`;
CREATE TABLE `conflict_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `class_session_id` bigint UNSIGNED NULL DEFAULT NULL,
  `conflict_type` enum('teacher','room','student','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `details` json NULL,
  `detected_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cl_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_cl_session`(`class_session_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for contract_items
-- ----------------------------
DROP TABLE IF EXISTS `contract_items`;
CREATE TABLE `contract_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` bigint UNSIGNED NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int UNSIGNED NOT NULL DEFAULT 1,
  `unit_price_cents` bigint UNSIGNED NOT NULL,
  `amount_cents` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ci_contract`(`contract_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for contracts
-- ----------------------------
DROP TABLE IF EXISTS `contracts`;
CREATE TABLE `contracts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `application_id` bigint UNSIGNED NULL DEFAULT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `contract_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `status` enum('draft','active','completed','terminated','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'active',
  `total_amount_cents` bigint UNSIGNED NULL DEFAULT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'USD',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_contract_number`(`contract_number` ASC) USING BTREE,
  INDEX `application_id`(`application_id` ASC) USING BTREE,
  INDEX `idx_contracts_status`(`status` ASC) USING BTREE,
  INDEX `idx_contracts_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for course_blueprints
-- ----------------------------
DROP TABLE IF EXISTS `course_blueprints`;
CREATE TABLE `course_blueprints`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `version_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `hours` int NOT NULL DEFAULT 0,
  `order_index` int NOT NULL DEFAULT 0,
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `learning_outcomes` json NULL,
  `assessment_types` json NULL,
  `prerequisites` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `course_blueprints_created_by_fkey`(`created_by` ASC) USING BTREE,
  INDEX `course_blueprints_deleted_at_idx`(`deleted_at` ASC) USING BTREE,
  INDEX `course_blueprints_version_id_order_index_idx`(`version_id` ASC, `order_index` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for courses
-- ----------------------------
DROP TABLE IF EXISTS `courses`;
CREATE TABLE `courses`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `duration` int NULL DEFAULT NULL,
  `status` enum('draft','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for curriculum_framework_tags
-- ----------------------------
DROP TABLE IF EXISTS `curriculum_framework_tags`;
CREATE TABLE `curriculum_framework_tags`  (
  `framework_id` bigint UNSIGNED NOT NULL,
  `tag_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`framework_id`, `tag_id`) USING BTREE,
  INDEX `curriculum_framework_tags_tag_id_fkey`(`tag_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for curriculum_framework_versions
-- ----------------------------
DROP TABLE IF EXISTS `curriculum_framework_versions`;
CREATE TABLE `curriculum_framework_versions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `framework_id` bigint UNSIGNED NOT NULL,
  `version_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` enum('draft','pending_review','approved','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `is_frozen` tinyint(1) NOT NULL DEFAULT 0,
  `changelog` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `review_deadline` timestamp NULL DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `archived_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `metadata` json NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `curriculum_framework_versions_framework_id_version_no_key`(`framework_id` ASC, `version_no` ASC) USING BTREE,
  INDEX `curriculum_framework_versions_created_by_fkey`(`created_by` ASC) USING BTREE,
  INDEX `curriculum_framework_versions_deleted_at_idx`(`deleted_at` ASC) USING BTREE,
  INDEX `curriculum_framework_versions_framework_id_state_idx`(`framework_id` ASC, `state` ASC) USING BTREE,
  INDEX `curriculum_framework_versions_is_frozen_idx`(`is_frozen` ASC) USING BTREE,
  INDEX `curriculum_framework_versions_state_created_at_idx`(`state` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for curriculum_frameworks
-- ----------------------------
DROP TABLE IF EXISTS `curriculum_frameworks`;
CREATE TABLE `curriculum_frameworks`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `age_group` enum('kids','teens','adults','all') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `total_hours` int NOT NULL DEFAULT 0,
  `status` enum('draft','pending_review','approved','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `owner_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `latest_version_id` bigint UNSIGNED NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `learning_objectives` json NULL,
  `prerequisites` json NULL,
  `assessment_strategy` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `curriculum_frameworks_code_key`(`code` ASC) USING BTREE,
  INDEX `curriculum_frameworks_age_group_idx`(`age_group` ASC) USING BTREE,
  INDEX `curriculum_frameworks_campus_id_fkey`(`campus_id` ASC) USING BTREE,
  INDEX `curriculum_frameworks_code_idx`(`code` ASC) USING BTREE,
  INDEX `curriculum_frameworks_deleted_at_idx`(`deleted_at` ASC) USING BTREE,
  INDEX `curriculum_frameworks_language_idx`(`language` ASC) USING BTREE,
  INDEX `curriculum_frameworks_owner_user_id_idx`(`owner_user_id` ASC) USING BTREE,
  INDEX `curriculum_frameworks_status_idx`(`status` ASC) USING BTREE,
  INDEX `curriculum_frameworks_tenant_id_campus_id_idx`(`tenant_id` ASC, `campus_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer_interactions
-- ----------------------------
DROP TABLE IF EXISTS `customer_interactions`;
CREATE TABLE `customer_interactions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `lead_id` bigint UNSIGNED NULL DEFAULT NULL,
  `student_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `channel` enum('phone','email','chat','meeting','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ci_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `lead_id`(`lead_id` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_ai_tag_suggestions
-- ----------------------------
DROP TABLE IF EXISTS `document_ai_tag_suggestions`;
CREATE TABLE `document_ai_tag_suggestions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint UNSIGNED NOT NULL,
  `tag_label` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `confidence` decimal(5, 2) NULL DEFAULT NULL,
  `accepted` tinyint(1) NULL DEFAULT 0,
  `accepted_by` bigint UNSIGNED NULL DEFAULT NULL,
  `accepted_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `accepted_by`(`accepted_by` ASC) USING BTREE,
  INDEX `idx_dats_doc`(`document_id` ASC) USING BTREE,
  INDEX `idx_dats_label`(`tag_label` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_ai_tasks
-- ----------------------------
DROP TABLE IF EXISTS `document_ai_tasks`;
CREATE TABLE `document_ai_tasks`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint UNSIGNED NOT NULL,
  `task_type` enum('summarize','tag_suggestion','segment','level_suggestion','topic_suggestion','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` enum('queued','running','completed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `input_json` json NULL,
  `output_json` json NULL,
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `finished_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dat_doc`(`document_id` ASC) USING BTREE,
  INDEX `idx_dat_status`(`status` ASC) USING BTREE,
  INDEX `idx_dat_type`(`task_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 401 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_collection_favorites
-- ----------------------------
DROP TABLE IF EXISTS `document_collection_favorites`;
CREATE TABLE `document_collection_favorites`  (
  `collection_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`collection_id`, `user_id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_collection_permissions
-- ----------------------------
DROP TABLE IF EXISTS `document_collection_permissions`;
CREATE TABLE `document_collection_permissions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `collection_id` bigint UNSIGNED NOT NULL,
  `subject_type` enum('user','role','org_unit') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_id` bigint UNSIGNED NOT NULL,
  `permission` enum('view','edit','manage','share') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'view',
  `expires_at` datetime NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_dcp_collection`(`collection_id` ASC) USING BTREE,
  INDEX `idx_dcp_subject`(`subject_type` ASC, `subject_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_collections
-- ----------------------------
DROP TABLE IF EXISTS `document_collections`;
CREATE TABLE `document_collections`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_public` tinyint(1) NULL DEFAULT 0,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_doc_collections_created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_doc_collections_public`(`is_public` ASC) USING BTREE,
  INDEX `idx_doc_collections_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_derivatives
-- ----------------------------
DROP TABLE IF EXISTS `document_derivatives`;
CREATE TABLE `document_derivatives`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint UNSIGNED NOT NULL,
  `kind` enum('thumbnail','preview_pdf','preview_image','audio_transcode','video_transcode','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `width` int UNSIGNED NULL DEFAULT NULL,
  `height` int UNSIGNED NULL DEFAULT NULL,
  `duration_seconds` int UNSIGNED NULL DEFAULT NULL,
  `file_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dd_doc`(`document_id` ASC) USING BTREE,
  INDEX `idx_dd_kind`(`kind` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_external_refs
-- ----------------------------
DROP TABLE IF EXISTS `document_external_refs`;
CREATE TABLE `document_external_refs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint UNSIGNED NOT NULL,
  `provider` enum('gdrive','onedrive','dropbox','url','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `web_view_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `metadata` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_doc_ext`(`document_id` ASC, `provider` ASC) USING BTREE,
  INDEX `idx_der_provider`(`provider` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_favorites
-- ----------------------------
DROP TABLE IF EXISTS `document_favorites`;
CREATE TABLE `document_favorites`  (
  `document_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`document_id`, `user_id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_pages
-- ----------------------------
DROP TABLE IF EXISTS `document_pages`;
CREATE TABLE `document_pages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint UNSIGNED NOT NULL,
  `page_no` int UNSIGNED NOT NULL,
  `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `bbox_json` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_doc_page`(`document_id` ASC, `page_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_previews
-- ----------------------------
DROP TABLE IF EXISTS `document_previews`;
CREATE TABLE `document_previews`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint UNSIGNED NOT NULL,
  `preview_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dp_doc`(`document_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_processing_jobs
-- ----------------------------
DROP TABLE IF EXISTS `document_processing_jobs`;
CREATE TABLE `document_processing_jobs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint UNSIGNED NOT NULL,
  `task` enum('ocr','summarize','segment','transcode','thumbnail','analyze_level','analyze_topic') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('queued','running','completed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `started_at` datetime NULL DEFAULT NULL,
  `finished_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dpj_doc`(`document_id` ASC) USING BTREE,
  INDEX `idx_dpj_status`(`status` ASC) USING BTREE,
  INDEX `idx_dpj_task`(`task` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_shares
-- ----------------------------
DROP TABLE IF EXISTS `document_shares`;
CREATE TABLE `document_shares`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint UNSIGNED NOT NULL,
  `subject_type` enum('user','role','org_unit') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_id` bigint UNSIGNED NOT NULL,
  `permission` enum('view','download','edit','delete','share') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'view',
  `expires_at` datetime NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_ds_doc`(`document_id` ASC) USING BTREE,
  INDEX `idx_ds_subject`(`subject_type` ASC, `subject_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for document_tags
-- ----------------------------
DROP TABLE IF EXISTS `document_tags`;
CREATE TABLE `document_tags`  (
  `document_id` bigint UNSIGNED NOT NULL,
  `tag_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`document_id`, `tag_id`) USING BTREE,
  INDEX `tag_id`(`tag_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for documents
-- ----------------------------
DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `file_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `mime_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `file_size` bigint UNSIGNED NULL DEFAULT NULL,
  `ocr_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `ai_tags` json NULL,
  `manual_tags` json NULL,
  `health_status` enum('healthy','broken','expired','restricted','unknown') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'unknown',
  `last_health_check` timestamp NULL DEFAULT NULL,
  `visibility` enum('private','tenant','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'tenant',
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `collection_id` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_doc_created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_doc_health`(`health_status` ASC) USING BTREE,
  INDEX `idx_doc_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `idx_doc_visibility`(`visibility` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE,
  INDEX `idx_documents_collection_id`(`collection_id` ASC) USING BTREE,
  FULLTEXT INDEX `ft_documents_all`(`name`, `description`, `ocr_text`),
  CONSTRAINT `fk_documents_collection_id` FOREIGN KEY (`collection_id`) REFERENCES `document_collections` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 225 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dropout_risk_flags
-- ----------------------------
DROP TABLE IF EXISTS `dropout_risk_flags`;
CREATE TABLE `dropout_risk_flags`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `risk_level` enum('low','medium','high','critical') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'low',
  `factors` json NULL,
  `status` enum('open','resolved') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `flagged_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `idx_drf_status`(`status` ASC) USING BTREE,
  INDEX `idx_drf_student_class`(`student_user_id` ASC, `class_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for enquiries
-- ----------------------------
DROP TABLE IF EXISTS `enquiries`;
CREATE TABLE `enquiries`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `lead_id` bigint UNSIGNED NULL DEFAULT NULL,
  `channel` enum('phone','email','web_form','walk_in','social','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_enquiries_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `lead_id`(`lead_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_answer_events
-- ----------------------------
DROP TABLE IF EXISTS `exam_answer_events`;
CREATE TABLE `exam_answer_events`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `attempt_id` bigint UNSIGNED NOT NULL,
  `exam_item_id` bigint UNSIGNED NULL DEFAULT NULL,
  `event_type` enum('autosave','answer_change','flag','unflag') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exam_item_id`(`exam_item_id` ASC) USING BTREE,
  INDEX `idx_eae_attempt`(`attempt_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_attempt_items
-- ----------------------------
DROP TABLE IF EXISTS `exam_attempt_items`;
CREATE TABLE `exam_attempt_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `attempt_id` bigint UNSIGNED NOT NULL,
  `exam_item_id` bigint UNSIGNED NOT NULL,
  `answer_json` json NULL,
  `score` decimal(8, 2) NULL DEFAULT NULL,
  `graded_by` bigint UNSIGNED NULL DEFAULT NULL,
  `graded_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_attempt_item`(`attempt_id` ASC, `exam_item_id` ASC) USING BTREE,
  INDEX `exam_item_id`(`exam_item_id` ASC) USING BTREE,
  INDEX `graded_by`(`graded_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_attempts
-- ----------------------------
DROP TABLE IF EXISTS `exam_attempts`;
CREATE TABLE `exam_attempts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_event_id` bigint UNSIGNED NOT NULL,
  `exam_version_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `attempt_no` int UNSIGNED NOT NULL DEFAULT 1,
  `status` enum('not_started','in_progress','submitted','graded','void') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'not_started',
  `started_at` datetime NULL DEFAULT NULL,
  `submitted_at` datetime NULL DEFAULT NULL,
  `duration_seconds` int UNSIGNED NULL DEFAULT NULL,
  `score` decimal(8, 2) NULL DEFAULT NULL,
  `metadata` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_attempt_unique`(`exam_event_id` ASC, `student_user_id` ASC, `attempt_no` ASC) USING BTREE,
  INDEX `exam_version_id`(`exam_version_id` ASC) USING BTREE,
  INDEX `idx_attempt_status`(`status` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_blueprint_attachments
-- ----------------------------
DROP TABLE IF EXISTS `exam_blueprint_attachments`;
CREATE TABLE `exam_blueprint_attachments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `blueprint_id` bigint UNSIGNED NOT NULL,
  `document_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_eba_bp`(`blueprint_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_blueprint_tags
-- ----------------------------
DROP TABLE IF EXISTS `exam_blueprint_tags`;
CREATE TABLE `exam_blueprint_tags`  (
  `blueprint_id` bigint UNSIGNED NOT NULL,
  `tag_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`blueprint_id`, `tag_id`) USING BTREE,
  INDEX `tag_id`(`tag_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_blueprints
-- ----------------------------
DROP TABLE IF EXISTS `exam_blueprints`;
CREATE TABLE `exam_blueprints`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exam_type` enum('placement','quiz','mid','final','mock','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'quiz',
  `level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `skill` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `subject` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `owner_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_exam_blueprint_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_exam_bp_level`(`level` ASC) USING BTREE,
  INDEX `idx_exam_bp_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `idx_exam_bp_type`(`exam_type` ASC) USING BTREE,
  INDEX `owner_user_id`(`owner_user_id` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_events
-- ----------------------------
DROP TABLE IF EXISTS `exam_events`;
CREATE TABLE `exam_events`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `exam_version_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mode` enum('online','offline','hybrid') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'online',
  `group_mode` enum('class','group','individual') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'class',
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `scheduled_start` datetime NOT NULL,
  `scheduled_end` datetime NOT NULL,
  `registration_deadline` datetime NULL DEFAULT NULL,
  `capacity` int UNSIGNED NULL DEFAULT NULL,
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `room_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `meeting_provider` enum('zoom','meet','teams','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `meeting_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `campus_id`(`campus_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `exam_version_id`(`exam_version_id` ASC) USING BTREE,
  INDEX `idx_event_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_event_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `idx_event_time`(`scheduled_start` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_items
-- ----------------------------
DROP TABLE IF EXISTS `exam_items`;
CREATE TABLE `exam_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `section_id` bigint UNSIGNED NOT NULL,
  `item_type` enum('question','task','passage') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'question',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `points` decimal(8, 2) NOT NULL DEFAULT 1.00,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  `question_id` bigint UNSIGNED NULL DEFAULT NULL,
  `passage_id` bigint UNSIGNED NULL DEFAULT NULL,
  `payload` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_exam_items_order`(`section_id` ASC, `order_index` ASC) USING BTREE,
  INDEX `idx_exam_items_section`(`section_id` ASC) USING BTREE,
  INDEX `passage_id`(`passage_id` ASC) USING BTREE,
  INDEX `question_id`(`question_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_policies
-- ----------------------------
DROP TABLE IF EXISTS `exam_policies`;
CREATE TABLE `exam_policies`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `scope_type` enum('blueprint','event') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `blueprint_id` bigint UNSIGNED NULL DEFAULT NULL,
  `exam_event_id` bigint UNSIGNED NULL DEFAULT NULL,
  `pass_mark` decimal(6, 2) NULL DEFAULT NULL,
  `max_attempts` int UNSIGNED NULL DEFAULT NULL,
  `time_limit_minutes` int UNSIGNED NULL DEFAULT NULL,
  `allow_back` tinyint(1) NULL DEFAULT 1,
  `open_book` tinyint(1) NULL DEFAULT 0,
  `proctoring_required` tinyint(1) NULL DEFAULT 0,
  `retake_wait_days` int UNSIGNED NULL DEFAULT NULL,
  `ai_scoring_enabled` tinyint(1) NULL DEFAULT 0,
  `settings_json` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ep_blueprint`(`blueprint_id` ASC) USING BTREE,
  INDEX `idx_ep_event`(`exam_event_id` ASC) USING BTREE,
  INDEX `idx_ep_scope`(`scope_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_registrations
-- ----------------------------
DROP TABLE IF EXISTS `exam_registrations`;
CREATE TABLE `exam_registrations`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_event_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `status` enum('registered','checked_in','in_progress','submitted','graded','absent','no_show','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'registered',
  `seat_no` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `check_in_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_exam_reg`(`exam_event_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `idx_reg_status`(`status` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_room_allocations
-- ----------------------------
DROP TABLE IF EXISTS `exam_room_allocations`;
CREATE TABLE `exam_room_allocations`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_event_id` bigint UNSIGNED NOT NULL,
  `exam_room_id` bigint UNSIGNED NOT NULL,
  `seat_no` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `student_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_room_seat`(`exam_event_id` ASC, `exam_room_id` ASC, `seat_no` ASC) USING BTREE,
  INDEX `exam_room_id`(`exam_room_id` ASC) USING BTREE,
  INDEX `idx_era_event`(`exam_event_id` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_rooms
-- ----------------------------
DROP TABLE IF EXISTS `exam_rooms`;
CREATE TABLE `exam_rooms`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `capacity` int UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_exam_room`(`campus_id` ASC, `code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_sections
-- ----------------------------
DROP TABLE IF EXISTS `exam_sections`;
CREATE TABLE `exam_sections`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `version_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `section_type` enum('listening','reading','writing','speaking','mixed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'mixed',
  `time_limit_minutes` int UNSIGNED NULL DEFAULT NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  `instructions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_exam_sections_order`(`version_id` ASC, `order_index` ASC) USING BTREE,
  INDEX `idx_exam_sections_ver`(`version_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_timer_events
-- ----------------------------
DROP TABLE IF EXISTS `exam_timer_events`;
CREATE TABLE `exam_timer_events`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `attempt_id` bigint UNSIGNED NOT NULL,
  `event` enum('start','pause','resume','submit','extend') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `delta_seconds` int NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_ete_attempt`(`attempt_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_uploads
-- ----------------------------
DROP TABLE IF EXISTS `exam_uploads`;
CREATE TABLE `exam_uploads`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `attempt_id` bigint UNSIGNED NOT NULL,
  `exam_item_id` bigint UNSIGNED NULL DEFAULT NULL,
  `document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `mime_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `file_size` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `exam_item_id`(`exam_item_id` ASC) USING BTREE,
  INDEX `idx_eu_attempt`(`attempt_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_versions
-- ----------------------------
DROP TABLE IF EXISTS `exam_versions`;
CREATE TABLE `exam_versions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `blueprint_id` bigint UNSIGNED NOT NULL,
  `version_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` enum('draft','approved','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_latest` tinyint(1) NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_exam_version`(`blueprint_id` ASC, `version_no` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_exam_ver_bp`(`blueprint_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for external_calendars
-- ----------------------------
DROP TABLE IF EXISTS `external_calendars`;
CREATE TABLE `external_calendars`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `provider` enum('google','microsoft','zoom','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `external_account_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `token_json` json NULL,
  `expires_at` datetime NULL DEFAULT NULL,
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ec_provider`(`provider` ASC) USING BTREE,
  INDEX `idx_ec_user`(`user_id` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for external_game_mappings
-- ----------------------------
DROP TABLE IF EXISTS `external_game_mappings`;
CREATE TABLE `external_game_mappings`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `game_id` bigint UNSIGNED NOT NULL,
  `provider_id` bigint UNSIGNED NOT NULL,
  `external_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `metadata` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_egm`(`game_id` ASC, `provider_id` ASC) USING BTREE,
  INDEX `provider_id`(`provider_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_attachments
-- ----------------------------
DROP TABLE IF EXISTS `game_attachments`;
CREATE TABLE `game_attachments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `game_id` bigint UNSIGNED NOT NULL,
  `document_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_gatt_game`(`game_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_attempts
-- ----------------------------
DROP TABLE IF EXISTS `game_attempts`;
CREATE TABLE `game_attempts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `game_session_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `team_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `score` decimal(10, 2) NULL DEFAULT NULL,
  `duration_seconds` int UNSIGNED NULL DEFAULT NULL,
  `details` json NULL,
  `started_at` datetime NULL DEFAULT NULL,
  `ended_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ga_session`(`game_session_id` ASC) USING BTREE,
  INDEX `idx_ga_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_collection_items
-- ----------------------------
DROP TABLE IF EXISTS `game_collection_items`;
CREATE TABLE `game_collection_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `collection_id` bigint UNSIGNED NOT NULL,
  `game_id` bigint UNSIGNED NOT NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_gci_unique`(`collection_id` ASC, `game_id` ASC) USING BTREE,
  INDEX `game_id`(`game_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_collections
-- ----------------------------
DROP TABLE IF EXISTS `game_collections`;
CREATE TABLE `game_collections`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `owner_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `visibility` enum('private','tenant','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'private',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `owner_user_id`(`owner_user_id` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_permissions
-- ----------------------------
DROP TABLE IF EXISTS `game_permissions`;
CREATE TABLE `game_permissions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `game_id` bigint UNSIGNED NOT NULL,
  `subject_type` enum('user','role','org_unit') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_id` bigint UNSIGNED NOT NULL,
  `permission` enum('view','edit','assign','delete') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'view',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_gp_game`(`game_id` ASC) USING BTREE,
  INDEX `idx_gp_subject`(`subject_type` ASC, `subject_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_providers
-- ----------------------------
DROP TABLE IF EXISTS `game_providers`;
CREATE TABLE `game_providers`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `provider` enum('kahoot','quizizz','blooket','custom','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `credentials` json NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_gp_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_scores
-- ----------------------------
DROP TABLE IF EXISTS `game_scores`;
CREATE TABLE `game_scores`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `game_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `best_score` decimal(10, 2) NULL DEFAULT NULL,
  `attempts_count` int UNSIGNED NULL DEFAULT 0,
  `last_attempt_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_gs_game_class_user`(`game_id` ASC, `class_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_sessions
-- ----------------------------
DROP TABLE IF EXISTS `game_sessions`;
CREATE TABLE `game_sessions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `game_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `class_session_id` bigint UNSIGNED NULL DEFAULT NULL,
  `host_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `status` enum('scheduled','active','ended','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'scheduled',
  `started_at` datetime NULL DEFAULT NULL,
  `ended_at` datetime NULL DEFAULT NULL,
  `configuration` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `class_session_id`(`class_session_id` ASC) USING BTREE,
  INDEX `host_user_id`(`host_user_id` ASC) USING BTREE,
  INDEX `idx_gs_game`(`game_id` ASC) USING BTREE,
  INDEX `idx_gs_status`(`status` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_tags
-- ----------------------------
DROP TABLE IF EXISTS `game_tags`;
CREATE TABLE `game_tags`  (
  `game_id` bigint UNSIGNED NOT NULL,
  `tag_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`game_id`, `tag_id`) USING BTREE,
  INDEX `tag_id`(`tag_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for games
-- ----------------------------
DROP TABLE IF EXISTS `games`;
CREATE TABLE `games`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `skill` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `duration_minutes` int NOT NULL DEFAULT 0,
  `players` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `plays_count` int NOT NULL DEFAULT 0,
  `rating` decimal(3, 1) NOT NULL DEFAULT 0.0,
  `api_integration` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `tags` json NULL,
  `difficulty` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `visibility` enum('public','private') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `owner_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `objectives` json NULL,
  `rubric` json NULL,
  `attachments` json NULL,
  `game_type` enum('flashcard','kahoot_style','crossword','word_search','role_play','listening_challenge','vocabulary_quiz','grammar_battle','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `configuration` json NULL,
  `external_api_config` json NULL,
  `leaderboard_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `version_number` int NOT NULL DEFAULT 1,
  `parent_id` bigint UNSIGNED NULL DEFAULT NULL,
  `is_latest` tinyint(1) NOT NULL DEFAULT 1,
  `version_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `updated_by` bigint UNSIGNED NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `games_created_by_fkey`(`created_by` ASC) USING BTREE,
  INDEX `games_deleted_at_idx`(`deleted_at` ASC) USING BTREE,
  INDEX `games_owner_user_id_idx`(`owner_user_id` ASC) USING BTREE,
  INDEX `games_tenant_id_level_idx`(`tenant_id` ASC, `level` ASC) USING BTREE,
  INDEX `games_tenant_id_skill_idx`(`tenant_id` ASC, `skill` ASC) USING BTREE,
  INDEX `games_tenant_id_type_idx`(`tenant_id` ASC, `type` ASC) USING BTREE,
  INDEX `games_updated_by_fkey`(`updated_by` ASC) USING BTREE,
  INDEX `games_visibility_idx`(`visibility` ASC) USING BTREE,
  INDEX `idx_games_difficulty`(`tenant_id` ASC, `difficulty` ASC) USING BTREE,
  INDEX `idx_games_owner`(`tenant_id` ASC, `owner_user_id` ASC) USING BTREE,
  INDEX `idx_games_visibility`(`tenant_id` ASC, `visibility` ASC) USING BTREE,
  CONSTRAINT `fk_games_owner` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for gateway_events
-- ----------------------------
DROP TABLE IF EXISTS `gateway_events`;
CREATE TABLE `gateway_events`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `gateway` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `payload` json NULL,
  `received_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `processed_at` timestamp NULL DEFAULT NULL,
  `status` enum('pending','processed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ge_received`(`received_at` ASC) USING BTREE,
  INDEX `idx_ge_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for geo_zones
-- ----------------------------
DROP TABLE IF EXISTS `geo_zones`;
CREATE TABLE `geo_zones`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `center_lat` decimal(9, 6) NOT NULL,
  `center_lng` decimal(9, 6) NOT NULL,
  `radius_meters` int UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for grade_adjustments
-- ----------------------------
DROP TABLE IF EXISTS `grade_adjustments`;
CREATE TABLE `grade_adjustments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `component` enum('classroom','group','individual','progress','final') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `source` enum('quest_bonus','attendance_bonus','manual','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `percent_bonus` decimal(6, 2) NULL DEFAULT NULL,
  `points_bonus` decimal(8, 2) NULL DEFAULT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `applied_by` bigint UNSIGNED NULL DEFAULT NULL,
  `applied_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `applied_by`(`applied_by` ASC) USING BTREE,
  INDEX `idx_ga_student`(`class_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for grade_items
-- ----------------------------
DROP TABLE IF EXISTS `grade_items`;
CREATE TABLE `grade_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `source_type` enum('assignment','assessment','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_id` bigint UNSIGNED NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_score` decimal(8, 2) NOT NULL DEFAULT 100.00,
  `weight` decimal(6, 3) NOT NULL DEFAULT 1.000,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_gi_class`(`class_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for grade_summary
-- ----------------------------
DROP TABLE IF EXISTS `grade_summary`;
CREATE TABLE `grade_summary`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `average_score` decimal(8, 2) NULL DEFAULT NULL,
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_grade_summary`(`class_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for gradebook_entries
-- ----------------------------
DROP TABLE IF EXISTS `gradebook_entries`;
CREATE TABLE `gradebook_entries`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `grade_item_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `score` decimal(8, 2) NULL DEFAULT NULL,
  `graded_at` timestamp NULL DEFAULT NULL,
  `graded_by` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_grade_entry`(`grade_item_id` ASC, `student_user_id` ASC) USING BTREE,
  INDEX `graded_by`(`graded_by` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for grading_assignments
-- ----------------------------
DROP TABLE IF EXISTS `grading_assignments`;
CREATE TABLE `grading_assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_attempt_id` bigint UNSIGNED NOT NULL,
  `grader_user_id` bigint UNSIGNED NOT NULL,
  `role` enum('primary','secondary','moderator') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'primary',
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_grading_assign`(`exam_attempt_id` ASC, `grader_user_id` ASC, `role` ASC) USING BTREE,
  INDEX `grader_user_id`(`grader_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for grading_components
-- ----------------------------
DROP TABLE IF EXISTS `grading_components`;
CREATE TABLE `grading_components`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `policy_id` bigint UNSIGNED NOT NULL,
  `component` enum('classroom','group','individual','progress','final') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight` decimal(6, 3) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_gc_component`(`policy_id` ASC, `component` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for grading_marks
-- ----------------------------
DROP TABLE IF EXISTS `grading_marks`;
CREATE TABLE `grading_marks`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `attempt_item_id` bigint UNSIGNED NOT NULL,
  `rubric_criterion_id` bigint UNSIGNED NULL DEFAULT NULL,
  `score` decimal(8, 2) NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `grader_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `grader_user_id`(`grader_user_id` ASC) USING BTREE,
  INDEX `idx_gm_attempt_item`(`attempt_item_id` ASC) USING BTREE,
  INDEX `rubric_criterion_id`(`rubric_criterion_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for grading_resolutions
-- ----------------------------
DROP TABLE IF EXISTS `grading_resolutions`;
CREATE TABLE `grading_resolutions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_attempt_id` bigint UNSIGNED NOT NULL,
  `resolved_by` bigint UNSIGNED NULL DEFAULT NULL,
  `final_score` decimal(8, 2) NULL DEFAULT NULL,
  `resolution_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `resolved_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exam_attempt_id`(`exam_attempt_id` ASC) USING BTREE,
  INDEX `resolved_by`(`resolved_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for group_memberships
-- ----------------------------
DROP TABLE IF EXISTS `group_memberships`;
CREATE TABLE `group_memberships`  (
  `student_group_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `role` enum('member','leader') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'member',
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_group_id`, `student_user_id`) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for guardians
-- ----------------------------
DROP TABLE IF EXISTS `guardians`;
CREATE TABLE `guardians`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `relation` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_guardians_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for import_jobs
-- ----------------------------
DROP TABLE IF EXISTS `import_jobs`;
CREATE TABLE `import_jobs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `job_type` enum('students','enrollments','grades','sessions','users','assignments','documents','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `source` enum('csv','xlsx','api','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'csv',
  `status` enum('queued','running','completed','failed','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `file_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `started_at` datetime NULL DEFAULT NULL,
  `finished_at` datetime NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_ij_status`(`status` ASC) USING BTREE,
  INDEX `idx_ij_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for import_results
-- ----------------------------
DROP TABLE IF EXISTS `import_results`;
CREATE TABLE `import_results`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `job_id` bigint UNSIGNED NOT NULL,
  `row_no` int UNSIGNED NULL DEFAULT NULL,
  `status` enum('success','warning','error') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `entity_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `entity_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ir_job`(`job_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ingestion_items
-- ----------------------------
DROP TABLE IF EXISTS `ingestion_items`;
CREATE TABLE `ingestion_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `job_id` bigint UNSIGNED NOT NULL,
  `source_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` enum('queued','processing','created','failed','skipped') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_ing_items_job`(`job_id` ASC) USING BTREE,
  INDEX `idx_ing_items_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ingestion_jobs
-- ----------------------------
DROP TABLE IF EXISTS `ingestion_jobs`;
CREATE TABLE `ingestion_jobs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `source_id` bigint UNSIGNED NULL DEFAULT NULL,
  `status` enum('queued','running','completed','failed','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `started_at` datetime NULL DEFAULT NULL,
  `finished_at` datetime NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_ing_jobs_status`(`status` ASC) USING BTREE,
  INDEX `idx_ing_jobs_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `source_id`(`source_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ingestion_sources
-- ----------------------------
DROP TABLE IF EXISTS `ingestion_sources`;
CREATE TABLE `ingestion_sources`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` enum('upload','camera','url','gdrive','onedrive','dropbox','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'upload',
  `credentials` json NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ing_src`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for invoice_items
-- ----------------------------
DROP TABLE IF EXISTS `invoice_items`;
CREATE TABLE `invoice_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint UNSIGNED NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int UNSIGNED NOT NULL DEFAULT 1,
  `unit_price_cents` bigint UNSIGNED NOT NULL,
  `amount_cents` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_invoice_items_invoice`(`invoice_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for invoices
-- ----------------------------
DROP TABLE IF EXISTS `invoices`;
CREATE TABLE `invoices`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `subscription_id` bigint UNSIGNED NULL DEFAULT NULL,
  `invoice_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount_due_cents` bigint UNSIGNED NOT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `status` enum('draft','open','paid','void','uncollectible') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `issued_at` timestamp NULL DEFAULT NULL,
  `due_at` timestamp NULL DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `metadata` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_invoice_number`(`invoice_number` ASC) USING BTREE,
  INDEX `idx_invoices_status`(`status` ASC) USING BTREE,
  INDEX `idx_invoices_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `subscription_id`(`subscription_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kct_deployments
-- ----------------------------
DROP TABLE IF EXISTS `kct_deployments`;
CREATE TABLE `kct_deployments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `mapping_id` bigint UNSIGNED NOT NULL,
  `deployment_status` enum('planned','deploying','deployed','failed','rolled_back') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planned',
  `deployed_at` timestamp NULL DEFAULT NULL,
  `deployed_by_id` bigint UNSIGNED NULL DEFAULT NULL,
  `rollback_at` timestamp NULL DEFAULT NULL,
  `rollback_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `metadata` json NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `kct_deployments_deployed_by_id_fkey`(`deployed_by_id` ASC) USING BTREE,
  INDEX `kct_deployments_mapping_id_fkey`(`mapping_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kct_mappings
-- ----------------------------
DROP TABLE IF EXISTS `kct_mappings`;
CREATE TABLE `kct_mappings`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `framework_id` bigint UNSIGNED NOT NULL,
  `version_id` bigint UNSIGNED NOT NULL,
  `target_type` enum('course_template','class_instance') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_id` bigint UNSIGNED NOT NULL,
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `rollout_batch` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `rollout_phase` enum('planned','pilot','phased','full') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planned',
  `mismatch_report` json NULL,
  `risk_assessment` enum('low','medium','high','critical') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'low',
  `override_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` enum('planned','validated','applied','failed','rolled_back') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planned',
  `applied_at` timestamp NULL DEFAULT NULL,
  `rolled_back_at` timestamp NULL DEFAULT NULL,
  `rollback_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `kct_mappings_campus_id_fkey`(`campus_id` ASC) USING BTREE,
  INDEX `kct_mappings_created_by_fkey`(`created_by` ASC) USING BTREE,
  INDEX `kct_mappings_framework_id_version_id_idx`(`framework_id` ASC, `version_id` ASC) USING BTREE,
  INDEX `kct_mappings_risk_assessment_idx`(`risk_assessment` ASC) USING BTREE,
  INDEX `kct_mappings_rollout_batch_rollout_phase_idx`(`rollout_batch` ASC, `rollout_phase` ASC) USING BTREE,
  INDEX `kct_mappings_status_idx`(`status` ASC) USING BTREE,
  INDEX `kct_mappings_target_type_target_id_idx`(`target_type` ASC, `target_id` ASC) USING BTREE,
  INDEX `kct_mappings_version_id_fkey`(`version_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kct_usage_tracking
-- ----------------------------
DROP TABLE IF EXISTS `kct_usage_tracking`;
CREATE TABLE `kct_usage_tracking`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `framework_id` bigint UNSIGNED NOT NULL,
  `version_id` bigint UNSIGNED NOT NULL,
  `target_type` enum('course','class') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_id` bigint UNSIGNED NOT NULL,
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `action` enum('view','edit','export','apply','teach') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration_seconds` int UNSIGNED NULL DEFAULT NULL,
  `completion_percentage` tinyint UNSIGNED NULL DEFAULT NULL,
  `metadata` json NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `kct_usage_tracking_campus_id_fkey`(`campus_id` ASC) USING BTREE,
  INDEX `kct_usage_tracking_framework_id_created_at_idx`(`framework_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `kct_usage_tracking_target_type_target_id_idx`(`target_type` ASC, `target_id` ASC) USING BTREE,
  INDEX `kct_usage_tracking_tenant_id_fkey`(`tenant_id` ASC) USING BTREE,
  INDEX `kct_usage_tracking_user_id_action_idx`(`user_id` ASC, `action` ASC) USING BTREE,
  INDEX `kct_usage_tracking_version_id_fkey`(`version_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for lead_sources
-- ----------------------------
DROP TABLE IF EXISTS `lead_sources`;
CREATE TABLE `lead_sources`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_lead_sources_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for leaderboard_entries
-- ----------------------------
DROP TABLE IF EXISTS `leaderboard_entries`;
CREATE TABLE `leaderboard_entries`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `leaderboard_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `score` decimal(10, 2) NOT NULL,
  `rank_position` int UNSIGNED NULL DEFAULT NULL,
  `recorded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_lb_entry`(`leaderboard_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for leaderboards
-- ----------------------------
DROP TABLE IF EXISTS `leaderboards`;
CREATE TABLE `leaderboards`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `scope_type` enum('class','tenant','global') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'class',
  `scope_id` bigint UNSIGNED NULL DEFAULT NULL,
  `game_id` bigint UNSIGNED NULL DEFAULT NULL,
  `period` enum('all_time','monthly','weekly','daily') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all_time',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_lb_game`(`game_id` ASC) USING BTREE,
  INDEX `idx_lb_scope`(`scope_type` ASC, `scope_id` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for leads
-- ----------------------------
DROP TABLE IF EXISTS `leads`;
CREATE TABLE `leads`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `source_id` bigint UNSIGNED NULL DEFAULT NULL,
  `status` enum('new','contacted','qualified','unqualified','converted','lost') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'new',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `assigned_to` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `assigned_to`(`assigned_to` ASC) USING BTREE,
  INDEX `idx_leads_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE,
  INDEX `source_id`(`source_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for learning_outcomes_tracking
-- ----------------------------
DROP TABLE IF EXISTS `learning_outcomes_tracking`;
CREATE TABLE `learning_outcomes_tracking`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `framework_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NOT NULL,
  `student_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_id` bigint UNSIGNED NULL DEFAULT NULL,
  `assessment_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` decimal(5, 2) NULL DEFAULT NULL,
  `max_score` decimal(5, 2) NOT NULL DEFAULT 100.00,
  `grade` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `skills_assessed` json NULL,
  `feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `metadata` json NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `learning_outcomes_tracking_assessment_type_idx`(`assessment_type` ASC) USING BTREE,
  INDEX `learning_outcomes_tracking_class_id_student_id_idx`(`class_id` ASC, `student_id` ASC) USING BTREE,
  INDEX `learning_outcomes_tracking_completed_at_idx`(`completed_at` ASC) USING BTREE,
  INDEX `learning_outcomes_tracking_framework_id_fkey`(`framework_id` ASC) USING BTREE,
  INDEX `learning_outcomes_tracking_tenant_id_fkey`(`tenant_id` ASC) USING BTREE,
  INDEX `learning_outcomes_tracking_unit_id_idx`(`unit_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for learning_progress
-- ----------------------------
DROP TABLE IF EXISTS `learning_progress`;
CREATE TABLE `learning_progress`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `unit_id` bigint UNSIGNED NULL DEFAULT NULL,
  `progress_percent` decimal(5, 2) NOT NULL DEFAULT 0.00,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `idx_lp_student_class`(`student_user_id` ASC, `class_id` ASC) USING BTREE,
  INDEX `unit_id`(`unit_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for level_grading_policies
-- ----------------------------
DROP TABLE IF EXISTS `level_grading_policies`;
CREATE TABLE `level_grading_policies`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `passing_grade` decimal(6, 2) NOT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_lgp`(`tenant_id` ASC, `level` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for level_skill_minima
-- ----------------------------
DROP TABLE IF EXISTS `level_skill_minima`;
CREATE TABLE `level_skill_minima`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `policy_id` bigint UNSIGNED NOT NULL,
  `skill` enum('listening','speaking','reading','writing') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_score` decimal(6, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_lsm`(`policy_id` ASC, `skill` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for meeting_attendance_logs
-- ----------------------------
DROP TABLE IF EXISTS `meeting_attendance_logs`;
CREATE TABLE `meeting_attendance_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `meeting_integration_id` bigint UNSIGNED NOT NULL,
  `participant_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `participant_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `join_time` datetime NULL DEFAULT NULL,
  `leave_time` datetime NULL DEFAULT NULL,
  `duration_seconds` int UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_mal_meeting`(`meeting_integration_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for meeting_integrations
-- ----------------------------
DROP TABLE IF EXISTS `meeting_integrations`;
CREATE TABLE `meeting_integrations`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `provider` enum('zoom','meet','teams','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `meeting_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `join_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `start_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `host_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meeting_session`(`class_session_id` ASC, `provider` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for notification_templates
-- ----------------------------
DROP TABLE IF EXISTS `notification_templates`;
CREATE TABLE `notification_templates`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel` enum('email','sms','push','in_app') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'in_app',
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `content_json` json NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_nt_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for observation_scores
-- ----------------------------
DROP TABLE IF EXISTS `observation_scores`;
CREATE TABLE `observation_scores`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `observation_id` bigint UNSIGNED NOT NULL,
  `rubric_criterion_id` bigint UNSIGNED NOT NULL,
  `score` decimal(6, 2) NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_os_obs`(`observation_id` ASC) USING BTREE,
  INDEX `rubric_criterion_id`(`rubric_criterion_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for org_units
-- ----------------------------
DROP TABLE IF EXISTS `org_units`;
CREATE TABLE `org_units`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED NULL DEFAULT NULL,
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kind` enum('faculty','department','program','team','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `org_units_tenant_id_code_key`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `org_units_campus_id_fkey`(`campus_id` ASC) USING BTREE,
  INDEX `org_units_parent_id_fkey`(`parent_id` ASC) USING BTREE,
  INDEX `org_units_tenant_id_idx`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for overtime_requests
-- ----------------------------
DROP TABLE IF EXISTS `overtime_requests`;
CREATE TABLE `overtime_requests`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `hours` decimal(6, 2) NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` enum('pending','approved','rejected','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `decided_at` datetime NULL DEFAULT NULL,
  `decided_by` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `decided_by`(`decided_by` ASC) USING BTREE,
  INDEX `idx_otr_status`(`status` ASC) USING BTREE,
  INDEX `idx_otr_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for payment_methods
-- ----------------------------
DROP TABLE IF EXISTS `payment_methods`;
CREATE TABLE `payment_methods`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `kind` enum('card','bank_transfer','cash','e_wallet','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `external_ref` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `last4` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `brand` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_default` tinyint(1) NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_payment_methods_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for payment_transactions
-- ----------------------------
DROP TABLE IF EXISTS `payment_transactions`;
CREATE TABLE `payment_transactions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `payment_id` bigint UNSIGNED NOT NULL,
  `gateway` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `external_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `event` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `payload` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pt_payment`(`payment_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for payments
-- ----------------------------
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `invoice_id` bigint UNSIGNED NULL DEFAULT NULL,
  `payment_method_id` bigint UNSIGNED NULL DEFAULT NULL,
  `amount_cents` bigint UNSIGNED NOT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `status` enum('pending','succeeded','failed','refunded','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `paid_at` timestamp NULL DEFAULT NULL,
  `failure_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_payments_status`(`status` ASC) USING BTREE,
  INDEX `idx_payments_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `invoice_id`(`invoice_id` ASC) USING BTREE,
  INDEX `payment_method_id`(`payment_method_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `permissions_code_key`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plagiarism_checks
-- ----------------------------
DROP TABLE IF EXISTS `plagiarism_checks`;
CREATE TABLE `plagiarism_checks`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `attempt_item_id` bigint UNSIGNED NOT NULL,
  `provider` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` enum('queued','processing','complete','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `similarity_percent` decimal(5, 2) NULL DEFAULT NULL,
  `report_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `result_json` json NULL,
  `checked_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pc_attempt_item`(`attempt_item_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for point_anomalies
-- ----------------------------
DROP TABLE IF EXISTS `point_anomalies`;
CREATE TABLE `point_anomalies`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `point_type_id` bigint UNSIGNED NULL DEFAULT NULL,
  `detected_on` date NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `details` json NULL,
  `status` enum('open','reviewed','dismissed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pan_status`(`status` ASC) USING BTREE,
  INDEX `idx_pan_user_date`(`user_id` ASC, `detected_on` ASC) USING BTREE,
  INDEX `point_type_id`(`point_type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for point_balances
-- ----------------------------
DROP TABLE IF EXISTS `point_balances`;
CREATE TABLE `point_balances`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `point_type_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `balance` bigint NOT NULL DEFAULT 0,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pb_user_type_class`(`user_id` ASC, `point_type_id` ASC, `class_id` ASC) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `idx_pb_user`(`user_id` ASC) USING BTREE,
  INDEX `point_type_id`(`point_type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for point_ledgers
-- ----------------------------
DROP TABLE IF EXISTS `point_ledgers`;
CREATE TABLE `point_ledgers`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `point_type_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `rule_id` bigint UNSIGNED NULL DEFAULT NULL,
  `delta` int NOT NULL,
  `source_type` enum('attendance','assignment','game','exam','quest','manual','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `source_id` bigint UNSIGNED NULL DEFAULT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_pl_source`(`source_type` ASC, `source_id` ASC) USING BTREE,
  INDEX `idx_pl_user_time`(`user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `point_type_id`(`point_type_id` ASC) USING BTREE,
  INDEX `rule_id`(`rule_id` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for point_limits
-- ----------------------------
DROP TABLE IF EXISTS `point_limits`;
CREATE TABLE `point_limits`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `point_type_id` bigint UNSIGNED NULL DEFAULT NULL,
  `rule_id` bigint UNSIGNED NULL DEFAULT NULL,
  `period` enum('day','week','month','ever') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_points` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_plim_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `point_type_id`(`point_type_id` ASC) USING BTREE,
  INDEX `rule_id`(`rule_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for point_review_queue
-- ----------------------------
DROP TABLE IF EXISTS `point_review_queue`;
CREATE TABLE `point_review_queue`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `anomaly_id` bigint UNSIGNED NOT NULL,
  `reviewer_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `decision` enum('approve','reject','escalate') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `decided_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_prq_anomaly`(`anomaly_id` ASC) USING BTREE,
  INDEX `reviewer_user_id`(`reviewer_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for point_rules
-- ----------------------------
DROP TABLE IF EXISTS `point_rules`;
CREATE TABLE `point_rules`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `point_type_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `trigger_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `conditions` json NULL,
  `points_delta` int NOT NULL,
  `per_event_limit` int UNSIGNED NULL DEFAULT NULL,
  `daily_user_limit` int UNSIGNED NULL DEFAULT NULL,
  `weekly_user_limit` int UNSIGNED NULL DEFAULT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pr_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_pr_trigger`(`trigger_code` ASC) USING BTREE,
  INDEX `point_type_id`(`point_type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for point_types
-- ----------------------------
DROP TABLE IF EXISTS `point_types`;
CREATE TABLE `point_types`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pt_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for post_attachments
-- ----------------------------
DROP TABLE IF EXISTS `post_attachments`;
CREATE TABLE `post_attachments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `post_id` bigint UNSIGNED NOT NULL,
  `document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_pa_post`(`post_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for post_reactions
-- ----------------------------
DROP TABLE IF EXISTS `post_reactions`;
CREATE TABLE `post_reactions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `post_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `reaction` enum('like','love','insightful','question','thanks') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'like',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_post_user_reaction`(`post_id` ASC, `user_id` ASC, `reaction` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for posts
-- ----------------------------
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `author_user_id` bigint UNSIGNED NOT NULL,
  `visibility` enum('tenant','class','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'class',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pinned` tinyint(1) NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_user_id`(`author_user_id` ASC) USING BTREE,
  INDEX `idx_posts_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_posts_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for proctor_assignments
-- ----------------------------
DROP TABLE IF EXISTS `proctor_assignments`;
CREATE TABLE `proctor_assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_event_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role` enum('proctor','invigilator','assistant') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'proctor',
  `starts_at` datetime NULL DEFAULT NULL,
  `ends_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_proctor_assign`(`exam_event_id` ASC, `user_id` ASC, `role` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for proctoring_events
-- ----------------------------
DROP TABLE IF EXISTS `proctoring_events`;
CREATE TABLE `proctoring_events`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `proctoring_session_id` bigint UNSIGNED NOT NULL,
  `event_type` enum('tab_switch','no_face','multiple_faces','noise','suspicious_object','network','window_blur','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `severity` enum('low','medium','high') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'low',
  `details` json NULL,
  `occurred_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pe_occurred`(`occurred_at` ASC) USING BTREE,
  INDEX `idx_pe_session`(`proctoring_session_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for proctoring_sessions
-- ----------------------------
DROP TABLE IF EXISTS `proctoring_sessions`;
CREATE TABLE `proctoring_sessions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_attempt_id` bigint UNSIGNED NOT NULL,
  `proctor_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `provider` enum('internal','zoom','third_party') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'internal',
  `status` enum('active','ended','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `started_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `ended_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ps_attempt`(`exam_attempt_id` ASC) USING BTREE,
  INDEX `proctor_user_id`(`proctor_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for proctoring_snapshots
-- ----------------------------
DROP TABLE IF EXISTS `proctoring_snapshots`;
CREATE TABLE `proctoring_snapshots`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `proctoring_session_id` bigint UNSIGNED NOT NULL,
  `image_document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `thumbnail_document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `captured_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_psn_session`(`proctoring_session_id` ASC) USING BTREE,
  INDEX `image_document_id`(`image_document_id` ASC) USING BTREE,
  INDEX `thumbnail_document_id`(`thumbnail_document_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for program_definitions
-- ----------------------------
DROP TABLE IF EXISTS `program_definitions`;
CREATE TABLE `program_definitions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `program_definitions_tenant_id_code_key`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `program_definitions_tenant_id_idx`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for program_owners
-- ----------------------------
DROP TABLE IF EXISTS `program_owners`;
CREATE TABLE `program_owners`  (
  `program_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`program_id`, `user_id`) USING BTREE,
  INDEX `program_owners_user_id_fkey`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for provider_accounts
-- ----------------------------
DROP TABLE IF EXISTS `provider_accounts`;
CREATE TABLE `provider_accounts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `provider_id` bigint UNSIGNED NOT NULL,
  `account_identifier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `token_json` json NULL,
  `refreshed_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pa_user_provider`(`user_id` ASC, `provider_id` ASC) USING BTREE,
  INDEX `provider_id`(`provider_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for punctuality_metrics
-- ----------------------------
DROP TABLE IF EXISTS `punctuality_metrics`;
CREATE TABLE `punctuality_metrics`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `class_session_id` bigint UNSIGNED NULL DEFAULT NULL,
  `on_time_rate` decimal(6, 3) NULL DEFAULT NULL,
  `late_rate` decimal(6, 3) NULL DEFAULT NULL,
  `absent_rate` decimal(6, 3) NULL DEFAULT NULL,
  `calculated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pm_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_pm_session`(`class_session_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qa_messages
-- ----------------------------
DROP TABLE IF EXISTS `qa_messages`;
CREATE TABLE `qa_messages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `thread_id` bigint UNSIGNED NOT NULL,
  `author_user_id` bigint UNSIGNED NOT NULL,
  `parent_message_id` bigint UNSIGNED NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_user_id`(`author_user_id` ASC) USING BTREE,
  INDEX `idx_qam_thread`(`thread_id` ASC) USING BTREE,
  INDEX `parent_message_id`(`parent_message_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qa_threads
-- ----------------------------
DROP TABLE IF EXISTS `qa_threads`;
CREATE TABLE `qa_threads`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_qat_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qr_tokens
-- ----------------------------
DROP TABLE IF EXISTS `qr_tokens`;
CREATE TABLE `qr_tokens`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `issued_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `issued_by` bigint UNSIGNED NULL DEFAULT NULL,
  `rotation_seconds` int UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_qr_session_token`(`class_session_id` ASC, `token` ASC) USING BTREE,
  INDEX `idx_qr_exp`(`expires_at` ASC) USING BTREE,
  INDEX `idx_qr_session`(`class_session_id` ASC) USING BTREE,
  INDEX `issued_by`(`issued_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for quest_assignments
-- ----------------------------
DROP TABLE IF EXISTS `quest_assignments`;
CREATE TABLE `quest_assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `quest_id` bigint UNSIGNED NOT NULL,
  `subject_type` enum('user','class') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_id` bigint UNSIGNED NOT NULL,
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_qa_unique`(`quest_id` ASC, `subject_type` ASC, `subject_id` ASC) USING BTREE,
  INDEX `idx_qa_subject`(`subject_type` ASC, `subject_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for quest_progress
-- ----------------------------
DROP TABLE IF EXISTS `quest_progress`;
CREATE TABLE `quest_progress`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `quest_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `progress_json` json NULL,
  `completed` tinyint(1) NULL DEFAULT 0,
  `completed_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_qp_user`(`quest_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for quest_rewards
-- ----------------------------
DROP TABLE IF EXISTS `quest_rewards`;
CREATE TABLE `quest_rewards`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `quest_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `reward_type` enum('points','badge','item','entitlement') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` json NULL,
  `awarded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_qr_user`(`user_id` ASC) USING BTREE,
  INDEX `quest_id`(`quest_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for quest_task_progress
-- ----------------------------
DROP TABLE IF EXISTS `quest_task_progress`;
CREATE TABLE `quest_task_progress`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `quest_id` bigint UNSIGNED NOT NULL,
  `task_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `status` enum('pending','in_progress','done') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_qtp_unique`(`quest_id` ASC, `task_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `task_id`(`task_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for quest_tasks
-- ----------------------------
DROP TABLE IF EXISTS `quest_tasks`;
CREATE TABLE `quest_tasks`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `quest_id` bigint UNSIGNED NOT NULL,
  `task_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `conditions` json NULL,
  `points` int NULL DEFAULT NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_qt_code`(`quest_id` ASC, `task_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for quests
-- ----------------------------
DROP TABLE IF EXISTS `quests`;
CREATE TABLE `quests`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quest_type` enum('daily','weekly','seasonal') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `starts_at` datetime NULL DEFAULT NULL,
  `ends_at` datetime NULL DEFAULT NULL,
  `reward_points` int NULL DEFAULT NULL,
  `reward_point_type_id` bigint UNSIGNED NULL DEFAULT NULL,
  `reward_badge_id` bigint UNSIGNED NULL DEFAULT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_quest_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `reward_badge_id`(`reward_badge_id` ASC) USING BTREE,
  INDEX `reward_point_type_id`(`reward_point_type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for recurrence_rules
-- ----------------------------
DROP TABLE IF EXISTS `recurrence_rules`;
CREATE TABLE `recurrence_rules`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `scope_type` enum('class','staff_shift','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'class',
  `scope_id` bigint UNSIGNED NOT NULL,
  `rrule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dtstart` datetime NOT NULL,
  `until` datetime NULL DEFAULT NULL,
  `timezone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_rr_scope`(`scope_type` ASC, `scope_id` ASC) USING BTREE,
  INDEX `idx_rr_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for refunds
-- ----------------------------
DROP TABLE IF EXISTS `refunds`;
CREATE TABLE `refunds`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `payment_id` bigint UNSIGNED NOT NULL,
  `amount_cents` bigint UNSIGNED NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` enum('pending','succeeded','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_refunds_payment`(`payment_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for reminder_jobs
-- ----------------------------
DROP TABLE IF EXISTS `reminder_jobs`;
CREATE TABLE `reminder_jobs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `policy_id` bigint UNSIGNED NULL DEFAULT NULL,
  `context_type` enum('class_session','exam_event','staff_shift') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `context_id` bigint UNSIGNED NOT NULL,
  `target_datetime` datetime NOT NULL,
  `status` enum('scheduled','sent','canceled','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'scheduled',
  `channel` enum('email','sms','push','in_app') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'in_app',
  `template_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sent_at` datetime NULL DEFAULT NULL,
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_rj_status`(`status` ASC) USING BTREE,
  INDEX `idx_rj_target`(`target_datetime` ASC) USING BTREE,
  INDEX `policy_id`(`policy_id` ASC) USING BTREE,
  INDEX `template_id`(`template_id` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for reminder_policies
-- ----------------------------
DROP TABLE IF EXISTS `reminder_policies`;
CREATE TABLE `reminder_policies`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `audience` enum('student','teacher','staff','class') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `context` enum('class_session','exam_event','staff_shift') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `offsets_json` json NOT NULL,
  `channels` json NULL,
  `quiet_hours` json NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_rp_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for reschedule_history
-- ----------------------------
DROP TABLE IF EXISTS `reschedule_history`;
CREATE TABLE `reschedule_history`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `old_starts_at` datetime NOT NULL,
  `old_ends_at` datetime NOT NULL,
  `new_starts_at` datetime NOT NULL,
  `new_ends_at` datetime NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `changed_by` bigint UNSIGNED NULL DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `changed_by`(`changed_by` ASC) USING BTREE,
  INDEX `idx_rh_session`(`class_session_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for reschedule_requests
-- ----------------------------
DROP TABLE IF EXISTS `reschedule_requests`;
CREATE TABLE `reschedule_requests`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_event_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `old_time` datetime NULL DEFAULT NULL,
  `new_time` datetime NULL DEFAULT NULL,
  `status` enum('pending','approved','rejected','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `decided_at` datetime NULL DEFAULT NULL,
  `decided_by` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `decided_by`(`decided_by` ASC) USING BTREE,
  INDEX `exam_event_id`(`exam_event_id` ASC) USING BTREE,
  INDEX `idx_sr_status`(`status` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for retake_requests
-- ----------------------------
DROP TABLE IF EXISTS `retake_requests`;
CREATE TABLE `retake_requests`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_event_id` bigint UNSIGNED NOT NULL,
  `student_user_id` bigint UNSIGNED NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` enum('pending','approved','rejected','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `decided_at` datetime NULL DEFAULT NULL,
  `decided_by` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `decided_by`(`decided_by` ASC) USING BTREE,
  INDEX `exam_event_id`(`exam_event_id` ASC) USING BTREE,
  INDEX `idx_rr_status`(`status` ASC) USING BTREE,
  INDEX `student_user_id`(`student_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for reward_entitlements
-- ----------------------------
DROP TABLE IF EXISTS `reward_entitlements`;
CREATE TABLE `reward_entitlements`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `redemption_id` bigint UNSIGNED NULL DEFAULT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `entitlement_type` enum('deadline_extension','retake_ticket','voucher','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` json NULL,
  `expires_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_re_user`(`user_id` ASC) USING BTREE,
  INDEX `redemption_id`(`redemption_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for reward_usage_logs
-- ----------------------------
DROP TABLE IF EXISTS `reward_usage_logs`;
CREATE TABLE `reward_usage_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `entitlement_id` bigint UNSIGNED NOT NULL,
  `used_by` bigint UNSIGNED NULL DEFAULT NULL,
  `context_type` enum('class','assignment','exam','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `context_id` bigint UNSIGNED NULL DEFAULT NULL,
  `used_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_rul_context`(`context_type` ASC, `context_id` ASC) USING BTREE,
  INDEX `idx_rul_ent`(`entitlement_id` ASC) USING BTREE,
  INDEX `used_by`(`used_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for role_permissions
-- ----------------------------
DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions`  (
  `role_id` bigint UNSIGNED NOT NULL,
  `permission_id` bigint UNSIGNED NOT NULL,
  `granted_by` bigint UNSIGNED NULL DEFAULT NULL,
  `granted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`, `permission_id`) USING BTREE,
  INDEX `role_permissions_granted_by_fkey`(`granted_by` ASC) USING BTREE,
  INDEX `role_permissions_permission_id_fkey`(`permission_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NULL DEFAULT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `roles_tenant_id_code_key`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `roles_tenant_id_idx`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for rubric_criteria
-- ----------------------------
DROP TABLE IF EXISTS `rubric_criteria`;
CREATE TABLE `rubric_criteria`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `rubric_id` bigint UNSIGNED NOT NULL,
  `criterion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `weight` decimal(6, 3) NULL DEFAULT 1.000,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_rc_rubric`(`rubric_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for rubric_scores
-- ----------------------------
DROP TABLE IF EXISTS `rubric_scores`;
CREATE TABLE `rubric_scores`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `rubric_criterion_id` bigint UNSIGNED NOT NULL,
  `submission_id` bigint UNSIGNED NULL DEFAULT NULL,
  `assessment_result_id` bigint UNSIGNED NULL DEFAULT NULL,
  `score` decimal(6, 2) NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_rs_res`(`assessment_result_id` ASC) USING BTREE,
  INDEX `idx_rs_sub`(`submission_id` ASC) USING BTREE,
  INDEX `rubric_criterion_id`(`rubric_criterion_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for rubrics
-- ----------------------------
DROP TABLE IF EXISTS `rubrics`;
CREATE TABLE `rubrics`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for saved_views
-- ----------------------------
DROP TABLE IF EXISTS `saved_views`;
CREATE TABLE `saved_views`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `owner_id` bigint UNSIGNED NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `view_type` enum('framework_list','unit_editor','reports') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_shared` tinyint(1) NOT NULL DEFAULT 0,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `filters` json NULL,
  `columns` json NULL,
  `sort_config` json NULL,
  `layout_config` json NULL,
  `usage_count` int UNSIGNED NOT NULL DEFAULT 0,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `saved_views_is_default_idx`(`is_default` ASC) USING BTREE,
  INDEX `saved_views_is_shared_idx`(`is_shared` ASC) USING BTREE,
  INDEX `saved_views_owner_id_view_type_idx`(`owner_id` ASC, `view_type` ASC) USING BTREE,
  INDEX `saved_views_tenant_id_fkey`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scheduled_notifications
-- ----------------------------
DROP TABLE IF EXISTS `scheduled_notifications`;
CREATE TABLE `scheduled_notifications`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `template_id` bigint UNSIGNED NOT NULL,
  `trigger_type` enum('class_session','assignment_due','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `trigger_ref_id` bigint UNSIGNED NULL DEFAULT NULL,
  `schedule_time` datetime NOT NULL,
  `params` json NULL,
  `status` enum('scheduled','sent','canceled','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'scheduled',
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_sn_schedule`(`schedule_time` ASC) USING BTREE,
  INDEX `idx_sn_status`(`status` ASC) USING BTREE,
  INDEX `template_id`(`template_id` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scorm_packages
-- ----------------------------
DROP TABLE IF EXISTS `scorm_packages`;
CREATE TABLE `scorm_packages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `manifest_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `package_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` enum('uploaded','processed','error') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'uploaded',
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for session_activities
-- ----------------------------
DROP TABLE IF EXISTS `session_activities`;
CREATE TABLE `session_activities`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_plan_id` bigint UNSIGNED NOT NULL,
  `activity_type` enum('warm_up','presentation','practice','production','assessment','homework','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'other',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `duration_minutes` int UNSIGNED NULL DEFAULT NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sa_plan_order`(`session_plan_id` ASC, `order_index` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for session_activity_groups
-- ----------------------------
DROP TABLE IF EXISTS `session_activity_groups`;
CREATE TABLE `session_activity_groups`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_activity_id` bigint UNSIGNED NOT NULL,
  `student_group_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sag`(`session_activity_id` ASC, `student_group_id` ASC) USING BTREE,
  INDEX `student_group_id`(`student_group_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for session_activity_instances
-- ----------------------------
DROP TABLE IF EXISTS `session_activity_instances`;
CREATE TABLE `session_activity_instances`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_activity_id` bigint UNSIGNED NOT NULL,
  `activity_template_id` bigint UNSIGNED NOT NULL,
  `configuration` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sai`(`session_activity_id` ASC, `activity_template_id` ASC) USING BTREE,
  INDEX `activity_template_id`(`activity_template_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for session_assignments
-- ----------------------------
DROP TABLE IF EXISTS `session_assignments`;
CREATE TABLE `session_assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `available_at` datetime NULL DEFAULT NULL,
  `due_at` datetime NULL DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sa_unique`(`class_session_id` ASC, `assignment_id` ASC) USING BTREE,
  INDEX `assignment_id`(`assignment_id` ASC) USING BTREE,
  INDEX `idx_sa_due`(`due_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for session_game_assignments
-- ----------------------------
DROP TABLE IF EXISTS `session_game_assignments`;
CREATE TABLE `session_game_assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `game_id` bigint UNSIGNED NOT NULL,
  `available_at` datetime NULL DEFAULT NULL,
  `due_at` datetime NULL DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sga_unique2`(`class_session_id` ASC, `game_id` ASC) USING BTREE,
  INDEX `game_id`(`game_id` ASC) USING BTREE,
  INDEX `idx_sga_due2`(`due_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for session_group_assignments
-- ----------------------------
DROP TABLE IF EXISTS `session_group_assignments`;
CREATE TABLE `session_group_assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `student_group_id` bigint UNSIGNED NOT NULL,
  `session_activity_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sga_unique`(`class_session_id` ASC, `student_group_id` ASC, `session_activity_id` ASC) USING BTREE,
  INDEX `idx_sga_session`(`class_session_id` ASC) USING BTREE,
  INDEX `session_activity_id`(`session_activity_id` ASC) USING BTREE,
  INDEX `student_group_id`(`student_group_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for session_materials
-- ----------------------------
DROP TABLE IF EXISTS `session_materials`;
CREATE TABLE `session_materials`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_plan_id` bigint UNSIGNED NOT NULL,
  `session_activity_id` bigint UNSIGNED NULL DEFAULT NULL,
  `document_id` bigint UNSIGNED NULL DEFAULT NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `document_id`(`document_id` ASC) USING BTREE,
  INDEX `idx_sm_plan`(`session_plan_id` ASC) USING BTREE,
  INDEX `session_activity_id`(`session_activity_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for session_plans
-- ----------------------------
DROP TABLE IF EXISTS `session_plans`;
CREATE TABLE `session_plans`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `objectives` json NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_session_plan`(`class_session_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for session_recurrences
-- ----------------------------
DROP TABLE IF EXISTS `session_recurrences`;
CREATE TABLE `session_recurrences`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `recurrence_rule_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `occurrence_start` datetime NOT NULL,
  `occurrence_end` datetime NOT NULL,
  `linked_session_id` bigint UNSIGNED NULL DEFAULT NULL,
  `status` enum('planned','instantiated','skipped') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planned',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sr_class_time`(`class_id` ASC, `occurrence_start` ASC) USING BTREE,
  INDEX `idx_sr_rule`(`recurrence_rule_id` ASC) USING BTREE,
  INDEX `linked_session_id`(`linked_session_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for settings
-- ----------------------------
DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings`  (
  `tenant_id` bigint UNSIGNED NOT NULL,
  `hours_tolerance` decimal(4, 2) NOT NULL DEFAULT 0.50,
  `draft_export_watermark` tinyint(1) NOT NULL DEFAULT 1,
  `required_skills_by_level` json NULL,
  `cefr_minima` json NULL,
  `max_draft_age_days` int NOT NULL DEFAULT 30,
  `require_qr_for_published_exports` tinyint(1) NOT NULL DEFAULT 1,
  `allow_override_with_justification` tinyint(1) NOT NULL DEFAULT 1,
  `default_campus_branding` json NULL,
  `ai_generation_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `auto_health_checks_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `webhook_endpoints` json NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tenant_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for speech_metrics
-- ----------------------------
DROP TABLE IF EXISTS `speech_metrics`;
CREATE TABLE `speech_metrics`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `attempt_item_id` bigint UNSIGNED NOT NULL,
  `provider` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `fluency` decimal(6, 2) NULL DEFAULT NULL,
  `pronunciation` decimal(6, 2) NULL DEFAULT NULL,
  `grammar` decimal(6, 2) NULL DEFAULT NULL,
  `words_per_minute` decimal(6, 2) NULL DEFAULT NULL,
  `filler_count` int UNSIGNED NULL DEFAULT NULL,
  `result_json` json NULL,
  `analyzed_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sm_attempt_item`(`attempt_item_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for staff_attendance
-- ----------------------------
DROP TABLE IF EXISTS `staff_attendance`;
CREATE TABLE `staff_attendance`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `shift_assignment_id` bigint UNSIGNED NULL DEFAULT NULL,
  `check_in_at` datetime NULL DEFAULT NULL,
  `check_out_at` datetime NULL DEFAULT NULL,
  `method` enum('qr','kiosk','gps','manual') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'kiosk',
  `geo_lat` decimal(9, 6) NULL DEFAULT NULL,
  `geo_lng` decimal(9, 6) NULL DEFAULT NULL,
  `status` enum('present','late','absent','excused') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sta_user`(`user_id` ASC) USING BTREE,
  INDEX `shift_assignment_id`(`shift_assignment_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for staff_devices
-- ----------------------------
DROP TABLE IF EXISTS `staff_devices`;
CREATE TABLE `staff_devices`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `device_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `last_seen_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sd_user_device`(`user_id` ASC, `device_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for staff_shift_assignments
-- ----------------------------
DROP TABLE IF EXISTS `staff_shift_assignments`;
CREATE TABLE `staff_shift_assignments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `staff_shift_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `valid_from` date NULL DEFAULT NULL,
  `valid_to` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_shift_user`(`staff_shift_id` ASC, `user_id` ASC, `valid_from` ASC, `valid_to` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for staff_shifts
-- ----------------------------
DROP TABLE IF EXISTS `staff_shifts`;
CREATE TABLE `staff_shifts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `starts_at` time NOT NULL,
  `ends_at` time NOT NULL,
  `recurrence` enum('none','daily','weekly','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'weekly',
  `weekday_mask` tinyint UNSIGNED NULL DEFAULT NULL,
  `timezone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_staff_shift`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `campus_id`(`campus_id` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for staff_timesheets
-- ----------------------------
DROP TABLE IF EXISTS `staff_timesheets`;
CREATE TABLE `staff_timesheets`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `shifts_count` int UNSIGNED NULL DEFAULT 0,
  `hours_worked` decimal(8, 2) NULL DEFAULT 0.00,
  `late_count` int UNSIGNED NULL DEFAULT 0,
  `absent_count` int UNSIGNED NULL DEFAULT 0,
  `approved_by` bigint UNSIGNED NULL DEFAULT NULL,
  `approved_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sts_period`(`user_id` ASC, `period_start` ASC, `period_end` ASC) USING BTREE,
  INDEX `approved_by`(`approved_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for store_items
-- ----------------------------
DROP TABLE IF EXISTS `store_items`;
CREATE TABLE `store_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `point_type_id` bigint UNSIGNED NOT NULL,
  `cost_points` int NOT NULL,
  `inventory_count` int UNSIGNED NULL DEFAULT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_store_item`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `point_type_id`(`point_type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for store_redemptions
-- ----------------------------
DROP TABLE IF EXISTS `store_redemptions`;
CREATE TABLE `store_redemptions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `item_id` bigint UNSIGNED NOT NULL,
  `points_spent` int NOT NULL,
  `status` enum('pending','approved','rejected','fulfilled','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `decided_at` datetime NULL DEFAULT NULL,
  `decided_by` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `decided_by`(`decided_by` ASC) USING BTREE,
  INDEX `idx_sr_status`(`status` ASC) USING BTREE,
  INDEX `idx_sr_user`(`user_id` ASC) USING BTREE,
  INDEX `item_id`(`item_id` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for streak_events
-- ----------------------------
DROP TABLE IF EXISTS `streak_events`;
CREATE TABLE `streak_events`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `streak_type` enum('daily','weekly','class') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'daily',
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `event_date` date NOT NULL,
  `action` enum('increment','break','mulligan') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `metadata` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `idx_se_user_date`(`user_id` ASC, `event_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for streaks
-- ----------------------------
DROP TABLE IF EXISTS `streaks`;
CREATE TABLE `streaks`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `streak_type` enum('daily','weekly','class') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'daily',
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `current_streak_days` int UNSIGNED NOT NULL DEFAULT 0,
  `best_streak_days` int UNSIGNED NOT NULL DEFAULT 0,
  `last_achieved_date` date NULL DEFAULT NULL,
  `mulligans_used` int UNSIGNED NULL DEFAULT 0,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_streak_user_type`(`user_id` ASC, `streak_type` ASC, `class_id` ASC) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for student_groups
-- ----------------------------
DROP TABLE IF EXISTS `student_groups`;
CREATE TABLE `student_groups`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_id` bigint UNSIGNED NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_name`(`class_id` ASC, `name` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_groups_class`(`class_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for student_guardians
-- ----------------------------
DROP TABLE IF EXISTS `student_guardians`;
CREATE TABLE `student_guardians`  (
  `student_user_id` bigint UNSIGNED NOT NULL,
  `guardian_id` bigint UNSIGNED NOT NULL,
  `is_primary` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`student_user_id`, `guardian_id`) USING BTREE,
  INDEX `guardian_id`(`guardian_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for student_portfolio_items
-- ----------------------------
DROP TABLE IF EXISTS `student_portfolio_items`;
CREATE TABLE `student_portfolio_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `item_type` enum('submission','certificate','badge','assessment','project','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_id` bigint UNSIGNED NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `metadata` json NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_spi_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_spi_type`(`item_type` ASC) USING BTREE,
  INDEX `idx_spi_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for student_profiles
-- ----------------------------
DROP TABLE IF EXISTS `student_profiles`;
CREATE TABLE `student_profiles`  (
  `user_id` bigint UNSIGNED NOT NULL,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `student_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `date_of_birth` date NULL DEFAULT NULL,
  `gender` enum('male','female','other','prefer_not_to_say') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `emergency_contact` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `uk_student_code_tenant`(`tenant_id` ASC, `student_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for submission_feedback
-- ----------------------------
DROP TABLE IF EXISTS `submission_feedback`;
CREATE TABLE `submission_feedback`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `submission_id` bigint UNSIGNED NOT NULL,
  `teacher_user_id` bigint UNSIGNED NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `rubric_scores` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sfb_submission`(`submission_id` ASC) USING BTREE,
  INDEX `teacher_user_id`(`teacher_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for submission_files
-- ----------------------------
DROP TABLE IF EXISTS `submission_files`;
CREATE TABLE `submission_files`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `submission_id` bigint UNSIGNED NOT NULL,
  `file_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `mime_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `file_size` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sf_submission`(`submission_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for subscriptions
-- ----------------------------
DROP TABLE IF EXISTS `subscriptions`;
CREATE TABLE `subscriptions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `plan_id` bigint UNSIGNED NOT NULL,
  `status` enum('trialing','active','past_due','canceled','unpaid') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `current_period_start` timestamp NULL DEFAULT NULL,
  `current_period_end` timestamp NULL DEFAULT NULL,
  `cancel_at` timestamp NULL DEFAULT NULL,
  `canceled_at` timestamp NULL DEFAULT NULL,
  `metadata` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_subscriptions_status`(`status` ASC) USING BTREE,
  INDEX `idx_subscriptions_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `plan_id`(`plan_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for substitution_requests
-- ----------------------------
DROP TABLE IF EXISTS `substitution_requests`;
CREATE TABLE `substitution_requests`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `requester_user_id` bigint UNSIGNED NOT NULL,
  `substitute_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` enum('pending','approved','rejected','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `decided_at` datetime NULL DEFAULT NULL,
  `decided_by` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_session_id`(`class_session_id` ASC) USING BTREE,
  INDEX `decided_by`(`decided_by` ASC) USING BTREE,
  INDEX `idx_sr_status`(`status` ASC) USING BTREE,
  INDEX `requester_user_id`(`requester_user_id` ASC) USING BTREE,
  INDEX `substitute_user_id`(`substitute_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for support_tickets
-- ----------------------------
DROP TABLE IF EXISTS `support_tickets`;
CREATE TABLE `support_tickets`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `assigned_to` bigint UNSIGNED NULL DEFAULT NULL,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` enum('open','in_progress','resolved','closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'open',
  `priority` enum('low','medium','high','urgent') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'medium',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `assigned_to`(`assigned_to` ASC) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_tickets_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for survey_answers
-- ----------------------------
DROP TABLE IF EXISTS `survey_answers`;
CREATE TABLE `survey_answers`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `response_id` bigint UNSIGNED NOT NULL,
  `question_id` bigint UNSIGNED NOT NULL,
  `answer_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `answer_number` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sa_response`(`response_id` ASC) USING BTREE,
  INDEX `question_id`(`question_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for survey_questions
-- ----------------------------
DROP TABLE IF EXISTS `survey_questions`;
CREATE TABLE `survey_questions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `survey_id` bigint UNSIGNED NOT NULL,
  `question_type` enum('text','number','single_choice','multiple_choice','scale') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` json NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sq_survey`(`survey_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for survey_responses
-- ----------------------------
DROP TABLE IF EXISTS `survey_responses`;
CREATE TABLE `survey_responses`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `survey_id` bigint UNSIGNED NOT NULL,
  `respondent_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `idx_sr_survey`(`survey_id` ASC) USING BTREE,
  INDEX `respondent_user_id`(`respondent_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for surveys
-- ----------------------------
DROP TABLE IF EXISTS `surveys`;
CREATE TABLE `surveys`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_type` enum('student','guardian','teacher','class','general') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'general',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_surveys_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tabEmployee
-- ----------------------------
DROP TABLE IF EXISTS `tabEmployee`;
CREATE TABLE `tabEmployee`  (
  `name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `creation` datetime(6) NULL DEFAULT NULL,
  `modified` datetime(6) NULL DEFAULT NULL,
  `modified_by` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `owner` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `docstatus` int NOT NULL DEFAULT 0,
  `idx` int NOT NULL DEFAULT 0,
  `employee` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `naming_series` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `first_name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `middle_name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `last_name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `employee_name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `gender` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `date_of_birth` date NULL DEFAULT NULL,
  `salutation` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `date_of_joining` date NULL DEFAULT NULL,
  `image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Active',
  `user_id` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `create_user_permission` int NOT NULL DEFAULT 1,
  `company` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `department` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `employee_number` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `designation` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `reports_to` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `branch` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `scheduled_confirmation_date` date NULL DEFAULT NULL,
  `final_confirmation_date` date NULL DEFAULT NULL,
  `contract_end_date` date NULL DEFAULT NULL,
  `notice_number_of_days` int NOT NULL DEFAULT 0,
  `date_of_retirement` date NULL DEFAULT NULL,
  `cell_number` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `personal_email` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `company_email` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `prefered_contact_email` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `prefered_email` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `unsubscribed` int NOT NULL DEFAULT 0,
  `current_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `current_accommodation_type` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `permanent_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `permanent_accommodation_type` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `person_to_be_contacted` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `emergency_phone_number` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `relation` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `attendance_device_id` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `holiday_list` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `ctc` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `salary_currency` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `salary_mode` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `bank_name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `bank_ac_no` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `iban` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `marital_status` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `family_background` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `blood_group` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `health_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `passport_number` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `valid_upto` date NULL DEFAULT NULL,
  `date_of_issue` date NULL DEFAULT NULL,
  `place_of_issue` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `bio` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `resignation_letter_date` date NULL DEFAULT NULL,
  `relieving_date` date NULL DEFAULT NULL,
  `held_on` date NULL DEFAULT NULL,
  `new_workplace` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `leave_encashed` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `encashment_date` date NULL DEFAULT NULL,
  `reason_for_leaving` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `lft` int NOT NULL DEFAULT 0,
  `rgt` int NOT NULL DEFAULT 0,
  `old_parent` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `_user_tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_assign` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_liked_by` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `employment_type` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `grade` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `job_applicant` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `default_shift` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `expense_approver` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `leave_approver` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `shift_request_approver` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `payroll_cost_center` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `health_insurance_provider` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `health_insurance_no` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`name`) USING BTREE,
  UNIQUE INDEX `attendance_device_id`(`attendance_device_id` ASC) USING BTREE,
  INDEX `status`(`status` ASC) USING BTREE,
  INDEX `designation`(`designation` ASC) USING BTREE,
  INDEX `modified`(`modified` ASC) USING BTREE,
  INDEX `lft_rgt_index`(`lft` ASC, `rgt` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tabItem
-- ----------------------------
DROP TABLE IF EXISTS `tabItem`;
CREATE TABLE `tabItem`  (
  `name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `creation` datetime(6) NULL DEFAULT NULL,
  `modified` datetime(6) NULL DEFAULT NULL,
  `modified_by` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `owner` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `docstatus` int NOT NULL DEFAULT 0,
  `idx` int NOT NULL DEFAULT 0,
  `naming_series` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `item_code` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `item_name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `item_group` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `stock_uom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `disabled` int NOT NULL DEFAULT 0,
  `allow_alternative_item` int NOT NULL DEFAULT 0,
  `is_stock_item` int NOT NULL DEFAULT 1,
  `has_variants` int NOT NULL DEFAULT 0,
  `include_item_in_manufacturing` int NOT NULL DEFAULT 1,
  `opening_stock` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `standard_rate` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `is_fixed_asset` int NOT NULL DEFAULT 0,
  `auto_create_assets` int NOT NULL DEFAULT 0,
  `is_grouped_asset` int NOT NULL DEFAULT 0,
  `asset_category` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `asset_naming_series` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `over_delivery_receipt_allowance` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `over_billing_allowance` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `brand` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `shelf_life_in_days` int NOT NULL DEFAULT 0,
  `end_of_life` date NULL DEFAULT '2099-12-31',
  `default_material_request_type` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Purchase',
  `valuation_method` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `warranty_period` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `weight_per_unit` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `allow_negative_stock` int NOT NULL DEFAULT 0,
  `has_batch_no` int NOT NULL DEFAULT 0,
  `create_new_batch` int NOT NULL DEFAULT 0,
  `batch_number_series` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `has_expiry_date` int NOT NULL DEFAULT 0,
  `retain_sample` int NOT NULL DEFAULT 0,
  `sample_quantity` int NOT NULL DEFAULT 0,
  `has_serial_no` int NOT NULL DEFAULT 0,
  `serial_no_series` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `variant_of` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `variant_based_on` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Item Attribute',
  `enable_deferred_expense` int NOT NULL DEFAULT 0,
  `no_of_months_exp` int NOT NULL DEFAULT 0,
  `enable_deferred_revenue` int NOT NULL DEFAULT 0,
  `no_of_months` int NOT NULL DEFAULT 0,
  `purchase_uom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `min_order_qty` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `safety_stock` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `is_purchase_item` int NOT NULL DEFAULT 1,
  `lead_time_days` int NOT NULL DEFAULT 0,
  `last_purchase_rate` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `is_customer_provided_item` int NOT NULL DEFAULT 0,
  `customer` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `delivered_by_supplier` int NOT NULL DEFAULT 0,
  `country_of_origin` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `customs_tariff_number` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sales_uom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `grant_commission` int NOT NULL DEFAULT 1,
  `is_sales_item` int NOT NULL DEFAULT 1,
  `max_discount` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `inspection_required_before_purchase` int NOT NULL DEFAULT 0,
  `quality_inspection_template` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `inspection_required_before_delivery` int NOT NULL DEFAULT 0,
  `is_sub_contracted_item` int NOT NULL DEFAULT 0,
  `default_bom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `customer_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `default_item_manufacturer` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `default_manufacturer_part_no` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `published_in_website` int NOT NULL DEFAULT 0,
  `total_projected_qty` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_assign` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_liked_by` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `first_check` tinyint(1) NULL DEFAULT 0 COMMENT 'Check lần 1',
  `second_check` tinyint(1) NULL DEFAULT 0 COMMENT 'Check lần 2',
  `checked_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Người check',
  `checked_at` datetime NULL DEFAULT NULL COMMENT 'Thời gian check',
  `check_result` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Kết quả check thông tin',
  `new_product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Tên sản phẩm mới',
  `new_unit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Đơn vị mới',
  `new_barcode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Barcode mới',
  `new_price` decimal(15, 2) NULL DEFAULT NULL COMMENT 'Giá mới',
  `stock` int NULL DEFAULT NULL COMMENT 'Tồn kho',
  `imageUrls` json NULL,
  `image_1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `image_2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `image_3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`name`) USING BTREE,
  UNIQUE INDEX `item_code`(`item_code` ASC) USING BTREE,
  INDEX `item_name`(`item_name` ASC) USING BTREE,
  INDEX `item_group`(`item_group` ASC) USING BTREE,
  INDEX `disabled`(`disabled` ASC) USING BTREE,
  INDEX `variant_of`(`variant_of` ASC) USING BTREE,
  INDEX `modified`(`modified` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tabItem_copy1
-- ----------------------------
DROP TABLE IF EXISTS `tabItem_copy1`;
CREATE TABLE `tabItem_copy1`  (
  `name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `creation` datetime(6) NULL DEFAULT NULL,
  `modified` datetime(6) NULL DEFAULT NULL,
  `modified_by` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `owner` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `docstatus` int NOT NULL DEFAULT 0,
  `idx` int NOT NULL DEFAULT 0,
  `naming_series` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `item_code` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `item_name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `item_group` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `stock_uom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `disabled` int NOT NULL DEFAULT 0,
  `allow_alternative_item` int NOT NULL DEFAULT 0,
  `is_stock_item` int NOT NULL DEFAULT 1,
  `has_variants` int NOT NULL DEFAULT 0,
  `include_item_in_manufacturing` int NOT NULL DEFAULT 1,
  `opening_stock` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `standard_rate` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `is_fixed_asset` int NOT NULL DEFAULT 0,
  `auto_create_assets` int NOT NULL DEFAULT 0,
  `is_grouped_asset` int NOT NULL DEFAULT 0,
  `asset_category` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `asset_naming_series` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `over_delivery_receipt_allowance` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `over_billing_allowance` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `brand` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `shelf_life_in_days` int NOT NULL DEFAULT 0,
  `end_of_life` date NULL DEFAULT '2099-12-31',
  `default_material_request_type` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Purchase',
  `valuation_method` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `warranty_period` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `weight_per_unit` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `allow_negative_stock` int NOT NULL DEFAULT 0,
  `has_batch_no` int NOT NULL DEFAULT 0,
  `create_new_batch` int NOT NULL DEFAULT 0,
  `batch_number_series` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `has_expiry_date` int NOT NULL DEFAULT 0,
  `retain_sample` int NOT NULL DEFAULT 0,
  `sample_quantity` int NOT NULL DEFAULT 0,
  `has_serial_no` int NOT NULL DEFAULT 0,
  `serial_no_series` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `variant_of` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `variant_based_on` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Item Attribute',
  `enable_deferred_expense` int NOT NULL DEFAULT 0,
  `no_of_months_exp` int NOT NULL DEFAULT 0,
  `enable_deferred_revenue` int NOT NULL DEFAULT 0,
  `no_of_months` int NOT NULL DEFAULT 0,
  `purchase_uom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `min_order_qty` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `safety_stock` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `is_purchase_item` int NOT NULL DEFAULT 1,
  `lead_time_days` int NOT NULL DEFAULT 0,
  `last_purchase_rate` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `is_customer_provided_item` int NOT NULL DEFAULT 0,
  `customer` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `delivered_by_supplier` int NOT NULL DEFAULT 0,
  `country_of_origin` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `customs_tariff_number` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sales_uom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `grant_commission` int NOT NULL DEFAULT 1,
  `is_sales_item` int NOT NULL DEFAULT 1,
  `max_discount` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `inspection_required_before_purchase` int NOT NULL DEFAULT 0,
  `quality_inspection_template` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `inspection_required_before_delivery` int NOT NULL DEFAULT 0,
  `is_sub_contracted_item` int NOT NULL DEFAULT 0,
  `default_bom` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `customer_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `default_item_manufacturer` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `default_manufacturer_part_no` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `published_in_website` int NOT NULL DEFAULT 0,
  `total_projected_qty` decimal(21, 9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_assign` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_liked_by` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `first_check` tinyint(1) NULL DEFAULT 0 COMMENT 'Check lần 1',
  `second_check` tinyint(1) NULL DEFAULT 0 COMMENT 'Check lần 2',
  `checked_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Người check',
  `checked_at` datetime NULL DEFAULT NULL COMMENT 'Thời gian check',
  `check_result` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Kết quả check thông tin',
  `new_product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Tên sản phẩm mới',
  `new_unit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Đơn vị mới',
  `new_barcode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Barcode mới',
  `new_price` decimal(15, 2) NULL DEFAULT NULL COMMENT 'Giá mới',
  `stock` int NULL DEFAULT NULL COMMENT 'Tồn kho',
  `imageUrls` json NULL,
  `image_1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `image_2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `image_3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`name`) USING BTREE,
  UNIQUE INDEX `item_code`(`item_code` ASC) USING BTREE,
  INDEX `item_name`(`item_name` ASC) USING BTREE,
  INDEX `item_group`(`item_group` ASC) USING BTREE,
  INDEX `disabled`(`disabled` ASC) USING BTREE,
  INDEX `variant_of`(`variant_of` ASC) USING BTREE,
  INDEX `modified`(`modified` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tabUOM
-- ----------------------------
DROP TABLE IF EXISTS `tabUOM`;
CREATE TABLE `tabUOM`  (
  `name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `creation` datetime(6) NULL DEFAULT NULL,
  `modified` datetime(6) NULL DEFAULT NULL,
  `modified_by` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `owner` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `docstatus` int NOT NULL DEFAULT 0,
  `idx` int NOT NULL DEFAULT 0,
  `enabled` int NOT NULL DEFAULT 1,
  `uom_name` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `must_be_whole_number` int NOT NULL DEFAULT 0,
  `_user_tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_assign` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `_liked_by` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`name`) USING BTREE,
  UNIQUE INDEX `uom_name`(`uom_name` ASC) USING BTREE,
  INDEX `modified`(`modified` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `color` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `usage_count` int UNSIGNED NOT NULL DEFAULT 0,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tags_tenant_id_name_key`(`tenant_id` ASC, `name` ASC) USING BTREE,
  INDEX `tags_category_idx`(`category` ASC) USING BTREE,
  INDEX `tags_created_by_fkey`(`created_by` ASC) USING BTREE,
  INDEX `tags_is_system_idx`(`is_system` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for teacher_attendance
-- ----------------------------
DROP TABLE IF EXISTS `teacher_attendance`;
CREATE TABLE `teacher_attendance`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_session_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role` enum('teacher','ta') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'teacher',
  `check_in_at` datetime NULL DEFAULT NULL,
  `check_out_at` datetime NULL DEFAULT NULL,
  `method` enum('qr','zoom','manual','device') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual',
  `status` enum('present','absent','late','excused') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ta_unique`(`class_session_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_ta_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for teacher_timesheets
-- ----------------------------
DROP TABLE IF EXISTS `teacher_timesheets`;
CREATE TABLE `teacher_timesheets`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `sessions_count` int UNSIGNED NULL DEFAULT 0,
  `hours_taught` decimal(8, 2) NULL DEFAULT 0.00,
  `late_count` int UNSIGNED NULL DEFAULT 0,
  `absent_count` int UNSIGNED NULL DEFAULT 0,
  `approved_by` bigint UNSIGNED NULL DEFAULT NULL,
  `approved_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tt_period`(`user_id` ASC, `period_start` ASC, `period_end` ASC) USING BTREE,
  INDEX `approved_by`(`approved_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tenants
-- ----------------------------
DROP TABLE IF EXISTS `tenants`;
CREATE TABLE `tenants`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `settings` json NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tenants_code_key`(`code` ASC) USING BTREE,
  INDEX `tenants_code_idx`(`code` ASC) USING BTREE,
  INDEX `tenants_is_active_idx`(`is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for time_off_requests
-- ----------------------------
DROP TABLE IF EXISTS `time_off_requests`;
CREATE TABLE `time_off_requests`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `leave_type` enum('annual','sick','unpaid','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'annual',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` enum('pending','approved','rejected','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `decided_at` datetime NULL DEFAULT NULL,
  `decided_by` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `decided_by`(`decided_by` ASC) USING BTREE,
  INDEX `idx_tor_status`(`status` ASC) USING BTREE,
  INDEX `idx_tor_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for unit_activity_links
-- ----------------------------
DROP TABLE IF EXISTS `unit_activity_links`;
CREATE TABLE `unit_activity_links`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `unit_blueprint_id` bigint UNSIGNED NOT NULL,
  `activity_template_id` bigint UNSIGNED NOT NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_unit_activity`(`unit_blueprint_id` ASC, `activity_template_id` ASC) USING BTREE,
  INDEX `activity_template_id`(`activity_template_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for unit_assignment_links
-- ----------------------------
DROP TABLE IF EXISTS `unit_assignment_links`;
CREATE TABLE `unit_assignment_links`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `unit_blueprint_id` bigint UNSIGNED NOT NULL,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_unit_assignment`(`unit_blueprint_id` ASC, `assignment_id` ASC) USING BTREE,
  INDEX `assignment_id`(`assignment_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for unit_blueprint_tags
-- ----------------------------
DROP TABLE IF EXISTS `unit_blueprint_tags`;
CREATE TABLE `unit_blueprint_tags`  (
  `unit_id` bigint UNSIGNED NOT NULL,
  `tag_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`unit_id`, `tag_id`) USING BTREE,
  INDEX `unit_blueprint_tags_tag_id_fkey`(`tag_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for unit_blueprints
-- ----------------------------
DROP TABLE IF EXISTS `unit_blueprints`;
CREATE TABLE `unit_blueprints`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_blueprint_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `objectives` json NULL,
  `skills` json NULL,
  `activities` json NULL,
  `rubric` json NULL,
  `homework` json NULL,
  `hours` int NOT NULL DEFAULT 0,
  `order_index` int NOT NULL DEFAULT 0,
  `completeness_score` tinyint NOT NULL DEFAULT 0,
  `difficulty_level` enum('beginner','intermediate','advanced') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'intermediate',
  `estimated_time` int UNSIGNED NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `ai_generated` tinyint(1) NOT NULL DEFAULT 0,
  `ai_confidence` decimal(3, 2) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `unit_blueprints_completeness_score_idx`(`completeness_score` ASC) USING BTREE,
  INDEX `unit_blueprints_course_blueprint_id_order_index_idx`(`course_blueprint_id` ASC, `order_index` ASC) USING BTREE,
  INDEX `unit_blueprints_created_by_fkey`(`created_by` ASC) USING BTREE,
  INDEX `unit_blueprints_deleted_at_idx`(`deleted_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for unit_game_links
-- ----------------------------
DROP TABLE IF EXISTS `unit_game_links`;
CREATE TABLE `unit_game_links`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `unit_blueprint_id` bigint UNSIGNED NOT NULL,
  `game_id` bigint UNSIGNED NOT NULL,
  `order_index` int UNSIGNED NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_unit_game`(`unit_blueprint_id` ASC, `game_id` ASC) USING BTREE,
  INDEX `game_id`(`game_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for unit_resources
-- ----------------------------
DROP TABLE IF EXISTS `unit_resources`;
CREATE TABLE `unit_resources`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `unit_id` bigint UNSIGNED NOT NULL,
  `kind` enum('pdf','slide','video','audio','link','doc','image','worksheet','interactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `file_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `file_size` bigint UNSIGNED NULL DEFAULT NULL,
  `mime_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `ocr_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `ai_tags` json NULL,
  `manual_tags` json NULL,
  `license_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `license_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `accessibility_features` json NULL,
  `health_status` enum('healthy','broken','expired','restricted','unknown') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `last_health_check` timestamp NULL DEFAULT NULL,
  `order_index` int NOT NULL DEFAULT 0,
  `is_required` tinyint(1) NOT NULL DEFAULT 0,
  `download_count` int UNSIGNED NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `unit_resources_created_by_fkey`(`created_by` ASC) USING BTREE,
  INDEX `unit_resources_deleted_at_idx`(`deleted_at` ASC) USING BTREE,
  INDEX `unit_resources_health_status_idx`(`health_status` ASC) USING BTREE,
  INDEX `unit_resources_is_required_idx`(`is_required` ASC) USING BTREE,
  INDEX `unit_resources_kind_idx`(`kind` ASC) USING BTREE,
  INDEX `unit_resources_unit_id_order_index_idx`(`unit_id` ASC, `order_index` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_badges
-- ----------------------------
DROP TABLE IF EXISTS `user_badges`;
CREATE TABLE `user_badges`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `badge_id` bigint UNSIGNED NOT NULL,
  `awarded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_badge`(`user_id` ASC, `badge_id` ASC) USING BTREE,
  INDEX `badge_id`(`badge_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_notifications
-- ----------------------------
DROP TABLE IF EXISTS `user_notifications`;
CREATE TABLE `user_notifications`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `template_id` bigint UNSIGNED NULL DEFAULT NULL,
  `channel` enum('email','sms','push','in_app') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'in_app',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `send_at` datetime NULL DEFAULT NULL,
  `read_at` datetime NULL DEFAULT NULL,
  `status` enum('queued','sent','failed','read') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `metadata` json NULL,
  `class_id` bigint UNSIGNED NULL DEFAULT NULL,
  `assignment_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `assignment_id`(`assignment_id` ASC) USING BTREE,
  INDEX `class_id`(`class_id` ASC) USING BTREE,
  INDEX `idx_un_send`(`send_at` ASC) USING BTREE,
  INDEX `idx_un_status`(`status` ASC) USING BTREE,
  INDEX `idx_un_user`(`user_id` ASC) USING BTREE,
  INDEX `template_id`(`template_id` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_org_units
-- ----------------------------
DROP TABLE IF EXISTS `user_org_units`;
CREATE TABLE `user_org_units`  (
  `user_id` bigint UNSIGNED NOT NULL,
  `org_unit_id` bigint UNSIGNED NOT NULL,
  `role_in_unit` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `org_unit_id`) USING BTREE,
  INDEX `user_org_units_org_unit_id_idx`(`org_unit_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `assigned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_roles_user_id_role_id_campus_id_key`(`user_id` ASC, `role_id` ASC, `campus_id` ASC) USING BTREE,
  INDEX `user_roles_campus_id_fkey`(`campus_id` ASC) USING BTREE,
  INDEX `user_roles_role_id_idx`(`role_id` ASC) USING BTREE,
  INDEX `user_roles_user_id_idx`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('super_admin','admin','bgh','program_owner','curriculum_designer','teacher','qa','viewer') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'teacher',
  `campus_id` bigint UNSIGNED NULL DEFAULT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `preferences` json NULL,
  `mfa_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `mfa_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_email_key`(`email` ASC) USING BTREE,
  INDEX `users_campus_id_fkey`(`campus_id` ASC) USING BTREE,
  INDEX `users_is_active_idx`(`is_active` ASC) USING BTREE,
  INDEX `users_role_idx`(`role` ASC) USING BTREE,
  INDEX `users_tenant_id_email_idx`(`tenant_id` ASC, `email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for xapi_statements
-- ----------------------------
DROP TABLE IF EXISTS `xapi_statements`;
CREATE TABLE `xapi_statements`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `actor` json NOT NULL,
  `verb` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `object` json NOT NULL,
  `result` json NULL,
  `context` json NULL,
  `timestamp` datetime NOT NULL,
  `stored_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_xapi_time`(`timestamp` ASC) USING BTREE,
  INDEX `tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
