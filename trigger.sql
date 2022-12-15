--
--Add trigger for tables
--

DELIMITER $$
CREATE TRIGGER `comment_reply_AFTER_INSERT` 
AFTER INSERT ON `comment_reply` 
FOR EACH ROW 
BEGIN
	update post_comment set reply_count = reply_count + 1 where comment_id = new.reply_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `comment_reply_AFTER_DELETE` 
AFTER DELETE ON `comment_reply` 
FOR EACH ROW 
BEGIN
	update post_comment set reply_count = reply_count - 1 where comment_id = old.reply_id;
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
CREATE TRIGGER `post_comment_AFTER_UPDATE` 
AFTER UPDATE ON `post_comment` 
FOR EACH ROW 
BEGIN
	update post set comment_count = comment_count + new.reply_count - old.reply_count where post_id = new.post_id;
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
	update user set follower_count = follower_count + 1 where user_id = new.follower_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `user_follower_AFTER_DELETE` 
AFTER DELETE ON `user_follower` 
FOR EACH ROW 
BEGIN
	update user set follower_count = follower_count - 1 where user_id = old.follower_id;
END $$
DELIMITER ;

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