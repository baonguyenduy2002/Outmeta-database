CREATE DATABASE outmeta;

USE outmeta;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` varchar(25) NOT NULL,
  `password` varchar(16) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `dob` date NOT NULL,
  `phone_number` varchar(16) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `follower_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `comment_id` int unsigned NOT NULL AUTO_INCREMENT,
  `comment_content` varchar(200) NOT NULL,
  `comment_datetime` datetime NOT NULL,
  `react_count` int unsigned NOT NULL DEFAULT '0',
  `writer_id` varchar(25) NOT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `comment_writer_id_idx` (`writer_id`),
  CONSTRAINT `comment_writer_id` 
    FOREIGN KEY (`writer_id`) 
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `group`;
CREATE TABLE `group` (
  `group_id` int unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(50) NOT NULL,
  `group_description` varchar(200) DEFAULT NULL,
  `member_count` int unsigned NOT NULL DEFAULT '1',
  `manager_id` varchar(25) NOT NULL,
  PRIMARY KEY (`group_id`),
  KEY `manager_id_idx` (`manager_id`),
  CONSTRAINT `group_manager_id` 
    FOREIGN KEY (`manager_id`) 
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
  `post_id` int unsigned NOT NULL AUTO_INCREMENT,
  `post_datetime` datetime NOT NULL,
  `post_content` varchar(1000) DEFAULT NULL,
  `post_media` blob DEFAULT NULL,
  `comment_count` int unsigned NOT NULL DEFAULT '0',
  `react_count` int unsigned NOT NULL DEFAULT '0',
  `writer_id` varchar(25) NOT NULL,
  PRIMARY KEY (`post_id`),
  KEY `writer_id_idx` (`writer_id`),
  CONSTRAINT `post_writer_id` 
    FOREIGN KEY (`writer_id`) 
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `comment_reply`;
CREATE TABLE `comment_reply` (
  `reply_id` int unsigned NOT NULL,
  `comment_id` int unsigned NOT NULL,
  PRIMARY KEY (`reply_id`),
  KEY `reply_comment_id_idx` (`comment_id`),
  CONSTRAINT `comment_reply_id` 
    FOREIGN KEY (`reply_id`) 
    REFERENCES `comment` (`comment_id`)
    ON DELETE CASCADE,
  CONSTRAINT `reply_comment_id` 
    FOREIGN KEY (`comment_id`) 
    REFERENCES `comment` (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `comment_user_reaction`;
CREATE TABLE `comment_user_reaction` (
  `user_id` varchar(25) NOT NULL,
  `comment_id` int unsigned NOT NULL,
  `react_type` varchar(5) NOT NULL,
  PRIMARY KEY (`user_id`,`comment_id`),
  KEY `react_comment_id_idx` (`comment_id`),
  CONSTRAINT `react_comment_id` 
    FOREIGN KEY (`comment_id`) 
    REFERENCES `comment` (`comment_id`)
    ON DELETE CASCADE,
  CONSTRAINT `reactcomment_user_id` 
    FOREIGN KEY (`user_id`) 
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `group_member`;
CREATE TABLE `group_member` (
  `member_id` varchar(25) NOT NULL,
  `group_id` int unsigned NOT NULL,
  PRIMARY KEY (`member_id`,`group_id`),
  KEY `member_group_id_idx` (`group_id`),
  CONSTRAINT `group_member_id` 
    FOREIGN KEY (`member_id`) 
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE,
  CONSTRAINT `member_group_id` 
    FOREIGN KEY (`group_id`) 
    REFERENCES `group` (`group_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `group_post`;
CREATE TABLE `group_post` (
  `post_id` int unsigned NOT NULL,
  `group_id` int unsigned NOT NULL,
  PRIMARY KEY (`post_id`),
  KEY `group_id_idx` (`group_id`),
  CONSTRAINT `group_post_id` 
    FOREIGN KEY (`post_id`) 
    REFERENCES `post` (`post_id`)
    ON DELETE CASCADE,
  CONSTRAINT `post_group_id` 
    FOREIGN KEY (`group_id`) 
    REFERENCES `group` (`group_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `personal_post`;
CREATE TABLE `personal_post` (
  `post_id` int unsigned NOT NULL,
  `post_privacy` varchar(7) NOT NULL COMMENT '"PUBLIC" or "PRIVATE"',
  PRIMARY KEY (`post_id`),
  CONSTRAINT `personal_post_id` 
    FOREIGN KEY (`post_id`) 
    REFERENCES `post` (`post_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `post_comment`;
CREATE TABLE `post_comment` (
  `comment_id` int unsigned NOT NULL,
  `reply_count` int unsigned NOT NULL DEFAULT '0',
  `post_id` int unsigned NOT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `comment_post_id_idx` (`post_id`),
  CONSTRAINT `comment_post_id` 
    FOREIGN KEY (`post_id`) 
    REFERENCES `post` (`post_id`)
    ON DELETE CASCADE,
  CONSTRAINT `post_comment_id` 
    FOREIGN KEY (`comment_id`) 
    REFERENCES `comment` (`comment_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `post_user_reaction`;
CREATE TABLE `post_user_reaction` (
  `user_id` varchar(25) NOT NULL,
  `post_id` int unsigned NOT NULL,
  `react_type` varchar(5) NOT NULL,
  PRIMARY KEY (`user_id`,`post_id`),
  KEY `react_post_id_idx` (`post_id`),
  CONSTRAINT `react_post_id` 
    FOREIGN KEY (`post_id`) 
    REFERENCES `post` (`post_id`)
    ON DELETE CASCADE,
  CONSTRAINT `reactpost_user_id` 
    FOREIGN KEY (`user_id`) 
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic` (
  `topic_id` int unsigned NOT NULL AUTO_INCREMENT,
  `topic_title` varchar(20) NOT NULL,
  `follower_count` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `topic_follower`;
CREATE TABLE `topic_follower` (
  `follower_id` varchar(25) NOT NULL,
  `topic_id` int unsigned NOT NULL,
  PRIMARY KEY (`follower_id`,`topic_id`),
  KEY `follow_topic_id_idx` (`topic_id`),
  CONSTRAINT `follow_topic_id` 
    FOREIGN KEY (`topic_id`) 
    REFERENCES `topic` (`topic_id`)
    ON DELETE CASCADE,
  CONSTRAINT `topic_follower_id` 
    FOREIGN KEY (`follower_id`) 
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `topic_post`;
CREATE TABLE `topic_post` (
  `post_id` int unsigned NOT NULL,
  `topic_id` int unsigned NOT NULL,
  PRIMARY KEY (`post_id`),
  KEY `topic_id_idx` (`topic_id`),
  CONSTRAINT `post_topic_id` 
    FOREIGN KEY (`topic_id`) 
    REFERENCES `topic` (`topic_id`)
    ON DELETE CASCADE,
  CONSTRAINT `topic_post_id` 
    FOREIGN KEY (`post_id`) 
    REFERENCES `post` (`post_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `user_follower`;
CREATE TABLE `user_follower` (
  `user_id` varchar(25) NOT NULL,
  `follower_id` varchar(25) NOT NULL,
  PRIMARY KEY (`user_id`,`follower_id`),
  KEY `follower_id_idx` (`follower_id`),
  CONSTRAINT `follower_id` 
    FOREIGN KEY (`follower_id`) 
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE,
  CONSTRAINT `user_id` 
    FOREIGN KEY (`user_id`) 
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
