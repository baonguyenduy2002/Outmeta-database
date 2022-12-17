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




--
-- Add trigger for tables
--

-- Trigger increase reply_count by 1 in post_comment table whenever insert new rercord to comment_reply table
-- INPUT: AFTER INSERT ON `comment_reply`
-- OUTPUT: post_comment.reply_count = post_comment.reply_count + 1
DELIMITER $$
CREATE TRIGGER `comment_reply_AFTER_INSERT` 
AFTER INSERT ON `comment_reply` 
FOR EACH ROW 
BEGIN
	update post_comment set reply_count = reply_count + 1 where comment_id = new.reply_id;
END $$
DELIMITER ;


-- Trigger decrease reply_count by 1 in post_comment table whenever delete a rercord from comment_reply table
-- INPUT: AFTER DELETE ON `comment_reply`
-- OUTPUT: post_comment.reply_count = post_comment.reply_count - 1
DELIMITER $$
CREATE TRIGGER `comment_reply_AFTER_DELETE` 
AFTER DELETE ON `comment_reply` 
FOR EACH ROW 
BEGIN
	update post_comment set reply_count = reply_count - 1 where comment_id = old.reply_id;
END $$
DELIMITER ;


-- Trigger increase react_count by 1 in comment table whenever insert new rercord to comment_user_reaction table
-- INPUT: AFTER INSERT ON `comment_user_reaction`
-- OUTPUT: comment.react_count = comment.react_count + 1
DELIMITER ;;
CREATE TRIGGER `comment_user_reaction_AFTER_INSERT` 
AFTER INSERT ON `comment_user_reaction` 
FOR EACH ROW 
BEGIN
	update comment set react_count = react_count + 1 where comment_id = new.comment_id;
END ;;
DELIMITER ;


-- Trigger decrease react_count by 1 in comment table whenever delete a rercord from comment_user_reaction table
-- INPUT: AFTER DELETE ON `comment_user_reaction`
-- OUTPUT: comment.react_count = comment.react_count - 1
DELIMITER $$
CREATE TRIGGER `comment_user_reaction_AFTER_DELETE` 
AFTER DELETE ON `comment_user_reaction` 
FOR EACH ROW 
BEGIN
	update comment set react_count = react_count - 1 where comment_id = old.comment_id;
END $$
DELIMITER ;


-- Trigger increase member_count by 1 in group table whenever insert new rercord to group_member table
-- INPUT: AFTER INSERT ON `group_member`
-- OUTPUT: group.member_count = group.member_count + 1
DELIMITER $$
CREATE TRIGGER `group_member_AFTER_INSERT` 
AFTER INSERT ON `group_member` 
FOR EACH ROW 
BEGIN
	update `group` set member_count = member_count + 1 where group_id = new.group_id;
END $$
DELIMITER ;


-- Trigger decrease member_count by 1 in group table whenever delete a rercord from group_member table
-- INPUT: AFTER DELETE ON `group_member`
-- OUTPUT: group.member_count = group.member_count - 1
DELIMITER $$
CREATE TRIGGER `group_member_AFTER_DELETE` 
AFTER DELETE ON `group_member` 
FOR EACH ROW 
BEGIN
	update `group` set member_count = member_count - 1 where group_id = old.group_id;
END $$
DELIMITER ;


-- Trigger increase comment_count by 1 in post table whenever insert new rercord to post_comment table
-- INPUT: AFTER INSERT ON `post_comment`
-- OUTPUT: post.comment_count = post.comment_count + 1
DELIMITER $$
CREATE TRIGGER `post_comment_AFTER_INSERT` 
AFTER INSERT ON `post_comment` 
FOR EACH ROW 
BEGIN
	update post set comment_count = comment_count + 1 where post_id = new.post_id;
END $$
DELIMITER ;


-- Trigger update comment_count in post table whenever update a rercord in post_comment table
-- INPUT: AFTER UPDATE ON `post_comment`
-- OUTPUT: post.comment_count = post.comment_count + new.reply_count - old.reply_count
DELIMITER $$
CREATE TRIGGER `post_comment_AFTER_UPDATE` 
AFTER UPDATE ON `post_comment` 
FOR EACH ROW 
BEGIN
	update post set comment_count = comment_count + new.reply_count - old.reply_count where post_id = new.post_id;
END $$
DELIMITER ;


-- Trigger decrease comment_count by 1 in post table whenever delete a rercord from post_comment table
-- INPUT: AFTER DELETE ON `post_comment`
-- OUTPUT: post.comment_count = post.comment_count - 1
DELIMITER $$
CREATE TRIGGER `post_comment_AFTER_DELETE` 
AFTER DELETE ON `post_comment` 
FOR EACH ROW 
BEGIN
	update post set comment_count = comment_count - 1 where post_id = old.post_id;
END $$
DELIMITER ;


-- Trigger increase react_count by 1 in post table whenever insert a new rercord to post_user_reaction table
-- INPUT: AFTER INSERT ON `post_user_reaction`
-- OUTPUT: post.react_count = post.react_count + 1
DELIMITER $$
CREATE TRIGGER `post_user_reaction_AFTER_INSERT` 
AFTER INSERT ON `post_user_reaction` 
FOR EACH ROW 
BEGIN
	update post set react_count = react_count + 1 where post_id = new.post_id;
END $$
DELIMITER ;


-- Trigger decrease react_count by 1 in post table whenever delete a rercord from post_user_reaction table
-- INPUT: AFTER DELETE ON `post_user_reaction`
-- OUTPUT: post.react_count = post.react_count - 1
DELIMITER $$
CREATE TRIGGER `post_user_reaction_AFTER_DELETE` 
AFTER DELETE ON `post_user_reaction` 
FOR EACH ROW 
BEGIN
	update post set react_count = react_count - 1 where post_id = old.post_id;
END $$
DELIMITER ;


-- Trigger increase follower_count by 1 in topic table whenever insert a new rercord to topic_follower table
-- INPUT: AFTER INSERT ON `topic_follower`
-- OUTPUT: topic.follower_count = topic.follower_count + 1
DELIMITER $$
CREATE TRIGGER `topic_follower_AFTER_INSERT` 
AFTER INSERT ON `topic_follower` 
FOR EACH ROW 
BEGIN
	update topic set follower_count = follower_count + 1 where topic_id = new.topic_id;
END $$
DELIMITER ;


-- Trigger decrease follower_count by 1 in post table whenever delete a rercord from post_user_reaction table
-- INPUT: AFTER DELETE ON `post_user_reaction`
-- OUTPUT: post.follower_count = post.follower_count - 1
DELIMITER $$
CREATE TRIGGER `topic_follower_AFTER_DELETE` 
AFTER DELETE ON `topic_follower` 
FOR EACH ROW 
BEGIN
	update topic set follower_count = follower_count - 1 where topic_id = old.topic_id;
END $$
DELIMITER ;


-- Trigger increase follower_count by 1 in user table whenever insert a new rercord to user_follower table
-- INPUT: AFTER INSERT ON `user_follower`
-- OUTPUT: user.follower_count = user.follower_count + 1
DELIMITER $$
CREATE TRIGGER `user_follower_AFTER_INSERT` 
AFTER INSERT ON `user_follower` 
FOR EACH ROW 
BEGIN
	update user set follower_count = follower_count + 1 where user_id = new.follower_id;
END $$
DELIMITER ;


-- Trigger decrease follower_count by 1 in user table whenever delete a rercord from user_follower table
-- INPUT: AFTER DELETE ON `user_follower`
-- OUTPUT: user.follower_count = user.follower_count - 1
DELIMITER $$
CREATE TRIGGER `user_follower_AFTER_DELETE` 
AFTER DELETE ON `user_follower` 
FOR EACH ROW 
BEGIN
	update user set follower_count = follower_count - 1 where user_id = old.follower_id;
END $$
DELIMITER ;


-- Trigger check whether the user deleted is manager of any group
-- INPUT: BEFORE DELETE ON `user`
-- OUTPUT: error message if the user deleted is manager of (a) group(s)
DELIMITER $$
CREATE TRIGGER `user_BEFORE_DELETE` 
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



-- function to write a new post from a user
-- Input: add_post_content, add_post_media, add_writer_id
-- Output: TRUE
DROP function IF EXISTS `add_post`;
DELIMITER $$
CREATE FUNCTION `add_post`(add_post_content VARCHAR(1000), add_post_media BLOB, add_writer_id VARCHAR(25)) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	INSERT INTO post (post_datetime, post_content, post_media, writer_id)
    VALUES (current_timestamp(), add_post_content, add_post_media, add_writer_id);
RETURN TRUE;
END$$
DELIMITER ;

-- function to edit existing post
-- Input: edit_post_id, edit_post_content, edit_post_media
-- Output: TRUE if successfully edit post, FALSE if post is not found
DROP function IF EXISTS `edit_post`;
DELIMITER $$
CREATE FUNCTION `edit_post`(edit_post_id INT, edit_post_content VARCHAR(1000), edit_post_media BLOB) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	IF (SELECT COUNT(*) FROM post WHERE post.post_id = edit_post_id)
    THEN
		UPDATE post
        SET post_content = edit_post_content,
			post_media = edit_post_media
		WHERE 
			post_id = edit_post_id;
		RETURN TRUE;
    ELSE
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Post not found in post table';
		RETURN FALSE;
	END IF;
END$$
DELIMITER ;

-- function to change mangager of an existing group
-- Input: user_id, group_id
-- Output: TRUE IF successfully change manager of a group, FALSE if group not exist
DROP function IF EXISTS `change_manager`;
DELIMITER $$
CREATE FUNCTION `change_manager`(user_id varchar(25), group_id INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	IF (SELECT COUNT(*) FROM `group` WHERE `group`.group_id = group_id)
    THEN
		UPDATE `group`
		SET
			`group`.manager_id = user_id
		WHERE
			`group`.group_id = group_id;
		RETURN TRUE;
    ELSE
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Group not found in group table';
	END IF;
END$$
DELIMITER ;

-- function to add a new user
-- Input: new_user_id, new_password, new_description, new_name, new_address, new_dob, new_phoneno, new_email
-- Output: "SUCCESSFUL" IF successfully add a new user, "DUPLICATED" IF the user id is already exist
DROP function IF EXISTS `add_user`;
DELIMITER $$
CREATE FUNCTION `add_user`(
	new_user_id VARCHAR(25), 
	new_password VARCHAR(16), 
	new_description VARCHAR(200), 
	new_name VARCHAR(100), 
	new_address VARCHAR(100), 
	new_dob DATE, 
	new_phoneno VARCHAR(16), 
	new_email VARCHAR(50)
) 
RETURNS varchar(20) DETERMINISTIC
   
BEGIN
	IF(SELECT COUNT(*) FROM `user` WHERE `user`.user_id = new_user_id) /* finds if new_user_id is unique or not */
    THEN -- TRUE
		RETURN "DUPLICATED user_id";
	ELSE -- FALSE
		INSERT INTO `user` (user_id, password, description, name, address, dob, phone_number, email) 
        VALUES 
        (new_user_id, new_password, new_description, new_name, new_address, new_dob, new_phoneno, new_email);
        RETURN "SUCCESSFUL";
	END IF;
END$$
DELIMITER ;

-- function to change user info
-- Input: userid, new_password, new_description, new_name, new_address, new_dob, new_phoneno, new_email
-- Output: "DATA MODIFIED SUCCESSFULLY" IF successfully change the user info, "USER NOT FOUND" IF the user id is not found
DROP function IF EXISTS `change_user_info`;
DELIMITER $$
CREATE FUNCTION change_user_info ( -- modifies infomation of the given userid
	userid VARCHAR(25),
	new_password VARCHAR(16), 
	new_description VARCHAR(200), 
	new_name VARCHAR(100), 
	new_address VARCHAR(100), 
	new_dob DATE, 
	new_phoneno VARCHAR(16), 
	new_email VARCHAR(50)
)
RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
	IF (SELECT COUNT(*) FROM `user` where `user`.user_id = userid) /* finds userid exists in the database */
	THEN -- TRUE
	/* update password */
		UPDATE `user`
		SET `user`.password = new_password
		WHERE `user`.user_id = userid;
    
	/* update description */
		UPDATE `user`
		SET `user`.description = new_description
		WHERE `user`.user_id = userid;
    
	/* update name */
		UPDATE `user`
		SET `user`.name = new_name
		WHERE `user`.user_id = userid;
	
    /* update address */
		UPDATE `user`
		SET `user`.address = new_address
		WHERE `user`.user_id = userid;
        
	/* update dob */
		UPDATE `user`
		SET `user`.dob = new_dob
		WHERE `user`.user_id = userid;
        
	/* update phone_number */
		UPDATE `user`
		SET `user`.phone_number = new_phoneno
		WHERE `user`.user_id = userid;
        
	/* update email */
		UPDATE `user`
		SET `user`.email = new_email
		WHERE `user`.user_id = userid;
    
		RETURN "DATA MODIFIED SUCCESSFULLY";
	ELSE -- FALSE
		RETURN "USER NOT FOUND";
END IF;
END$$
DELIMITER ;

-- function for add topic_post
-- Input: topic_id, post_datetime, post_content, post_media, writer_ID
-- Output: none
DROP function IF EXISTS `add_post_topic`;
DELIMITER $$
CREATE FUNCTION `add_post_topic`(
	topic_id INT,
	post_datetime DATETIME,
	post_content VARCHAR(1000),
	post_media blob,
	writer_id VARCHAR(25)
) 
RETURNS INT DETERMINISTIC
   
BEGIN
	INSERT INTO `post` (post_datetime, post_content, post_media, writer_id) 
    VALUES 
    (post_datetime, post_content, post_media, writer_id);

	INSERT INTO `topic_post` (post_id, topic_id)
	VALUES(LAST_INSERT_ID(), topic_id);
    RETURN 1;
END$$
DELIMITER ;

-- function for add group_post
-- Input: group_id, post_datetime, post_content, post_media, writer_ID
-- Output: none
DROP function IF EXISTS `add_post_group`;
DELIMITER $$
CREATE FUNCTION `add_post_group`(
	group_id INT,
	post_datetime DATETIME,
	post_content VARCHAR(1000),
	post_media blob,
	writer_id VARCHAR(25)
) 
RETURNS INT DETERMINISTIC
   
BEGIN
	INSERT INTO `post` (post_datetime, post_content, post_media, writer_id) 
    VALUES 
    (post_datetime, post_content, post_media, writer_id);

	INSERT INTO `group_post` (post_id, group_id)
	VALUES(LAST_INSERT_ID(), group_id);
    RETURN 1;
END$$
DELIMITER ;

-- function for add personal_post
-- Input: post_privacy, post_datetime, post_content, post_media, writer_ID
-- Output: none
DROP function IF EXISTS `add_post_personal`;
DELIMITER $$
CREATE FUNCTION `add_post_personal`(
	post_privacy VARCHAR(7),
	post_datetime DATETIME,
	post_content VARCHAR(1000),
	post_media blob,
	writer_id VARCHAR(25)
) 
RETURNS INT DETERMINISTIC
   
BEGIN
	INSERT INTO `post` (post_datetime, post_content, post_media, writer_id) 
    VALUES 
    (post_datetime, post_content, post_media, writer_id);

	INSERT INTO `personal_post` (post_id, post_privacy)
	VALUES(LAST_INSERT_ID(), post_privacy);
    RETURN 1;
END$$
DELIMITER ;

-- function to add reply to another comment
-- Input: comment_content, comment_datetime, writer_id, comment_reply_id
-- Output: True if add successfully, else print 'Comment not found in command table' and return False
DROP function IF EXISTS `add_comment_reply`;
DELIMITER $$
CREATE FUNCTION `add_comment_reply`(comment_content VARCHAR(200), comment_datetime datetime, writer_id VARCHAR(25), comment_reply_id INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	IF (SELECT COUNT(*) FROM `comment` WHERE `comment`.comment_id = comment_reply_id)
    THEN
		INSERT INTO `comment` (comment_content, comment_datetime, writer_id)
		VALUES (comment_content, comment_datetime, writer_id);
		INSERT INTO `comment_reply`
		VALUES (LAST_INSERT_ID(), comment_reply_id);
		RETURN TRUE;
    ELSE
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Comment not found in command table';
		RETURN FALSE;
	END IF;
END$$
DELIMITER ;

-- function to add reply to a post
-- Input: comment_content, comment_datetime, writer_id, post_id
-- Output: True if add successfully, else print 'Post not found in post table' and return False
DROP function IF EXISTS `add_post_comment`;
DELIMITER $$
CREATE FUNCTION `add_post_comment`(comment_content VARCHAR(200), comment_datetime datetime, writer_id VARCHAR(25), post_id INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	IF (SELECT COUNT(*) FROM post WHERE post.post_id = post_id)
    THEN
		INSERT INTO `comment` (comment_content, comment_datetime, writer_id)
		VALUES (comment_content, comment_datetime, writer_id);
		INSERT INTO `post_comment` (comment_id, post_id)
		VALUES (LAST_INSERT_ID(), post_id);
		RETURN TRUE;
    ELSE
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Post not found in post table';
		RETURN FALSE;
	END IF;
END$$
DELIMITER ;

-- function to add manager as group member after create new group
-- Input: group_name, group_description, manager_id
-- Output: none

DROP function IF EXISTS `add_new_group`;
DELIMITER $$
CREATE FUNCTION `add_new_group`(
	group_name VARCHAR(50),
	group_description VARCHAR(200),
	manager_id VARCHAR(25)
) 
RETURNS INT DETERMINISTIC
BEGIN
	INSERT INTO `group` (group_name, group_description, manager_id) 
	VALUES 
	(group_name, group_description, manager_id);

	INSERT INTO `group_member` (member_id, group_id)
	VALUES (manager_id, LAST_INSERT_ID());

	RETURN 1;
END$$
DELIMITER ;




-- procedure for sort top 50 posts base on interaction point (react + comment)
-- Input: None
-- Output: top 50 posts in term of interaction_point (comment_count + react_count)
DROP PROCEDURE IF EXISTS sortTop50Post;
DELIMITER $$
CREATE PROCEDURE sortTop50Post()
BEGIN
    SELECT  *, comment_count + react_count AS interaction_point
    FROM    post
    ORDER BY interaction_point DESC
    LIMIT 50;
END $$
DELIMITER ;

-- procedure for sort top 50 group posts base on interaction point (react + comment)
-- Input: None
-- Output: top 50 group posts in term of interaction_point (comment_count + react_count)
DROP PROCEDURE IF EXISTS sortTop50GroupPost;
DELIMITER $$
CREATE PROCEDURE sortTop50GroupPost()
BEGIN
    SELECT  *, comment_count + react_count AS interaction_point
    FROM    post
    INNER JOIN group_post
    ON post.post_id = group_post.post_id
    ORDER BY interaction_point DESC
    LIMIT 50;
END $$
DELIMITER ;

-- procedure for sort top 50 topic posts base on interaction point (react + comment)
-- Input: None
-- Output: top 50 topic posts in term of interaction_point (comment_count + react_count)
DROP PROCEDURE IF EXISTS sortTop50TopicPost;
DELIMITER $$
CREATE PROCEDURE sortTop50TopicPost()
BEGIN
    SELECT  *, comment_count + react_count AS interaction_point
    FROM    post
    INNER JOIN topic_post
    ON post.post_id = topic_post.post_id
    ORDER BY interaction_point DESC
    LIMIT 50;
END $$
DELIMITER ;

-- procedure for sort top 50 personal posts base on interaction point (react + comment)
-- Input: None
-- Output: top 50 pesonal posts in term of interaction_point (comment_count + react_count)
DROP PROCEDURE IF EXISTS sortTop50PersonalPost;
DELIMITER $$
CREATE PROCEDURE sortTop50PersonalPost()
BEGIN
    SELECT  *, comment_count + react_count AS interaction_point
    FROM    post
    INNER JOIN personal_post
    ON post.post_id = personal_post.post_id AND personal_post.privacy = 'PUBLIC'
    ORDER BY interaction_point DESC
    LIMIT 50;
END $$
DELIMITER ;

-- procedure for sort top 50 followed topic
-- Input: None
-- Output: top 50 topic in term of followers
DROP PROCEDURE IF EXISTS sortTop50FollowedTopic;
DELIMITER $$
CREATE PROCEDURE sortTop50FollowedTopic()
BEGIN
    SELECT  *
    FROM    topic
    ORDER BY follower_count DESC
    LIMIT 50;
END $$
DELIMITER ;

-- procedure for sort top 50 group in term of member
-- Input: None
-- Output: top 50 group in term of members
DROP PROCEDURE IF EXISTS sortTop50MemberGroup;
DELIMITER $$
CREATE PROCEDURE sortTop50MemberGroup()
BEGIN
    SELECT  *
    FROM    `group`
    ORDER BY member_count DESC
    LIMIT 50;
END $$
DELIMITER ;

-- procedure for get a list of follower of a user
-- Input: user_id [VARCHAR(25)]
-- Output list of followers
DROP procedure IF EXISTS `get_follower`;
DELIMITER $$
CREATE PROCEDURE `get_follower`(user_id VARCHAR(25))
BEGIN
    SELECT 
        `user`.user_id,
        password,
        description,
        name,
        address,
        dob,
        phone_number,
        email,
        follower_count
    FROM `user` JOIN `user_follower`
    ON `user`.user_id = `user_follower`.follower_id

    WHERE `user_follower`.user_id = user_id;
END$$
DELIMITER ;

-- procedure for get a list of users that a user is following
-- Input: user_id [VARCHAR(25)]
-- Output list of users that a user is following
DROP procedure IF EXISTS `get_following`;
DELIMITER $$
CREATE PROCEDURE `get_following`(user_id VARCHAR(25))
BEGIN
    SELECT 
        `user`.user_id,
        password,
        description,
        name,
        address,
        dob,
        phone_number,
        email,
        follower_count
    FROM `user` JOIN `user_follower`
    ON `user`.user_id = `user_follower`.user_id

    WHERE `user_follower`.follower_id = user_id;
END$$
DELIMITER ;

-- procedure for get a list of topics that a user is following
-- Input: user_id [VARCHAR(25)]
-- Output list of topics that a user is following
DROP procedure IF EXISTS `get_topics`;
DELIMITER $$
CREATE PROCEDURE `get_topics`(user_id VARCHAR(25))
BEGIN
        SELECT 
		`topic_follower`.follower_id as user_id,
        `topic`.topic_id,
        `topic`.topic_title,
        `topic`.follower_count
    FROM outmeta.`topic` 
    JOIN `topic_follower`
    ON `topic`.topic_id = `topic_follower`.topic_id

    WHERE `topic_follower`.follower_id = user_id;
END$$
DELIMITER ;

-- procedure for get a list of groups that a user is a member of
-- Input: user_id [VARCHAR(25)]
-- Output list of groups that a user is a member of
DROP procedure IF EXISTS `view_group_user`;
DELIMITER $$
CREATE PROCEDURE `view_group_user`(user_id VARCHAR(25))
BEGIN
	SELECT *
    FROM `group`, group_member
    WHERE 	`group`.group_id = group_member.group_id AND
			group_member.member_id = user_id;
END$$
DELIMITER ;


-- procedure for get a list of posts in a group
-- Input: group_id [INT]
-- Output list of posts in a group
DROP PROCEDURE IF EXISTS `view_post_group`;
DELIMITER $$
CREATE PROCEDURE `view_post_group`(group_id INT)
BEGIN
	SELECT post.post_id, post_datetime, post_content, post_media, comment_count, react_count, writer_id
    FROM post, group_post
    WHERE 	post.post_id = group_post.post_id AND
			group_post.group_id = group_id;
END$$
DELIMITER ;

-- procedure for get a list of posts belongs to a topic
-- Input: topic_id [INT]
-- Output list of posts belongs to a topic
DROP PROCEDURE IF EXISTS `view_post_topic`;
DELIMITER $$
CREATE PROCEDURE `view_post_topic`(topic_id INT)
BEGIN
	SELECT post.post_id, post_datetime, post_content, post_media, comment_count, react_count, writer_id
    FROM post, topic_post
    WHERE 	post.post_id = topic_post.post_id AND
			topic_post.topic_id = topic_id;
END$$
DELIMITER ;

-- procedure for get a list of posts belongs to a user
-- Input: user_id [VARCHAR(25)]
-- Output list of posts belongs to a user
DROP procedure IF EXISTS `view_post_user`;
DELIMITER $$
CREATE PROCEDURE `view_post_user`(user_id VARCHAR(25))
BEGIN
	SELECT *
    FROM post
    WHERE writer_id = user_id;
END$$
DELIMITER ;

-- procedure for get a list of personal posts
-- Input: none
-- Output: lists of personal posts
DROP PROCEDURE IF EXISTS view_post_personal;
DELIMITER $$
CREATE PROCEDURE view_post_personal()
BEGIN
    SELECT
        post.post_id,
        post.post_datetime,
        personal_post.post_privacy,
        post.post_content,
        post.post_media,
        post.comment_count,
        post.react_count,
        post.writer_id
    FROM post, personal_post
    WHERE post.post_id = personal_post.post_id;
END$$
DELIMITER ;


/*        Insert user         */

INSERT INTO user (user_id, password, description, name, address, dob, phone_number, email) 
VALUES 
('alevis07232', 'SCERLQlGgAb8', '8% of 25 is the same as 25% of 8 and one of them is much easier to do in your head.', 'Alberto Levis', '8842 Heath Road', '1988-05-10', '0648583855', 'alevis0@google.nl'),
('ffoulks11785', 'uoZno3qOIci', 'She found his complete dullness interesting.', 'Francesco Foulks', '266 Pennsylvania Terrace', '1983-07-25', '0631386694', 'ffoulks1@printfriendly.com'),
('wmaccartney23567', 'IkQ52BZXFYE3', 'The sky is clear, the stars are twinkling.', 'Wilhelm MacCartney', '010 Luster Court', '1995-02-20', '0547114806', 'wmaccartney2@netvibes.com'),
('kdyerson33988', 'LwOyMZLqyvi', null, 'Kean Dyerson', '9418 Rockefeller Hill', '1985-03-29', '0547114807', 'kdyerson3@yale.edu'),
('csimmonds43327', 'QbaKVMS', 'With a single flip of the coin', 'Clerissa Simmonds', '47045 Schiller Street', '1980-03-07', '0547114808', 'csimmonds4@plala.or.jp'),
('mtrowill58157', 'aw6njk3mv', 'The gruff old man sat in the back of the bait shop grumbling to himself as he scooped out a handful of worms.', 'Melessa Trowill', '54193 Ronald Regan Circle', '1984-04-20', '0831386694', 'mtrowill5@dion.ne.jp'),
('isimeone64503', 'YG55oKIb', 'The best key lime pie is still up for debate.', 'Ilene Simeone', '478 Little Fleur Junction', '1983-11-27', '0831386697', 'isimeone6@lycos.com'),
('mgennerich79936', 'sG6tkgh', 'He didn''t understand why the bird wanted to ride the bicycle.', 'Marty Gennerich', '70 Anzinger Trail', '2002-01-10', '0831386691', 'mgennerich7@feedburner.com'),
('cmcavey82681', 'TnM336XfjA', 'Some bathing suits just shouldn''t be worn by some people.', 'Clarey McAvey', '69 Red Cloud Court', '1989-12-23', '0831386698', 'cmcavey8@mapy.cz'),
('ccurner91113', 'aznw3ttWV', 'She wasn''t sure whether to be impressed or concerned that he folded underwear in neat little packages.', 'Connie Curner', '86 Delladonna Pass', '1991-11-21', '0831386697', 'ccurner9@cloudflare.com'),
('apenvardena5741', 'IPCuw1ngNhB', 'He took one look at what was under the table and noped the hell out of there.', 'Adelind Penvarden', '514 Dorton Alley', '1980-03-08', '0975558887', 'apenvardena@mtv.com'),
('ymcbrideb6010', 'rxGDLeiK', 'She found his complete dullness interesting.', 'Yul McBride', '8 Dixon Way', '1980-03-09', '0975558888', 'ymcbrideb@constantcontact.com'),
('dbennionc7305', 'GOBhaZsb', null, 'Dev Bennion', '70819 Division Lane', '1986-06-17', '0975558889', 'dbennionc@amazon.co.uk'),
('tkochsd6968', 'T8aR2lS', null, 'Torey Kochs', '0951 Corry Junction', '1988-05-21', '0975558810', 'tkochsd@smh.com.au'),
('rroote3983', 'GU9bwTj98U', 'Her life in the confines of the house became her new normal.', 'Rafferty Root', '11116 Crowley Parkway', '2001-01-21', '0975558811', 'rroote@aol.com'),
('tsearlf887', 'MjvlTv8TJfId', 'Improve your goldfish''s physical fitness by getting him a bicycle.', 'Tucky Searl', '8 Blaine Point', '2001-01-27', '0975558812', 'tsearlf@plala.or.jp'),
('jgraalmang6123', 'vLHZaahR9cD', 'but that doesn''t give you the right to be mean.', 'Jolyn Graalman', '9544 Pearson Terrace', '2001-01-29', '0975558813', 'jgraalmang@latimes.com'),
('bmorrillyh903', '9NZn1asoqisS', null, 'Bette Morrilly', '4462 Clyde Gallagher Way', '1988-02-25', '0975558814', 'bmorrillyh@gov.uk'),
('mschiraki6805', 'mzjtDnsi', null, 'Morrie Schirak', '829 Manufacturers Point', '1998-08-11', '0975558815', 'mschiraki@aol.com'),
('gashnessj5870', 'cDQ3R9gZQgNN', 'to prove it.', 'Gene Ashness', '13678 Nancy Circle', '1998-08-12', '0975558816', 'gashnessj@marriott.com'),
('zmacallamk9197', 'BL5zi8vi', 'but that doesn''t give you the right to be mean.', 'Zola Macallam', '5 Utah Court', '1998-08-13', '0975558817', 'zmacallamk@ed.gov'),
('vrigneyl7236', 'To6TiKqJbn', null, 'Violette Rigney', '4 Atwood Center', '1998-08-19', '0975558819', 'vrigneyl@ibm.com'),
('dcollettm2035', '15TFrY8BAQ', 'both physical and mental', 'Denis Collett', '3 Lunder Place', '1998-08-30', '0975558710', 'dcollettm@ibm.com'),
('kshaylorn1312', 'fqREBB6', 'The gruff old man sat in the back of the bait shop grumbling to himself as he scooped out a handful of worms.', 'Kent Shaylor', '96 Fordem Junction', '1984-04-22', '0975578811', 'kshaylorn@foxnews.com'),
('acoursono4141', 'IhOeDMIC', null, 'Albertina Courson', '08 Basil Parkway', '2001-06-23', '0975458812', 'acoursono@google.com.br'),
('dlishmanp627', 'M1w7ENaPNQ2T', 'Malls are great places to shop, I can find everything I need under one roof.', 'Dodie Lishman', '78523 Hanson Center', '2001-06-27', '0975578813', 'dlishmanp@cmu.edu'),
('caceyq9430', 'x39jvYp', 'The gruff old man sat in the back of the bait shop grumbling to himself as he scooped out a handful of worms.', 'Christophe Acey', '81 Merry Park', '2001-06-27', '0977558814', 'caceyq@csmonitor.com'),
('tbaylayr6742', 'WD0SVAm', null, 'Tabb Baylay', '47481 Johnson Place', '2001-06-29', '0975558715', 'tbaylayr@phpbb.com'),
('nlowrys2349', '3ggSEzPne', 'Flesh-colored yoga pants were far worse than even he feared.', 'Nessi Lowry', '89656 Jackson Hill', '2001-06-23', '0975598816', 'nlowrys@w3.org'),
('rrallint138', 'hGc4wIzrHRao', null, 'Rand Rallin', '1293 Summit Court', '2001-06-23', '0975758817', 'rrallint@joomla.org'),
('gmccrillisu1343', 'HEpUQt3zeVX', 'to prove it.', 'Garwood McCrillis', '27 Mifflin Street', '2001-06-23', '0975557818', 'gmccrillisu@yellowbook.com'),
('mcussonsv3574', 'yFnhSD', 'With a single flip of the coin', 'Melba Cussons', '38580 Sutherland Avenue', '1997-03-16', '0975578819', 'mcussonsv@discovery.com'),
('lmugglestonw8132', 'OkpWR1WtUe', null, 'Leta Muggleston', '60 Briar Crest Avenue', '1997-03-26', '0975557810', 'lmugglestonw@house.gov'),
('hslaytonx2593', 'f4cAnTEbgei', 'He learned the hardest lesson of his life and had the scars', 'Helenka Slayton', '061 Ryan Lane', '1987-03-16', '0826569894', 'hslaytonx@google.cn'),
('kpeacockey2070', 'rwfyPiMJ', 'to prove it.', 'Karole Peacocke', '42 Haas Avenue', '1997-07-06', '0826569810', 'kpeacockey@bbb.org'),
('rshewz5759', 'hVvKuE8PvTD', null, 'Ricca Shew', '17 Dorton Center', '1984-12-13', '0826569811', 'rshewz@cyberchimps.com'),
('efenkel101909', 'jnxbeN8qPas', 'my life changed forever.', 'Ev Fenkel', '2 Tony Pass', '1997-03-16', '0826569812', 'efenkel10@hud.gov'),
('lgladwell11975', 'pF1j6mn11', 'He took one look at what was under the table and noped the hell out of there.', 'Laurianne Gladwell', '7 Pond Junction', '1990-11-26', '0826569813', 'lgladwell11@lycos.com'),
('ssuddock125420', 'XOQwYz', 'It was the best sandcastle he had ever seen.', 'Stacey Suddock', '9214 Lotheville Street', '1986-04-30', '0826569814', 'ssuddock12@de.vu'),
('bborton134228', 'STJ86B9wI4', null, 'Bel Borton', '63924 Red Cloud Trail', '1994-04-20', '0826569815', 'bborton13@elegantthemes.com'),
('cbarta146433', 'qjVdqco', 'Flesh-colored yoga pants were far worse than even he feared.', 'Claudianus Barta', null, '2003-02-24', '0826569816', 'cbarta14@sitemeter.com'),
('dtytler151479', 'tr7v0hTr8CLA', 'You''ve been eyeing me all day and waiting for your move like a lion stalking a gazelle in a savannah.', 'Danielle Tytler', '53407 Melrose Circle', '1980-03-21', '0826569817', 'dtytler15@dropbox.com'),
('rgert168644', 'PKJjlwqX5Mx', '8% of 25 is the same as 25% of 8 and one of them is much easier to do in your head.', 'Ralina Gert', '197 Trailsway Trail', '1983-11-30', '0826569818', 'rgert16@ox.ac.uk'),
('ibaldrick17354', 'x95Eh1', 'He learned the hardest lesson of his life and had the scars', 'Isa Baldrick', '10 Truax Center', '1990-11-18', '0826569819', 'ibaldrick17@yahoo.com'),
('bsaggers187756', 'kIKqjZ57', 'Erin accidentally created a new universe.', 'Barbaraanne Saggers', '0346 6th Hill', '1999-03-03', '0826889810', 'bsaggers18@rambler.ru'),
('dfominov197311', '8fwskEoA', 'to prove it.', 'Dolorita Fominov', '906 Hazelcrest Lane', '1997-03-16', '0826889811', 'dfominov19@bloomberg.com'),
('tmott1a4762', 'R1rp8OTN', 'The best key lime pie is still up for debate.', 'Tara Mott', '0741 Memorial Hill', '1992-12-14', '0826889812', 'tmott1a@timesonline.co.uk'),
('erihanek1b5786', 'YgvwlsvDiu', 'but that doesn''t give you the right to be mean.', 'Ephrayim Rihanek', '12 Evergreen Street', '1997-11-14', '0826889813', 'erihanek1b@mtv.com'),
('khathaway1c8640', 'lEzX2cBcpx', null, 'Katee Hathaway', '23 Golden Leaf Pass', '2000-11-14', '0826889814', 'khathaway1c@amazon.com'),
('rbatterham1d5012', '49YOJO9RLZ', 'both physical and mental', 'Rani Batterham', '16 Surrey Hill', '1997-11-14', '0826889815', 'rbatterham1d@a8.net'),
('wmacdermand1e5059', 'JXjJ29', '8% of 25 is the same as 25% of 8 and one of them is much easier to do in your head.', 'Whittaker MacDermand', '297 Talmadge Junction', '2003-01-01', '0826889816', 'wmacdermand1e@techcrunch.com'),
('mingilson1f2346', 'nRt3qC5Td', 'He didn''t understand why the bird wanted to ride the bicycle.', 'Micky Ingilson', '6 La Follette Point', '1989-07-07', '0826889817', 'mingilson1f@europa.eu'),
('mhouldey1g9925', 'O6p6HQu1DPeD', 'but that doesn''t give you the right to be mean.', 'Maddalena Houldey', '29417 Dixon Hill', '1991-03-27', '0826889818', 'mhouldey1g@jigsy.com'),
('lchappelow1h2143', 'ix9xnkXx', 'She found his complete dullness interesting.', 'Laura Chappelow', '5470 Valley Edge Parkway', '1991-02-11', '0826889819', 'lchappelow1h@joomla.org'),
('ataunton1i8242', 'Skk8oJ0', 'Everybody should read Chaucer to improve their everyday vocabulary.', 'Alys Taunton.', '87 Anthes Terrace', '1985-03-21', '0826889820', 'ataunton1i@utexas.edu'),
('jlongthorn1j1884', 'pQcW1Zy', 'Her life in the confines of the house became her new normal.', 'Jessy Longthorn', '4 Luster Terrace', '1984-06-11', '0826889821', 'jlongthorn1j@cbsnews.com'),
('vdarycott1k8454', 'SxRj0AT34lG', 'Her life in the confines of the house became her new normal.', 'Verney Darycott', '7257 Harbort Crossing', '2001-05-04', '0826889822', 'vdarycott1k@nymag.com'),
('jchoke1l1707', 'SUt7JUfVndy', 'The gruff old man sat in the back of the bait shop grumbling to himself as he scooped out a handful of worms.', 'Jarret Choke', '67 Kropf Drive', '1990-06-03', '0826889823', 'jchoke1l@uol.com.br'),
('hcharity1m9672', 'dDODszdcXdr', 'Her life in the confines of the house became her new normal.', 'Heriberto Charity', '7 Pine View Road', '1986-04-12', '0826889824', 'hcharity1m@t.co'),
('bogormally1n5833', 'ksGBINhCc', null, 'Brenna O''Gormally', null, '1986-04-17', '0826889825', 'bogormally1n@angelfire.com'),
('hthickett1o6893', 't01ZYO1aK', 'Some bathing suits just shouldn''t be worn by some people.', 'Hazlett Thickett', '32 Fair Oaks Court', '1983-04-12', '0826889826', 'hthickett1o@icio.us'),
('mschleicher1p1553', 'ocsealv', 'Everybody should read Chaucer to improve their everyday vocabulary.', 'Michal Schleicher', '5 Lake View Terrace', '1988-10-19', '0826889827', 'mschleicher1p@desdev.cn'),
('cmcindrew1q3255', 'dKOnWf', 'It was the best sandcastle he had ever seen.', 'Clarine McIndrew', null, '2000-04-12', '0826889828', 'cmcindrew1q@admin.ch'),
('efrancombe1r3224', 'Ni6Z6OLCnu6x', 'both physical and mental', 'Ellette Francombe', '9 Mosinee Trail', '1998-02-20', '0826889829', 'efrancombe1r@ihg.com'),
('lcrocetto1s810', '3w5EAX1n', 'The three-year-old girl ran down the beach as the kite flew behind her.', 'Lazarus Crocetto', '4 Westridge Crossing', '1981-07-31', '0826889830', 'lcrocetto1s@youtube.com'),
('jhabgood1t929', 'bTl3DbXvA', 'The best key lime pie is still up for debate.', 'Jaquelin Habgood', null, '1999-08-12', '0826889831', 'jhabgood1t@nhs.uk'),
('bwitherdon1u2772', 'wYSlLIsgyWqY', 'Erin accidentally created a new universe.', 'Bill Witherdon', '6785 Mccormick Court', '1985-09-29', '0826889832', 'bwitherdon1u@surveymonkey.com'),
('rleatherbarrow1v9573', 'zXmXBBvlO', 'She found his complete dullness interesting.', 'Robbi Leatherbarrow', '6494 Esker Terrace', '1985-07-29', '0826889833', 'rleatherbarrow1v@bbb.org'),
('zdu1w5081', 'dEWSfuK7Jw4', '8% of 25 is the same as 25% of 8 and one of them is much easier to do in your head.', 'Zelma Du Barry', '18143 Northwestern Junction', '2000-08-12', '0826889834', 'zdu1w@wikimedia.org'),
('bnowlan1x613', 'rDjdJ6', null, 'Briny Nowlan', '3 Eliot Hill', '1994-04-12', '0826889835', 'bnowlan1x@netvibes.com'),
('mdales1y2744', 'EwgdIH2', 'Improve your goldfish''s physical fitness by getting him a bicycle.', 'Mauricio Dales', '9 Meadow Ridge Place', '2001-04-07', '0826889836', 'mdales1y@weebly.com'),
('rcullinan1z9758', '9HmtJZ', 'It was the best sandcastle he had ever seen.', 'Rod Cullinan', '001 Little Fleur Point', '2004-10-01', '0826889837', 'rcullinan1z@youtu.be'),
('blangmead207918', 'EhmbP1kU', 'You''ve been eyeing me all day and waiting for your move like a lion stalking a gazelle in a savannah.', 'Bibby Langmead', '61 Marquette Terrace', '1993-03-07', '0826889838', 'blangmead20@alibaba.com'),
('bhamfleet211535', 'veTb84HvBb', 'It was the best sandcastle he had ever seen.', 'Bee Hamfleet', null, '1983-04-29', '0826889839', 'bhamfleet21@si.edu'),
('ililly228101', 'a7hhuk', 'to prove it.', 'Isadora Lilly', '8 Nelson Avenue', '1999-06-26', '0826889840', 'ililly22@flickr.com'),
('lsillwood231861', 'v7pnAi7cA', 'to prove it.', 'Lotta Sillwood', '151 Ridgeview Circle', '2003-01-06', '0826889841', 'lsillwood23@pinterest.com'),
('cbracher247304', 'hqx2eSnAIo1l', 'Her daily goal was to improve on yesterday.', 'Cris Bracher', '63 Becker Pass', '2001-03-20', '0826889842', 'cbracher24@liveinternet.ru'),
('nhearne258989', 'p31yHI', null, 'Nariko Hearne', '64331 Weeping Birch Parkway', '1983-03-07', '0826889843', 'nhearne25@samsung.com'),
('jtumioto262402', '27rODglm', 'The best key lime pie is still up for debate.', 'Jeffie Tumioto', '9 Bashford Plaza', '2001-03-01', '0826889844', 'jtumioto26@va.gov'),
('ahanington27348', '8dxXTEbYoz2', 'She wasn''t sure whether to be impressed or concerned that he folded underwear in neat little packages.', 'Alvy Hanington', '6 East Place', '2001-03-04', '0826889845', 'ahanington27@go.com'),
('czambonini288433', 'dla4NmDmuC', 'my life changed forever.', 'Carly Zambonini', '79434 Manitowish Point', '2001-03-04', '0826889846', 'czambonini28@github.io'),
('tradband295267', '3HgNR5O0LRw', 'It was the best sandcastle he had ever seen.', 'Terra Radband', '40029 Shopko Plaza', '2001-03-28', '0826889847', 'tradband29@va.gov'),
('hmahady2a879', 'AUaYZGj0x', 'The sky is clear, the stars are twinkling.', 'Hilary Mahady', '51 4th Circle', '2002-03-20', '0826889848', 'hmahady2a@mayoclinic.com'),
('nmcavinchey2b8857', 'OyZ8Tl8OF', 'Some bathing suits just shouldn''t be worn by some people.', 'Nate McAvinchey', '698 Park Meadow Crossing', '2002-03-20', '0826889849', 'nmcavinchey2b@biblegateway.com'),
('mtanswell2c9664', '4Tc05ROj5Jy', 'Everybody should read Chaucer to improve their everyday vocabulary.', 'Montague Tanswell', '30 Farwell Street', '1986-02-07', '0826889850', 'mtanswell2c@storify.com'),
('ckitchin2d8651', 'L3jIO4Kn5Lu', 'She found his complete dullness interesting.', 'Clem Kitchin', '4 Mallard Place', '1986-02-07', '0826889851', 'ckitchin2d@tinypic.com'),
('koatley2e3741', 'Q34yKoB09Sl', 'Her daily goal was to improve on yesterday.', 'Kory Oatley', '8 Susan Parkway', '1986-02-08', '0826889852', 'koatley2e@homestead.com'),
('mjellico2f6236', '6yhwriw', 'The gruff old man sat in the back of the bait shop grumbling to himself as he scooped out a handful of worms.', 'Melvyn Jellico', '0 Vera Park', '1986-12-07', '0826889853', 'mjellico2f@sun.com'),
('gcritzen2g4781', '1bCip7pdOjG', 'Her daily goal was to improve on yesterday.', 'Georgina Critzen', '2992 Laurel Plaza', '2004-02-25', '0826889854', 'gcritzen2g@mozilla.com'),
('kscouler2h9869', '4uyhbHHm', 'Her life in the confines of the house became her new normal.', 'Kissie Scouler', '8 Drewry Parkway', '2003-02-14', '0826889855', 'kscouler2h@japanpost.jp'),
('bfleckness2i2210', '0pBtFS9', 'Her daily goal was to improve on yesterday.', 'Brina Fleckness', '83 Old Shore Lane', '1983-08-19', '0826889856', 'bfleckness2i@blogs.com'),
('hklimkiewich2j3172', 'bpek3OG', null, 'Haze Klimkiewich', '91658 Kingsford Drive', '1980-01-21', '0826889857', 'hklimkiewich2j@state.tx.us'),
('ccuttell2k8806', 'o5vRczymy1lV', null, 'Cordelia Cuttell', '23 Nova Point', '2003-07-08', '0826889858', 'ccuttell2k@aboutads.info'),
('rwarner2l728', 'ENX8Lb1', 'You''ve been eyeing me all day and waiting for your move like a lion stalking a gazelle in a savannah.', 'Ricoriki Warner', '52 Forest Crossing', '1986-02-07', '0826889859', 'rwarner2l@constantcontact.com'),
('jmulleary2m2116', '0PmKyTf', 'He took one look at what was under the table and noped the hell out of there.', 'Jody Mulleary', '98 Steensland Point', '1981-09-20', '0826889860', 'jmulleary2m@europa.eu'),
('adorcey2n3560', 'bQRyGCI', 'Some bathing suits just shouldn''t be worn by some people.', 'Annabella Dorcey', '40 Pierstorff Circle', '2002-09-25', '0826889861', 'adorcey2n@ustream.tv'),
('sjoesbury2o8846', 'b2naSEtxMi6x', null, 'Shannah Joesbury', '8090 Mayfield Lane', '1994-06-30', '0826889862', 'sjoesbury2o@arizona.edu'),
('blamers2p3435', 'wql4K3Hz', 'He learned the hardest lesson of his life and had the scars', 'Bianka Lamers', '4106 Vera Plaza', '1995-05-26', '0826889863', 'blamers2p@furl.net'),
('citzak2q9923', 'IPKPVtDCQ', 'He didn''t understand why the bird wanted to ride the bicycle.', 'Cami Itzak', null, '1980-01-08', '0826889864', 'citzak2q@redcross.org'),
('fbattersby2r9845', 'EBXH3VbfD', 'He took one look at what was under the table and noped the hell out of there.', 'Flor Battersby', '8 East Road', '2002-12-21', '0826889865', 'fbattersby2r@wordpress.org');

/*          User_Follower              */

INSERT INTO user_follower (user_id, follower_id) 
VALUES 
('zdu1w5081', 'lsillwood231861'),
('mtrowill58157', 'lcrocetto1s810'),
('mdales1y2744', 'dlishmanp627'),
('citzak2q9923', 'alevis07232'),
('gashnessj5870', 'rshewz5759'),
('ataunton1i8242', 'dfominov197311'),
('mdales1y2744', 'nhearne258989'),
('dfominov197311', 'mschiraki6805'),
('tkochsd6968', 'wmaccartney23567'),
('nhearne258989', 'rrallint138'),
('ahanington27348', 'jgraalmang6123'),
('gmccrillisu1343', 'jlongthorn1j1884'),
('ahanington27348', 'ataunton1i8242'),
('hthickett1o6893', 'nhearne258989'),
('cmcindrew1q3255', 'zmacallamk9197'),
('lsillwood231861', 'bwitherdon1u2772'),
('mschleicher1p1553', 'rrallint138'),
('mhouldey1g9925', 'koatley2e3741'),
('ymcbrideb6010', 'ahanington27348'),
('mschleicher1p1553', 'dtytler151479'),
('tmott1a4762', 'adorcey2n3560'),
('ahanington27348', 'cmcindrew1q3255'),
('caceyq9430', 'gcritzen2g4781'),
('zmacallamk9197', 'sjoesbury2o8846'),
('jmulleary2m2116', 'ahanington27348'),
('czambonini288433', 'mjellico2f6236'),
('fbattersby2r9845', 'adorcey2n3560'),
('dfominov197311', 'vdarycott1k8454'),
('rwarner2l728', 'dfominov197311'),
('dtytler151479', 'zdu1w5081'),
('ffoulks11785', 'rrallint138'),
('hmahady2a879', 'zmacallamk9197'),
('koatley2e3741', 'ffoulks11785'),
('vdarycott1k8454', 'jgraalmang6123'),
('efenkel101909', 'mschiraki6805'),
('mingilson1f2346', 'ahanington27348'),
('ssuddock125420', 'mingilson1f2346'),
('tsearlf887', 'gashnessj5870'),
('zdu1w5081', 'acoursono4141'),
('cmcavey82681', 'hmahady2a879'),
('ccuttell2k8806', 'hthickett1o6893'),
('mdales1y2744', 'jlongthorn1j1884'),
('rgert168644', 'nmcavinchey2b8857'),
('tbaylayr6742', 'bfleckness2i2210'),
('mingilson1f2346', 'efrancombe1r3224'),
('khathaway1c8640', 'kpeacockey2070'),
('cbarta146433', 'tkochsd6968'),
('erihanek1b5786', 'rbatterham1d5012'),
('ssuddock125420', 'lcrocetto1s810'),
('tradband295267', 'caceyq9430'),
('nmcavinchey2b8857', 'zmacallamk9197'),
('gashnessj5870', 'wmaccartney23567'),
('alevis07232', 'koatley2e3741'),
('hthickett1o6893', 'hklimkiewich2j3172'),
('hthickett1o6893', 'jmulleary2m2116'),
('jlongthorn1j1884', 'jmulleary2m2116'),
('rwarner2l728', 'bhamfleet211535'),
('rshewz5759', 'hthickett1o6893'),
('kdyerson33988', 'bhamfleet211535'),
('mschleicher1p1553', 'csimmonds43327'),
('citzak2q9923', 'zdu1w5081'),
('ahanington27348', 'mtrowill58157'),
('csimmonds43327', 'hklimkiewich2j3172'),
('nmcavinchey2b8857', 'vdarycott1k8454'),
('ccurner91113', 'blangmead207918'),
('bwitherdon1u2772', 'ckitchin2d8651'),
('lsillwood231861', 'jmulleary2m2116'),
('mschiraki6805', 'efrancombe1r3224'),
('efenkel101909', 'fbattersby2r9845'),
('koatley2e3741', 'tsearlf887'),
('adorcey2n3560', 'isimeone64503'),
('fbattersby2r9845', 'dlishmanp627'),
('mdales1y2744', 'fbattersby2r9845'),
('bhamfleet211535', 'nlowrys2349'),
('bnowlan1x613', 'nhearne258989'),
('koatley2e3741', 'dbennionc7305'),
('nlowrys2349', 'gcritzen2g4781'),
('mjellico2f6236', 'kscouler2h9869'),
('citzak2q9923', 'dtytler151479'),
('tbaylayr6742', 'hklimkiewich2j3172'),
('efenkel101909', 'acoursono4141'),
('lgladwell11975', 'bhamfleet211535'),
('sjoesbury2o8846', 'nhearne258989'),
('citzak2q9923', 'adorcey2n3560'),
('gmccrillisu1343', 'tsearlf887'),
('acoursono4141', 'blamers2p3435'),
('efenkel101909', 'rrallint138'),
('fbattersby2r9845', 'mtanswell2c9664'),
('ymcbrideb6010', 'kdyerson33988'),
('gmccrillisu1343', 'czambonini288433'),
('rbatterham1d5012', 'mingilson1f2346'),
('efenkel101909', 'jlongthorn1j1884'),
('wmaccartney23567', 'tmott1a4762'),
('zdu1w5081', 'vrigneyl7236'),
('sjoesbury2o8846', 'apenvardena5741'),
('dbennionc7305', 'jchoke1l1707'),
('rleatherbarrow1v9573', 'bborton134228'),
('bhamfleet211535', 'dfominov197311'),
('jtumioto262402', 'dbennionc7305'),
('jlongthorn1j1884', 'blangmead207918');

/*               Post            */

INSERT INTO post (post_datetime, post_content, post_media, writer_id) 
VALUES 
('2022-01-26 18:35:45', 'the coffin was still full of Jello.', 'https://i.ibb.co/VS4kgy2/media.png', 'wmaccartney23567'),
('2022-02-16 20:22:51', 'Jason didn''t understand why his parents wouldn''t let him sell his little sister at the garage sale.', null, 'csimmonds43327'),
('2022-10-30 4:04:38', null, 'https://i.ibb.co/VS4kgy2/media.png', 'cmcavey82681'),
('2022-04-18 10:33:57', 'Doris enjoyed tapping her nails on the table to annoy everyone.', 'https://i.ibb.co/VS4kgy2/media.png', 'ymcbrideb6010'),
('2022-05-10 16:49:28', 'Various sea birds are elegant', 'https://i.ibb.co/VS4kgy2/media.png', 'tkochsd6968'),
('2022-05-25 5:24:49', 'Acres of almond trees lined the interstate highway which complimented the crazy driving nuts.', 'https://i.ibb.co/VS4kgy2/media.png', 'zmacallamk9197'),
('2022-03-19 6:07:16', null, 'https://i.ibb.co/VS4kgy2/media.png', 'kshaylorn1312'),
('2022-05-23 18:30:22', 'She wasn''t sure whether to be impressed or concerned that he folded underwear in neat little packages.', null, 'tbaylayr6742'),
('2022-07-11 16:12:12', 'I am never at home on Sundays.', 'https://i.ibb.co/VS4kgy2/media.png', 'tbaylayr6742'),
('2022-01-03 2:05:32', 'Today I heard something new and unmemorable.', null, 'rrallint138'),
('2022-08-27 6:07:54', 'but he was fairly useless as a mode of transport.', 'https://i.ibb.co/VS4kgy2/media.png', 'rshewz5759'),
('2022-04-27 18:38:27', 'He enjoys practicing his ballet in the bathroom.', 'https://i.ibb.co/VS4kgy2/media.png', 'rshewz5759'),
('2022-06-11 1:54:02', 'One small action would change her life', null, 'rshewz5759'),
('2022-06-26 0:45:25', 'but whether it would be for better or for worse was yet to be determined.', 'https://i.ibb.co/VS4kgy2/media.png', 'rshewz5759'),
('2022-06-09 12:51:09', 'Mom didn''t understand why no one else wanted a hot tub full of jello.', 'https://i.ibb.co/VS4kgy2/media.png', 'ataunton1i8242'),
('2022-04-26 8:46:10', 'I was fishing for compliments and accidentally caught a trout.', null, 'ataunton1i8242'),
('2022-10-25 14:48:46', 'Bill ran from the giraffe toward the dolphin.', null, 'hcharity1m9672'),
('2021-12-14 6:52:07', 'Three years later', 'https://i.ibb.co/VS4kgy2/media.png', 'hcharity1m9672'),
('2022-02-23 8:52:40', null, 'https://i.ibb.co/VS4kgy2/media.png', 'efrancombe1r3224'),
('2022-07-13 22:45:44', 'Joyce enjoyed eating pancakes with ketchup.', null, 'efrancombe1r3224'),
('2022-07-30 4:06:00', 'You''re good at English when you know the difference between a man eating chicken and a man-eating chicken.', 'https://i.ibb.co/VS4kgy2/media.png', 'mschleicher1p1553'),
('2022-08-16 15:17:41', 'but whether it would be for better or for worse was yet to be determined.', 'https://i.ibb.co/VS4kgy2/media.png', 'lsillwood231861'),
('2022-10-31 23:35:18', 'Three years later', 'https://i.ibb.co/VS4kgy2/media.png', 'lsillwood231861'),
('2022-04-29 8:04:22', 'Jerry liked to look at paintings while eating garlic ice cream.', 'https://i.ibb.co/VS4kgy2/media.png', 'blamers2p3435'),
('2022-03-09 15:45:46', 'Today I heard something new and unmemorable.', 'https://i.ibb.co/VS4kgy2/media.png', 'rleatherbarrow1v9573'),
('2021-12-30 6:31:22', 'Her life in the confines of the house became her new normal.', null, 'rleatherbarrow1v9573'),
('2022-01-30 13:48:55', 'I''ll stay away from it.', null, 'rleatherbarrow1v9573'),
('2022-12-03 17:44:09', 'I had a friend in high school named Rick Shaw', 'https://i.ibb.co/VS4kgy2/media.png', 'alevis07232'),
('2022-09-21 16:49:46', 'He enjoys practicing his ballet in the bathroom.', 'https://i.ibb.co/VS4kgy2/media.png', 'lgladwell11975'),
('2022-05-27 22:28:38', 'Her life in the confines of the house became her new normal.', 'https://i.ibb.co/VS4kgy2/media.png', 'lgladwell11975'),
('2022-12-12 0:33:29', 'He excelled at firing people nicely.', null, 'mtrowill58157'),
('2022-01-03 9:33:00', 'There was no telling what thoughts would come from the machine.', 'https://i.ibb.co/VS4kgy2/media.png', 'dfominov197311'),
('2022-10-19 19:14:35', 'The gloves protect my feet from excess work.', null, 'mschleicher1p1553'),
('2022-06-19 12:32:00', 'The gloves protect my feet from excess work.', null, 'dfominov197311'),
('2022-06-05 6:25:02', 'The chic gangster liked to start the day with a pink scarf.', null, 'dfominov197311'),
('2022-11-17 22:23:02', 'I am never at home on Sundays.', null, 'dfominov197311'),
('2021-12-22 15:42:02', 'Doris enjoyed tapping her nails on the table to annoy everyone.', null, 'ataunton1i8242'),
('2022-02-04 13:59:29', 'Hello I''m a cello', null, 'hcharity1m9672'),
('2022-05-24 13:15:06', 'Chicken nuggets', 'https://i.ibb.co/VS4kgy2/media.png', 'ymcbrideb6010'),
('2022-08-03 4:06:11', 'Good dog', 'https://i.ibb.co/VS4kgy2/media.png', 'tkochsd6968');

/*         Group        */

INSERT INTO `group` (group_name, group_description, manager_id) 
VALUES 
('League of Legends Group', 'League of legends is a multi-player online battle arena video game developed by Riot Games and players from all over the world compete daily in ranked matches.', 'kdyerson33988'),
('Computer Networks Group', 'Computer networks are complex and you need a solid understanding of their basics. This group gives you the information you need to understand how computer networks work.', 'hslaytonx2593'),
('Database system Group', 'The database system group was created to help you get good grades in your database systems course.', 'ibaldrick17354'),
('HCMUT Group', 'HCMUT is a leading university in Vietnam with more than 20 Years of experience. We provide the best education and training in Vietnam. HCMUT is an independent education and training provider.', 'jtumioto262402'),
('Harvard Group', 'Harvard University is the oldest institution of higher education in the United States. The university has over 35 000 students enrolled in its graduate and undergraduate programs.', 'kscouler2h9869'),
('FO4 Group', 'The game of football is so popular that it has been translated into many languages and it''s no wonder why.', 'fbattersby2r9845'),
('Tran Cong Huy Hoang Fanclub Group', 'Tran Cong Huy Hoang is a Vietnamese scientist from Ho Chi Minh city Vietnam .The first person to have played chess in space where he became the first to play a game in space.', 'hklimkiewich2j3172'),
('BTS fanclub Group', 'BTS is a seven-member South Korean boy group formed by Big Hit Entertainment.', 'rbatterham1d5012'),
('Gamers Group', 'A group for all gamers in the world. We have a lot of games in our group. We have decided to make a group for gamers!!!', 'tbaylayr6742'),
('Meme Group', 'Memes are popping up all over the internet', 'ccurner91113');

/*        Group Member         */

INSERT INTO group_member (member_id, group_id) 
VALUES 
('alevis07232', 5),
('ffoulks11785', 6),
('wmaccartney23567', 1),
('kdyerson33988', 5),
('csimmonds43327', 10),
('mtrowill58157', 10),
('isimeone64503', 1),
('mgennerich79936', 1),
('cmcavey82681', 10),
('ccurner91113', 8),
('apenvardena5741', 8),
('ymcbrideb6010', 8),
('dbennionc7305', 5),
('tkochsd6968', 9),
('rroote3983', 10),
('tsearlf887', 6),
('jgraalmang6123', 10),
('bmorrillyh903', 6),
('mschiraki6805', 6),
('gashnessj5870', 10),
('zmacallamk9197', 10),
('vrigneyl7236', 9),
('dcollettm2035', 5),
('kshaylorn1312', 6),
('acoursono4141', 6),
('dlishmanp627', 7),
('caceyq9430', 8),
('tbaylayr6742', 3),
('nlowrys2349', 4),
('rrallint138', 4),
('gmccrillisu1343', 1),
('mcussonsv3574', 1),
('lmugglestonw8132', 4),
('hslaytonx2593', 8),
('kpeacockey2070', 8),
('rshewz5759', 6),
('efenkel101909', 10),
('lgladwell11975', 7),
('ssuddock125420', 4),
('bborton134228', 1),
('cbarta146433', 7),
('dtytler151479', 9),
('rgert168644', 4),
('ibaldrick17354', 10),
('bsaggers187756', 10),
('dfominov197311', 4),
('tmott1a4762', 10),
('erihanek1b5786', 1),
('khathaway1c8640', 3),
('rbatterham1d5012', 8),
('wmacdermand1e5059', 5),
('mingilson1f2346', 4),
('mhouldey1g9925', 8),
('lchappelow1h2143', 6),
('ataunton1i8242', 7),
('jlongthorn1j1884', 10),
('vdarycott1k8454', 9),
('jchoke1l1707', 2),
('hcharity1m9672', 5),
('bogormally1n5833', 10),
('hthickett1o6893', 10),
('mschleicher1p1553', 1),
('cmcindrew1q3255', 9),
('efrancombe1r3224', 5),
('lcrocetto1s810', 4),
('jhabgood1t929', 1),
('bwitherdon1u2772', 1),
('rleatherbarrow1v9573', 5),
('zdu1w5081', 2),
('bnowlan1x613', 5),
('mdales1y2744', 3),
('rcullinan1z9758', 4),
('blangmead207918', 10),
('bhamfleet211535', 7),
('ililly228101', 5),
('lsillwood231861', 3),
('cbracher247304', 4),
('nhearne258989', 8),
('jtumioto262402', 8),
('ahanington27348', 2),
('czambonini288433', 6),
('tradband295267', 2),
('hmahady2a879', 1),
('nmcavinchey2b8857', 8),
('mtanswell2c9664', 3),
('ckitchin2d8651', 6),
('koatley2e3741', 3),
('mjellico2f6236', 10),
('gcritzen2g4781', 8),
('kscouler2h9869', 9),
('bfleckness2i2210', 5),
('hklimkiewich2j3172', 6),
('ccuttell2k8806', 5),
('rwarner2l728', 5),
('jmulleary2m2116', 4),
('adorcey2n3560', 1),
('sjoesbury2o8846', 5),
('blamers2p3435', 2),
('citzak2q9923', 6),
('fbattersby2r9845', 8);

/*         Group post           */

INSERT INTO group_post (post_id, group_id) 
VALUES 
(2, 5),
(4, 3),
(6, 10),
(8, 7),
(10, 4),
(12, 6),
(14, 9),
(16, 4),
(18, 3),
(20, 7),
(22, 1),
(24, 2),
(26, 8),
(28, 10),
(30, 5);

/*       personal_post        */

INSERT INTO personal_post (post_id, post_privacy) 
VALUES 
(31, 'public'),
(32, 'public'),
(33, 'private'),
(34, 'private'),
(35, 'public'),
(36, 'private'),
(37, 'public'),
(38, 'private'),
(39, 'private'),
(40, 'public');

/*        Comment            */

INSERT INTO comment (comment_content, comment_datetime, writer_id) 
VALUES  
('She wore green lipstick like a fashion icon.', '2022-07-01 22:54:44', 'dlishmanp627'),
('In hopes of finding out the truth he entered the one-room library.', '2022-07-03 18:35:17', 'wmaccartney23567'),
('He found the chocolate covered roaches quite tasty.', '2022-05-22 09:29:55', 'zdu1w5081'),
('For some unfathomable reason the response team did not consider a lack of milk for my cereal as a proper emergency.', '2022-09-18 03:33:52', 'blamers2p3435'),
('Nancy decided to make the porta-potty her home.', '2022-04-12 14:18:28', 'lcrocetto1s810'),
('When confronted with a rotary dial phone the teenager was perplexed.', '2022-05-01 08:05:08', 'lcrocetto1s810'),
('The quick brown fox jumps over the lazy dog.', '2021-12-30 03:02:07', 'wmaccartney23567'),
('Everyone says they love nature until they realize how dangerous she can be.', '2022-11-08 19:15:32', 'bnowlan1x613'),
('The ants enjoyed the barbecue more than the family.', '2022-06-17 07:54:00', 'jlongthorn1j1884'),
('The bullet pierced the window shattering it before missing Danny has head by mere millimeters.', '2022-06-04 11:39:09', 'cbarta146433'),
('Most shark attacks occur about 10 feet from the beach since that is where the people are.', '2022-09-23 21:40:04', 'mhouldey1g9925'),
('Boulders lined the side of the road foretelling what could come next.', '2022-09-24 23:51:29', 'vrigneyl7236'),
('His son quipped that power bars were nothing more than adult candy bars.', '2022-10-10 21:07:57', 'bhamfleet211535'),
('Dan took the deep dive down the rabbit hole.', '2022-08-08 16:00:10', 'efenkel101909'),
('You realize you are not alone as you sit in your bedroom massaging your calves after a long day of playing tug-of-war with Grandpa Joe in the hospital.', '2022-04-09 02:21:09', 'efenkel101909'),
('The beauty of the African sunset disguised the danger lurking nearby.', '2022-10-31 23:39:12', 'rrallint138'),
('The sky is clear, the stars are twinkling.', '2022-09-19 16:39:13', 'erihanek1b5786'),
('He was sure the Devil created red sparkly glitter.', '2022-11-11 06:57:11', 'dlishmanp627'),
('Tomorrow will bring something new so leave today as a memory.', '2022-04-21 12:04:35', 'rwarner2l728'),
('Flesh-colored yoga pants were far worse than even he feared.', '2022-08-18 09:42:26', 'mtrowill58157'),
('As you consider all the possible ways to improve yourself and the world you notice John Travolta seems fairly unhappy.', '2021-12-18 15:05:45', 'lmugglestonw8132'),
('When transplanting seedlings candied teapots will make the task easier.', '2022-05-04 23:58:37', 'lcrocetto1s810'),
('It dawned on her that others could make her happier but only she could make herself happy.', '2022-09-22 09:24:04', 'czambonini288433'),
('The snow-covered path was no help in finding his way out of the back-country.', '2022-04-23 09:13:44', 'cmcindrew1q3255'),
('Nancy decided to make the porta-potty her home.', '2022-09-25 01:05:05', 'nmcavinchey2b8857'),
('Tomorrow will bring something new so leave today as a memory.', '2022-09-24 19:25:21', 'tradband295267'),
('As she walked along the street and looked in the gutter she realized facemasks had become the new cigarette butts.', '2022-06-27 19:26:35', 'mjellico2f6236'),
('The blinking lights of the antenna tower came into focus just as I heard a loud snap.', '2022-05-08 03:28:13', 'dbennionc7305'),
('He took one look at what was under the table and noped the hell out of there.', '2022-04-17 03:10:13', 'jhabgood1t929'),
('The small white buoys marked the location of hundreds of crab pots.', '2022-04-27 03:51:45', 'mtanswell2c9664'),
('The shark-infested South Pine channel was the only way in or out.', '2022-01-10 10:39:03', 'hcharity1m9672'),
('Thigh-high in the water the fishermans hope for dinner soon turned to despair.', '2022-03-08 12:55:35', 'ililly228101'),
('The shark-infested South Pine channel was the only way in or out.', '2022-07-28 12:01:21', 'ymcbrideb6010'),
('She could hear him in the shower singing with a joy she hoped he would retain after she delivered the news.', '2022-07-02 08:56:56', 'rleatherbarrow1v9573'),
('The sunblock was handed to the girl before practice but the burned skin was proof she did not apply it.', '2022-03-29 15:59:52', 'rrallint138'),
('The bullet pierced the window shattering it before missing Danny has head by mere millimeters.', '2022-04-11 16:11:25', 'wmacdermand1e5059'),
('The shark-infested South Pine channel was the only way in or out.', '2022-04-30 03:50:04', 'bwitherdon1u2772'),
('Mothers spend months of their lives waiting on their children.', '2022-07-18 15:22:42', 'nlowrys2349'),
('There is an art to getting your way and spitting olive pits across the table is not it.', '2022-09-09 20:15:17', 'rgert168644'),
('The sky is clear, the stars are twinkling.', '2022-12-08 23:32:29', 'koatley2e3741'),
('Beach-combing replaced wine tasting as his new obsession.', '2022-09-08 03:48:26', 'ibaldrick17354'),
('I received a heavy fine but it failed to crush my spirit.', '2022-11-03 16:27:15', 'hslaytonx2593'),
('He always wore his sunglasses at night.', '2022-09-05 06:31:02', 'sjoesbury2o8846'),
('We should play with legos at camp.', '2022-07-14 08:28:58', 'ssuddock125420'),
('After exploring the abandoned building he started to believe in ghosts.', '2022-01-20 15:38:27', 'ahanington27348'),
('As you consider all the possible ways to improve yourself and the world you notice John Travolta seems fairly unhappy.', '2022-06-15 15:18:01', 'csimmonds43327'),
('but this was not it.', '2022-10-02 07:11:53', 'ahanington27348'),
('She had a difficult time owning up to her own crazy self.', '2022-03-19 05:42:10', 'sjoesbury2o8846'),
('They called out her name time and again but were met with nothing but silence.', '2022-08-11 10:10:35', 'lgladwell11975'),
('Weather is not trivial - its especially important when you are standing in it.', '2022-10-31 16:01:05', 'ccurner91113'),
('She insisted that cleaning out your closet was the key to good driving.', '2022-09-07 06:46:49', 'blamers2p3435'),
('There are not enough towels in the world to stop the sewage flowing from his mouth.', '2022-11-07 11:44:19', 'hklimkiewich2j3172'),
('Its never been my responsibility to glaze the donuts.', '2022-05-02 12:31:38', 'ckitchin2d8651'),
('Pantyhose and heels are an interesting choice of attire for the beach.', '2022-03-27 22:59:22', 'hslaytonx2593'),
('There should have been a time and a place', '2022-11-26 07:23:08', 'alevis07232'),
('When transplanting seedlings candied teapots will make the task easier.', '2022-03-09 23:51:49', 'nmcavinchey2b8857'),
('Siri became confused when we reused to follow her directions.', '2022-09-17 04:19:45', 'rshewz5759'),
('Peter found road kill an excellent way to save money on dinner.', '2022-07-04 01:58:24', 'apenvardena5741'),
('The beauty of the African sunset disguised the danger lurking nearby.', '2021-12-28 10:31:14', 'nmcavinchey2b8857'),
('The snow-covered path was no help in finding his way out of the back-country.', '2022-10-07 21:54:30', 'mschleicher1p1553'),
('At that moment she realized she had a sixth sense.', '2022-01-23 00:13:14', 'rrallint138'),
('The dead trees waited to be ignited by the smallest spark and seek their revenge.', '2022-11-10 05:05:41', 'ssuddock125420'),
('Watching the geriatric softball team brought back memories of 3 year olds playing t-ball.', '2022-12-03 03:20:54', 'koatley2e3741'),
('Tomorrow will bring something new so leave today as a memory.', '2022-07-31 16:02:50', 'jtumioto262402'),
('A song can make or ruin a persons day if they let it get to them.', '2022-01-30 18:26:22', 'ccuttell2k8806'),
('Watching the geriatric softball team brought back memories of 3 year olds playing t-ball.', '2022-07-17 01:14:59', 'dfominov197311'),
('The fact that there is a stairway to heaven and a highway to hell explains life well.', '2022-11-27 23:45:02', 'cbracher247304'),
('Tomorrow will bring something new so leave today as a memory.', '2022-07-16 18:10:31', 'dbennionc7305'),
('It was the first time he had ever seen someone cook dinner on an elephant.', '2022-04-28 15:19:56', 'erihanek1b5786'),
('I am counting my calories yet I really want dessert.', '2022-01-09 10:57:08', 'dtytler151479'),
('As she walked along the street and looked in the gutter she realized facemasks had become the new cigarette butts.', '2022-03-17 13:05:11', 'gmccrillisu1343'),
('You realize you are not alone as you sit in your bedroom massaging your calves after a long day of playing tug-of-war with Grandpa Joe in the hospital.', '2022-04-05 04:49:26', 'mingilson1f2346'),
('He would only survive if he kept the fire going and he could hear thunder in the distance.', '2022-11-07 23:48:41', 'cmcavey82681'),
('She insisted that cleaning out your closet was the key to good driving.', '2022-09-03 07:17:10', 'rroote3983'),
('The ants enjoyed the barbecue more than the family.', '2022-03-11 21:59:12', 'ccurner91113'),
('Combines are no longer just for farms.', '2022-10-01 22:23:14', 'vrigneyl7236'),
('They called out her name time and again but were met with nothing but silence.', '2022-04-27 18:59:24', 'ccurner91113'),
('Traveling became almost extinct during the pandemic.', '2022-11-28 01:37:28', 'rwarner2l728'),
('They are playing the piano while flying in the plane.', '2022-08-01 13:00:08', 'dcollettm2035'),
('His son quipped that power bars were nothing more than adult candy bars.', '2022-09-26 07:29:19', 'apenvardena5741'),
('but this was not it.', '2022-03-29 18:49:39', 'koatley2e3741'),
('His son quipped that power bars were nothing more than adult candy bars.', '2022-11-01 07:46:53', 'cmcavey82681'),
('Even though he thought the world was flat he didnt see the irony of wanting to travel around the world.', '2022-10-14 16:12:40', 'mcussonsv3574'),
('Combines are no longer just for farms.', '2022-10-11 01:54:43', 'wmaccartney23567'),
('The stench from the feedlot permeated the car despite having the air conditioning on recycled air.', '2022-10-01 01:17:26', 'alevis07232'),
('One small action would change her life but whether it would be for better or for worse was yet to be determined.', '2022-03-27 23:21:02', 'ccuttell2k8806'),
('The snow-covered path was no help in finding his way out of the back-country.', '2022-11-16 22:24:49', 'bfleckness2i2210'),
('Peter found road kill an excellent way to save money on dinner.', '2022-12-05 06:43:30', 'hklimkiewich2j3172'),
('Combines are no longer just for farms.', '2022-09-02 01:48:20', 'csimmonds43327'),
('It was the best sandcastle he had ever seen.', '2022-09-26 09:42:39', 'rgert168644'),
('He had concluded that pigs must be able to fly in Hog Heaven.', '2022-09-29 15:19:31', 'blangmead207918'),
('It would have been a better night if the guys next to us were not in the splash zone.', '2022-08-27 04:18:38', 'jmulleary2m2116'),
('The gloves protect my feet from excess work.', '2022-10-08 15:42:22', 'jmulleary2m2116'),
('As you consider all the possible ways to improve yourself and the world you notice John Travolta seems fairly unhappy.', '2022-11-12 18:00:00', 'rcullinan1z9758'),
('It dawned on her that others could make her happier but only she could make herself happy.', '2022-09-04 16:22:33', 'vdarycott1k8454'),
('She found his complete dullness interesting.', '2022-11-02 12:59:07', 'ahanington27348'),
('Combines are no longer just for farms.', '2021-12-22 23:47:40', 'bwitherdon1u2772'),
('He was disappointed when he found the beach to be so sandy and the sun so sunny.', '2022-11-26 01:57:41', 'ccuttell2k8806'),
('Traveling became almost extinct during the pandemic.', '2022-04-07 17:48:38', 'dtytler151479'),
('It dawned on her that others could make her happier but only she could make herself happy.', '2022-10-03 03:33:29', 'tmott1a4762'),
('The blinking lights of the antenna tower came into focus just as I heard a loud snap.', '2022-12-10 13:03:13', 'jhabgood1t929'),
('He found the chocolate covered roaches quite tasty.', '2021-12-29 14:00:32', 'gcritzen2g4781'),
('She wore green lipstick like a fashion icon.', '2022-08-11 22:05:18', 'hthickett1o6893'),
('He had concluded that pigs must be able to fly in Hog Heaven.', '2022-05-07 09:25:31', 'hcharity1m9672'),
('Some bathing suits just shouldnt be worn by some people.', '2022-12-07 11:59:42', 'vdarycott1k8454'),
('Dan took the deep dive down the rabbit hole.', '2022-12-05 22:36:43', 'gcritzen2g4781'),
('Despite multiple complications and her near-death experience', '2022-09-24 03:25:59', 'ffoulks11785'),
('She works two jobs to make ends meet, at least', '2022-08-17 15:09:09', 'alevis07232'),
('I liked their first two albums but changed my mind after that charity gig.', '2021-12-26 11:16:24', 'alevis07232'),
('As she walked along the street and looked in the gutter she realized facemasks had become the new cigarette butts.', '2022-09-26 11:18:18', 'mgennerich79936'),
('I am happy to take your donation, any amount will be greatly appreciated.', '2022-08-19 03:53:14', 'cmcindrew1q3255'),
('It was the first time he had ever seen someone cook dinner on an elephant.', '2022-10-04 13:14:39', 'kshaylorn1312'),
('Mary plays the piano.', '2022-09-29 16:28:01', 'ibaldrick17354'),
('Tomorrow will bring something new so leave today as a memory.', '2022-05-16 07:23:43', 'rleatherbarrow1v9573'),
('The snow-covered path was no help in finding his way out of the back-country.', '2022-11-15 20:21:21', 'ckitchin2d8651'),
('The quick brown fox jumps over the lazy dog.', '2022-10-28 05:59:00', 'rroote3983'),
('No matter how beautiful the sunset it saddened her knowing she was one day older.', '2022-12-18 20:06:17', 'citzak2q9923'),
('It was her first experience training a rainbow unicorn.', '2022-06-23 13:23:45', 'efrancombe1r3224'),
('A song can make or ruin a persons day if they let it get to them.', '2022-11-07 05:33:51', 'cmcindrew1q3255'),
('I currently have 4 windows open up… and I dont know why.', '2022-10-10 04:07:41', 'tkochsd6968'),
('Pantyhose and heels are an interesting choice of attire for the beach.', '2022-12-05 21:31:29', 'mingilson1f2346'),
('She found his complete dullness interesting.', '2022-11-10 05:22:40', 'zmacallamk9197'),
('If my calculator had a history it would be more embarrassing than my browser history.', '2022-05-06 00:49:26', 'hthickett1o6893'),
('I am happy to take your donation, any amount will be greatly appreciated.', '2022-12-09 09:44:20', 'rgert168644'),
('I would have gotten the promotion but my attendance wasnt good enough.', '2022-05-05 07:31:30', 'ckitchin2d8651'),
('Flesh-colored yoga pants were far worse than even he feared.', '2022-06-30 18:08:45', 'wmaccartney23567'),
('As she walked along the street and looked in the gutter she realized facemasks had become the new cigarette butts.', '2022-04-27 01:58:46', 'gcritzen2g4781'),
('You cant compare apples and oranges but what about bananas and plantains?', '2022-11-29 06:39:25', 'kdyerson33988'),
('Despite multiple complications and her near-death experience', '2022-03-06 02:39:42', 'mschiraki6805'),
('You cant compare apples and oranges but what about bananas and plantains?', '2022-12-09 01:16:46', 'alevis07232'),
('One small action would change her life but whether it would be for better or for worse was yet to be determined.', '2022-10-01 07:50:55', 'rbatterham1d5012'),
('I currently have 4 windows open up… and I dont know why.', '2022-12-27 09:44:56', 'mhouldey1g9925'),
('Combines are no longer just for farms.', '2022-12-08 06:20:30', 'rroote3983'),
('Boulders lined the side of the road foretelling what could come next.', '2022-09-30 22:26:38', 'bhamfleet211535'),
('The dead trees waited to be ignited by the smallest spark and seek their revenge.', '2022-08-18 13:18:06', 'adorcey2n3560'),
('He picked up trash in his spare time to dump in his neighbors yard.', '2022-04-16 13:46:35', 'kpeacockey2070'),
('Most shark attacks occur about 10 feet from the beach since that is where the people are.', '2022-10-14 09:11:31', 'lsillwood231861'),
('8% of 25 is the same as 25% of 8 and one of them is much easier to do in your head.', '2022-09-12 16:44:37', 'bmorrillyh903'),
('The sunblock was handed to the girl before practice but the burned skin was proof she did not apply it.', '2022-12-30 03:17:20', 'mtanswell2c9664'),
('It was her first experience training a rainbow unicorn.', '2022-12-26 23:25:20', 'citzak2q9923'),
('He had concluded that pigs must be able to fly in Hog Heaven.', '2022-08-11 03:37:39', 'bfleckness2i2210'),
('No matter how beautiful the sunset it saddened her knowing she was one day older.', '2022-02-22 04:46:01', 'jgraalmang6123'),
('She wore green lipstick like a fashion icon.', '2022-03-21 02:15:36', 'vdarycott1k8454'),
('The dead trees waited to be ignited by the smallest spark and seek their revenge.', '2022-09-07 20:59:40', 'mhouldey1g9925'),
('I know many children ask for a pony but I wanted a bicycle with rockets strapped to it.', '2022-04-27 00:43:09', 'jchoke1l1707'),
('The sky is clear, the stars are twinkling.', '2022-12-20 18:14:22', 'lcrocetto1s810'),
('If my calculator had a history it would be more embarrassing than my browser history.', '2022-11-22 14:07:48', 'hmahady2a879'),
('He had concluded that pigs must be able to fly in Hog Heaven.', '2022-05-03 16:11:32', 'gmccrillisu1343'),
('Despite multiple complications and her near-death experience', '2022-11-16 02:44:06', 'mgennerich79936'),
('He went on a whiskey diet and immediately lost three days.', '2022-11-11 12:44:14', 'kdyerson33988');

/*       Comment reaction      */

INSERT INTO comment_user_reaction (user_id, comment_id, react_type) 
VALUES 
('bwitherdon1u2772', 1, 'sad'),
('lcrocetto1s810', 1, 'haha' ),
('dlishmanp627', 2, 'love'),
('rcullinan1z9758', 2, 'sad'),
('bsaggers187756', 2, 'like'),
('lmugglestonw8132', 3, 'angry'),
('blamers2p3435', 3, 'haha'),
('jlongthorn1j1884', 3, 'haha'),
('ccuttell2k8806', 4, 'love'),
('fbattersby2r9845', 4, 'haha'),
('jchoke1l1707', 4, 'love'),
('zmacallamk9197', 6, 'like'),
('cmcavey82681', 6, 'like'),
('ibaldrick17354', 7, 'love'),
('efenkel101909', 7, 'sad'),
('bwitherdon1u2772', 10, 'haha'),
('ffoulks11785', 10, 'sad'),
('wmaccartney23567', 11, 'sad'),
('jlongthorn1j1884', 11, 'sad'),
('zmacallamk9197', 14, 'angry'),
('cmcindrew1q3255', 14, 'angry'),
('bsaggers187756', 14, 'angry'),
('rroote3983', 15, 'love'),
('isimeone64503', 15, 'angry'),
('vrigneyl7236', 16, 'haha'),
('zmacallamk9197', 16, 'angry'),
('dcollettm2035', 18, 'haha'),
('rshewz5759', 18, 'love'),
('rrallint138', 19, 'haha'),
('bsaggers187756', 19, 'love'),
('mcussonsv3574', 19, 'love'),
('vdarycott1k8454', 20, 'like'),
('vrigneyl7236', 20, 'sad'),
('lmugglestonw8132', 20, 'angry'),
('bsaggers187756', 21, 'love'),
('vrigneyl7236', 21, 'like'),
('bwitherdon1u2772', 21, 'like'),
('wmaccartney23567', 22, 'angry'),
('tmott1a4762', 22, 'love'),
('jgraalmang6123', 23, 'love'),
('apenvardena5741', 23, 'haha'),
('lcrocetto1s810', 23, 'sad'),
('isimeone64503', 24, 'like'),
('ccuttell2k8806', 24, 'love'),
('citzak2q9923', 24, 'haha'),
('zdu1w5081', 26, 'love'),
('lcrocetto1s810', 27, 'like'),
('ymcbrideb6010', 28, 'haha'),
('rrallint138', 28, 'sad'),
('vrigneyl7236', 28, 'love'),
('bwitherdon1u2772', 29, 'angry'),
('citzak2q9923', 29, 'like'),
('vdarycott1k8454', 29, 'love'),
('mschiraki6805', 30, 'love'),
('tsearlf887', 30, 'sad'),
('dbennionc7305', 31, 'angry'),
('erihanek1b5786', 32, 'sad'),
('efenkel101909', 35, 'like'),
('lmugglestonw8132', 35, 'haha'),
('citzak2q9923', 35, 'like'),
('lmugglestonw8132', 36, 'angry'),
('dlishmanp627', 36, 'haha'),
('adorcey2n3560', 37, 'haha'),
('fbattersby2r9845', 37, 'angry'),
('bsaggers187756', 41, 'sad'),
('efrancombe1r3224', 41, 'like'),
('rshewz5759', 41, 'angry'),
('dbennionc7305', 42, 'like'),
('kpeacockey2070', 42, 'haha'),
('dlishmanp627', 42, 'sad'),
('ccuttell2k8806', 43, 'haha'),
('dbennionc7305', 44, 'sad'),
('vrigneyl7236', 47, 'sad'),
('bsaggers187756', 47, 'love'),
('tbaylayr6742', 48, 'love'),
('apenvardena5741', 49, 'love'),
('apenvardena5741', 52, 'sad'),
('acoursono4141', 52, 'like'),
('lcrocetto1s810', 56, 'like'),
('tmott1a4762', 56, 'sad'),
('lmugglestonw8132', 56, 'love'),
('apenvardena5741', 57, 'love'),
('blamers2p3435', 57, 'haha'),
('dcollettm2035', 58, 'sad'),
('kdyerson33988', 58, 'angry'),
('mschiraki6805', 80, 'haha'),
('mtrowill58157', 80, 'like'),
('wmaccartney23567', 81, 'haha'),
('bnowlan1x613', 82, 'love'),
('citzak2q9923', 83, 'haha'),
('dlishmanp627', 146, 'angry'),
('cmcindrew1q3255', 150, 'haha');


/*       post comment     */

INSERT INTO post_comment (comment_id, post_id) 
VALUES 
(1, 9),
(2, 12),
(3, 24),
(4, 7),
(5, 22),
(6, 8),
(7, 12),
(8, 1),
(9, 2),
(10, 28),
(11, 21),
(12, 2),
(13, 3),
(14, 5),
(15, 17),
(16, 20),
(17, 21),
(18, 9),
(19, 5),
(20, 28),
(21, 14),
(22, 14),
(23, 29),
(24, 4),
(25, 9),
(26, 19),
(27, 27),
(28, 21),
(29, 17),
(30, 22),
(31, 23),
(32, 19),
(33, 3),
(34, 24),
(35, 3),
(36, 14),
(37, 3),
(38, 4),
(39, 10),
(40, 12),
(41, 22),
(42, 28),
(43, 2),
(44, 25),
(45, 25),
(46, 5),
(47, 20),
(48, 30),
(49, 14),
(50, 25),
(51, 10),
(52, 28),
(53, 19),
(54, 10),
(55, 27),
(56, 30),
(57, 20),
(58, 20),
(59, 28),
(60, 20),
(61, 2),
(62, 24),
(63, 4),
(64, 4),
(65, 14),
(66, 9),
(67, 10),
(68, 27),
(69, 30),
(70, 25),
(71, 30),
(72, 27),
(73, 29),
(74, 29);

/*      Comment Reply     */

INSERT INTO comment_reply (reply_id, comment_id) 
VALUES 
(75, 32),
(76, 51),
(77, 5),
(78, 31),
(79, 9),
(80, 39),
(81, 31),
(82, 50),
(83, 26),
(84, 38),
(85, 74),
(86, 54),
(87, 54),
(88, 12),
(89, 20),
(90, 25),
(91, 23),
(92, 30),
(93, 12),
(94, 47),
(95, 38),
(96, 54),
(97, 17),
(98, 50),
(99, 56),
(100, 11),
(101, 61),
(102, 65),
(103, 64),
(104, 31),
(105, 67),
(106, 38),
(107, 11),
(108, 35),
(109, 21),
(110, 25),
(111, 33),
(112, 57),
(113, 17),
(114, 28),
(115, 52),
(116, 47),
(117, 63),
(118, 36),
(119, 33),
(120, 53),
(121, 67),
(122, 16),
(123, 7),
(124, 71),
(125, 61),
(126, 35),
(127, 71),
(128, 42),
(129, 70),
(130, 40),
(131, 26),
(132, 28),
(133, 37),
(134, 57),
(135, 20),
(136, 72),
(137, 47),
(138, 57),
(139, 5),
(140, 72),
(141, 7),
(142, 65),
(143, 11),
(144, 68),
(145, 65),
(146, 12),
(147, 8),
(148, 5),
(149, 16),
(150, 13);

/*        Post reaction       */

INSERT INTO post_user_reaction (user_id, post_id, react_type) 
VALUES 
('alevis07232', 1, 'haha'),
('isimeone64503', 1, 'love'),
('mschiraki6805', 2, 'haha'),
('erihanek1b5786', 2, 'love'),
('rbatterham1d5012', 2, 'love'),
('cmcindrew1q3255', 2, 'haha'),
('nmcavinchey2b8857', 2, 'like'),
('bfleckness2i2210', 2, 'haha'),
('blamers2p3435', 3, 'like'),
('bfleckness2i2210', 3, 'sad'),
('isimeone64503', 3, 'like'),
('mschiraki6805', 3, 'sad'),
('rbatterham1d5012', 3, 'haha'),
('jtumioto262402', 3, 'sad'),
('vdarycott1k8454', 3, 'angry'),
('ckitchin2d8651', 4, 'angry'),
('gcritzen2g4781', 4, 'like'),
('nlowrys2349', 4, 'haha'),
('nlowrys2349', 5, 'haha'),
('kshaylorn1312', 5, 'love'),
('bmorrillyh903', 5, 'like'),
('dfominov197311', 5, 'sad'),
('lgladwell11975', 5, 'sad'),
('ckitchin2d8651', 5, 'haha'),
('lcrocetto1s810', 5, 'love'),
('bmorrillyh903', 6, 'haha'),
('erihanek1b5786', 6, 'haha'),
('jchoke1l1707', 6, 'angry'),
('nlowrys2349', 6, 'like'),
('tmott1a4762', 6, 'angry'),
('mschleicher1p1553', 6, 'like'),
('zdu1w5081', 6, 'haha'),
('ililly228101', 6, 'love'),
('adorcey2n3560', 7, 'love'),
('ahanington27348', 7, 'sad'),
('efenkel101909', 7, 'sad'),
('isimeone64503', 7, 'angry'),
('ffoulks11785', 7, 'haha'),
('vrigneyl7236', 7, 'angry'),
('ssuddock125420', 7, 'haha'),
('mhouldey1g9925', 7, 'haha'),
('mdales1y2744', 7, 'like'),
('ahanington27348', 8, 'love'),
('adorcey2n3560', 8, 'like'),
('gashnessj5870', 8, 'love'),
('wmaccartney23567', 9, 'haha'),
('ililly228101', 9, 'like'),
('rshewz5759', 9, 'haha'),
('wmacdermand1e5059', 9, 'angry'),
('hthickett1o6893', 9, 'love'),
('rcullinan1z9758', 9, 'sad'),
('cbracher247304', 9, 'love'),
('czambonini288433', 10, 'haha'),
('nmcavinchey2b8857', 10, 'haha'),
('hthickett1o6893', 10, 'haha'),
('cmcindrew1q3255', 10, 'haha'),
('fbattersby2r9845', 11, 'love'),
('citzak2q9923', 11, 'love'),
('blamers2p3435', 11, 'haha'),
('adorcey2n3560', 11, 'haha'),
('rwarner2l728', 11, 'love'),
('ccuttell2k8806', 11, 'sad'),
('gcritzen2g4781', 11, 'love'),
('mjellico2f6236', 11, 'love'),
('ililly228101', 12, 'love'),
('bhamfleet211535', 12, 'sad'),
('blangmead207918', 13, 'angry'),
('ahanington27348', 20, 'haha'),
('czambonini288433', 20, 'haha'),
('hmahady2a879', 20, 'love'),
('nmcavinchey2b8857', 20, 'haha'),
('ckitchin2d8651', 20, 'like'),
('mjellico2f6236', 20, 'like'),
('koatley2e3741', 20, 'love'),
('kscouler2h9869', 20, 'like'),
('bfleckness2i2210', 20, 'love'),
('ccuttell2k8806', 21, 'angry'),
('jmulleary2m2116', 21, 'love'),
('adorcey2n3560', 22, 'angry'),
('sjoesbury2o8846', 22, 'like'),
('blamers2p3435', 22, 'haha'),
('citzak2q9923', 22, 'love'),
('fbattersby2r9845', 22, 'like'),
('ffoulks11785', 23, 'love'),
('wmaccartney23567', 23, 'haha'),
('mingilson1f2346', 26, 'haha'),
('mhouldey1g9925', 26, 'sad'),
('mgennerich79936', 26, 'sad'),
('cmcavey82681', 26, 'angry'),
('apenvardena5741', 26, 'sad'),
('dbennionc7305', 26, 'angry'),
('alevis07232', 26, 'angry'),
('caceyq9430', 27, 'sad'),
('blangmead207918', 27, 'like'),
('ililly228101', 27, 'haha'),
('lsillwood231861', 27, 'haha'),
('cbracher247304', 27, 'haha'),
('nhearne258989', 27, 'sad'),
('tradband295267', 27, 'sad'),
('nmcavinchey2b8857', 27, 'haha'),
('mtanswell2c9664', 27, 'haha'),
('mjellico2f6236', 28, 'sad'),
('adorcey2n3560', 28, 'love'),
('lsillwood231861', 28, 'sad'),
('blangmead207918', 28, 'like'),
('dbennionc7305', 28, 'like'),
('fbattersby2r9845', 28, 'sad'),
('mschiraki6805', 28, 'sad'),
('dbennionc7305', 29, 'sad'),
('dlishmanp627', 29, 'like'),
('caceyq9430', 29, 'like'),
('rrallint138', 29, 'haha'),
('lmugglestonw8132', 29, 'like'),
('kpeacockey2070', 29, 'love'),
('lgladwell11975', 30, 'haha'),
('jchoke1l1707', 30, 'haha'),
('jchoke1l1707', 31, 'love'),
('mschiraki6805', 32, 'haha'),
('vdarycott1k8454', 35, 'like'),
('mschiraki6805', 35, 'sad');

/*         Topic          */

INSERT INTO topic (topic_id, topic_title) 
VALUES 
(1, 'Truth or Dare'),
(2, 'Chicken Tenders'),
(3, 'Superheroes'),
(4, 'Pop Art'),
(5, 'Car Theme'),
(6, 'K-Pop Party'),
(7, 'Music'),
(8, 'Espresso Martini'),
(9, 'Education'),
(10, 'Science');

/*       Topic_follower         */

INSERT INTO topic_follower (follower_id, topic_id) 
VALUES 
('alevis07232', 7),
('ffoulks11785', 7),
('wmaccartney23567', 6),
('kdyerson33988', 3),
('csimmonds43327', 2),
('mtrowill58157', 2),
('isimeone64503', 10),
('mgennerich79936', 9),
('cmcavey82681', 2),
('ccurner91113', 2),
('apenvardena5741', 3),
('ymcbrideb6010', 3),
('dbennionc7305', 9),
('tkochsd6968', 6),
('rroote3983', 9),
('tsearlf887', 5),
('jgraalmang6123', 9),
('bmorrillyh903', 10),
('mschiraki6805', 2),
('gashnessj5870', 3),
('zmacallamk9197', 4),
('vrigneyl7236', 4),
('dcollettm2035', 4),
('kshaylorn1312', 2),
('acoursono4141', 6),
('dlishmanp627', 5),
('caceyq9430', 7),
('tbaylayr6742', 7),
('nlowrys2349', 3),
('rrallint138', 4),
('gmccrillisu1343', 7),
('mcussonsv3574', 1),
('lmugglestonw8132', 4),
('hslaytonx2593', 1),
('kpeacockey2070', 9),
('rshewz5759', 7),
('efenkel101909', 10),
('lgladwell11975', 9),
('ssuddock125420', 9),
('bborton134228', 6),
('cbarta146433', 8),
('dtytler151479', 10),
('rgert168644', 8),
('ibaldrick17354', 4),
('bsaggers187756', 5),
('dfominov197311', 1),
('tmott1a4762', 6),
('erihanek1b5786', 2),
('khathaway1c8640', 6),
('rbatterham1d5012', 9),
('wmacdermand1e5059', 6),
('mingilson1f2346', 3),
('mhouldey1g9925', 9),
('lchappelow1h2143', 2),
('ataunton1i8242', 1),
('jlongthorn1j1884', 6),
('vdarycott1k8454', 10),
('jchoke1l1707', 1),
('hcharity1m9672', 7),
('bogormally1n5833', 9),
('hthickett1o6893', 7),
('mschleicher1p1553', 4),
('cmcindrew1q3255', 6),
('efrancombe1r3224', 4),
('lcrocetto1s810', 9),
('jhabgood1t929', 4),
('bwitherdon1u2772', 10),
('rleatherbarrow1v9573', 2),
('zdu1w5081', 9),
('bnowlan1x613', 9),
('mdales1y2744', 1),
('rcullinan1z9758', 3),
('blangmead207918', 8),
('bhamfleet211535', 2),
('ililly228101', 7),
('lsillwood231861', 8),
('cbracher247304', 6),
('nhearne258989', 10),
('jtumioto262402', 1),
('ahanington27348', 2),
('czambonini288433', 7),
('tradband295267', 6),
('hmahady2a879', 2),
('nmcavinchey2b8857', 3),
('mtanswell2c9664', 6),
('ckitchin2d8651', 4),
('koatley2e3741', 4),
('mjellico2f6236', 10),
('gcritzen2g4781', 6),
('kscouler2h9869', 5),
('bfleckness2i2210', 10),
('hklimkiewich2j3172', 10),
('ccuttell2k8806', 9),
('rwarner2l728', 9),
('jmulleary2m2116', 9),
('adorcey2n3560', 1),
('sjoesbury2o8846', 10),
('blamers2p3435', 7),
('citzak2q9923', 7),
('fbattersby2r9845', 10);

/*       topic_post      */

INSERT INTO topic_post (post_id, topic_id) 
VALUES 
(1, 3),
(3, 6),
(5, 10),
(7, 8),
(9, 5),
(11, 10),
(13, 7),
(15, 3),
(17, 7),
(19, 1),
(21, 9),
(23, 8),
(25, 4),
(27, 8),
(29, 2);

