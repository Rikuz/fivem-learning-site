CREATE TABLE IF NOT EXISTS `ex08_messages` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `sender_identifier` VARCHAR(64) NOT NULL,
  `sender_name` VARCHAR(100) NOT NULL,
  `receiver_identifier` VARCHAR(64) NOT NULL,
  `body` TEXT NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);
