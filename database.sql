-- =====================================================
-- FunTech 社群網站資料庫初始化腳本
-- 檔名：database.sql
-- 用途：建立 web01 資料庫、資料表、預設管理員與測試資料
-- =====================================================

-- 建立資料庫（若考場要求可改為 web01_db）
CREATE DATABASE IF NOT EXISTS `web01` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `web01`;

-- -----------------------------------------------------
-- users：會員資料表
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '會員主鍵',
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '帳號（唯一）',
  `email` VARCHAR(100) NOT NULL UNIQUE COMMENT '信箱（唯一）',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '密碼雜湊（password_hash）',
  `avatar` VARCHAR(255) DEFAULT 'assets/default-avatar.png' COMMENT '頭像路徑',
  `bio` TEXT NULL COMMENT '個人簡介',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間'
) ENGINE=InnoDB COMMENT='會員資料';

-- -----------------------------------------------------
-- articles：文章資料表
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `articles` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '文章主鍵',
  `user_id` INT UNSIGNED NOT NULL COMMENT '作者ID',
  `title` VARCHAR(150) NOT NULL COMMENT '文章標題',
  `content` MEDIUMTEXT NOT NULL COMMENT '文章內容',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
  CONSTRAINT `fk_articles_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='文章資料';

-- -----------------------------------------------------
-- friends：好友關係表（雙向關係以單筆資料表示）
-- status: pending/accepted/rejected
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `friends` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '好友關係主鍵',
  `requester_id` INT UNSIGNED NOT NULL COMMENT '發送邀請者',
  `addressee_id` INT UNSIGNED NOT NULL COMMENT '接收邀請者',
  `status` ENUM('pending','accepted','rejected') NOT NULL DEFAULT 'pending' COMMENT '好友狀態',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
  CONSTRAINT `fk_friends_requester` FOREIGN KEY (`requester_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_friends_addressee` FOREIGN KEY (`addressee_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `uq_friends_pair` UNIQUE (`requester_id`,`addressee_id`)
) ENGINE=InnoDB COMMENT='好友關係';

-- -----------------------------------------------------
-- games：遊戲資料表
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `games` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '遊戲ID',
  `title` VARCHAR(100) NOT NULL COMMENT '遊戲名稱',
  `description` TEXT NULL COMMENT '遊戲介紹',
  `cover` VARCHAR(255) DEFAULT 'assets/default-game.jpg' COMMENT '封面圖路徑',
  `folder_path` VARCHAR(255) NOT NULL COMMENT '遊戲資料夾路徑，例如 games/1/',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間'
) ENGINE=InnoDB COMMENT='遊戲清單';

-- -----------------------------------------------------
-- notifications：首頁通知
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(150) NOT NULL,
  `content` TEXT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT='通知公告';

-- 預設管理員：admin / 1234（密碼以 bcrypt 雜湊存放）
INSERT INTO `users` (`username`,`email`,`password_hash`,`bio`)
VALUES ('admin','admin@funtech.local','$2y$10$0MSYMnRUfN3V7Q4l1aX0Hu7VksfYAgUN0fS8xDbK5lgh7H3U6H6f2','系統管理員')
ON DUPLICATE KEY UPDATE `email`=VALUES(`email`);

-- 測試會員
INSERT INTO `users` (`username`,`email`,`password_hash`,`bio`) VALUES
('alice','alice@funtech.local','$2y$10$0MSYMnRUfN3V7Q4l1aX0Hu7VksfYAgUN0fS8xDbK5lgh7H3U6H6f2','嗨，我是 Alice'),
('bob','bob@funtech.local','$2y$10$0MSYMnRUfN3V7Q4l1aX0Hu7VksfYAgUN0fS8xDbK5lgh7H3U6H6f2','嗨，我是 Bob')
ON DUPLICATE KEY UPDATE `email`=VALUES(`email`);

-- 測試文章
INSERT INTO `articles` (`user_id`,`title`,`content`) VALUES
(1,'歡迎來到 FunTech','這是 FunTech 社群網站的第一篇文章，歡迎大家加入！'),
(2,'Alice 的開發筆記','今天分享我在前端切版上的心得。'),
(3,'Bob 的遊戲心得','玩了新的小遊戲，超好玩！');

-- 測試通知
INSERT INTO `notifications` (`title`,`content`) VALUES
('網站上線公告','FunTech 社群網站正式上線。'),
('活動預告','本週末將舉辦線上遊戲挑戰賽。');

-- 測試遊戲
INSERT INTO `games` (`title`,`description`,`cover`,`folder_path`) VALUES
('反應力測驗','測試你的反應速度與手速！','assets/game1.jpg','games/1/'),
('記憶卡配對','挑戰最短時間完成配對。','assets/game2.jpg','games/2/');
