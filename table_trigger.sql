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

CREATE TABLE `post` (
  `post_id` int unsigned NOT NULL AUTO_INCREMENT,
  `post_datetime` datetime NOT NULL,
  `post_content` varchar(1000) NOT NULL,
  `post_media` blob NOT NULL,
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

CREATE TABLE `personal_post` (
  `post_id` int unsigned NOT NULL,
  `post_privacy` varchar(7) NOT NULL COMMENT '"PUBLIC" or "PRIVATE"',
  PRIMARY KEY (`post_id`),
  CONSTRAINT `personal_post_id` 
    FOREIGN KEY (`post_id`) 
    REFERENCES `post` (`post_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

CREATE TABLE `topic` (
  `topic_id` int unsigned NOT NULL AUTO_INCREMENT,
  `topic_titile` varchar(20) NOT NULL,
  `follower_count` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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



--
--Add trigger for tables
--

DELIMITER $$
CREATE TRIGGER `comment_reply_AFTER_INSERT` 
AFTER INSERT ON `comment_reply` 
FOR EACH ROW 
BEGIN
	update post_comment set reply_count = reply_count + 1 where comment_id = new.comment_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `comment_reply_AFTER_DELETE` 
AFTER DELETE ON `comment_reply` 
FOR EACH ROW 
BEGIN
	update post_comment set reply_count = reply_count - 1 where comment_id = old.comment_id;
END $$
DELIMITER ;

DELIMITER ;;
CREATE TRIGGER `comment_user_reaction_AFTER_INSERT` 
AFTER INSERT ON `comment_user_reaction` 
FOR EACH ROW 
BEGIN
	update comment set react_count = react_count + 1 where comment_id = new.comment_id;
END ;;
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `comment_user_reaction_AFTER_DELETE` 
AFTER DELETE ON `comment_user_reaction` 
FOR EACH ROW 
BEGIN
	update comment set react_count = react_count - 1 where comment_id = old.comment_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `group_member_AFTER_INSERT` 
AFTER INSERT ON `group_member` 
FOR EACH ROW 
BEGIN
	update `group` set member_count = member_count + 1 where group_id = new.group_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `group_member_AFTER_DELETE` 
AFTER DELETE ON `group_member` 
FOR EACH ROW 
BEGIN
	update `group` set member_count = member_count - 1 where group_id = old.group_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `post_comment_AFTER_INSERT` 
AFTER INSERT ON `post_comment` 
FOR EACH ROW 
BEGIN
	update post set comment_count = comment_count + 1 where post_id = new.post_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `post_comment_AFTER_DELETE` 
AFTER DELETE ON `post_comment` 
FOR EACH ROW 
BEGIN
	update post set comment_count = comment_count - 1 where post_id = old.post_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `post_user_reaction_AFTER_INSERT` 
AFTER INSERT ON `post_user_reaction` 
FOR EACH ROW 
BEGIN
	update post set react_count = react_count + 1 where post_id = new.post_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `post_user_reaction_AFTER_DELETE` 
AFTER DELETE ON `post_user_reaction` 
FOR EACH ROW 
BEGIN
	update post set react_count = react_count - 1 where post_id = old.post_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `topic_follower_AFTER_INSERT` 
AFTER INSERT ON `topic_follower` 
FOR EACH ROW 
BEGIN
	update topic set follower_count = follower_count + 1 where topic_id = new.topic_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `topic_follower_AFTER_DELETE` 
AFTER DELETE ON `topic_follower` 
FOR EACH ROW 
BEGIN
	update topic set follower_count = follower_count - 1 where topic_id = old.topic_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `user_follower_AFTER_INSERT` 
AFTER INSERT ON `user_follower` 
FOR EACH ROW 
BEGIN
	update user set follower_count = follower_count + 1 where user_id = new.user_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `user_follower_AFTER_DELETE` 
AFTER DELETE ON `user_follower` 
FOR EACH ROW 
BEGIN
	update user set follower_count = follower_count - 1 where user_id = old.user_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `user_AFTER_DELETE` 
BEFORE DELETE ON `user`
FOR EACH ROW
BEGIN
  IF EXISTS(SELECT 1 FROM `group` WHERE manager_id = old.user_id) THEN -- Will only abort deletion for specified IDs
    SIGNAL SQLSTATE '45000' -- "unhandled user-defined exception"
      -- Here comes your custom error message that will be returned by MySQL
      SET MESSAGE_TEXT = 'CANNOT DELETE A GROUP MANAGER ACCOUNT!';
  END IF;
END $$
DELIMITER ;
