USE `outmeta`;

--View get detail follower
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
DELIMITER;

--View get detail users that given user_id is following
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
DELIMITER;

--View detail topics that a user is following

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
DELIMITER;

DROP procedure IF EXISTS `view_group_user`;
DELIMITER $$
CREATE PROCEDURE `view_group_user`(user_id VARCHAR(25))
BEGIN
	SELECT *
    FROM `group`, group_member
    WHERE 	`group`.group_id = group_member.group_id AND
			group_member.member_id = user_id;
END$$
DELIMITER;

DROP PROCEDURE IF EXISTS `view_post_group`;
DELIMITER $$
CREATE PROCEDURE `view_post_group`(group_id INT)
BEGIN
	SELECT post.post_id, post_datetime, post_content, post_media, comment_count, react_count, writer_id
    FROM post, group_post
    WHERE 	post.post_id = group_post.post_id AND
			group_post.group_id = group_id;
END$$
DELIMITER;

DROP PROCEDURE IF EXISTS `view_post_topic`;
DELIMITER $$
CREATE PROCEDURE `view_post_topic`(topic_id INT)
BEGIN
	SELECT post.post_id, post_datetime, post_content, post_media, comment_count, react_count, writer_id
    FROM post, topic_post
    WHERE 	post.post_id = topic_post.post_id AND
			topic_post.topic_id = topic_id;
END$$
DELIMITER;

DROP procedure IF EXISTS `view_post_user`;
DELIMITER $$
CREATE PROCEDURE `view_post_user`(user_id VARCHAR(25))
BEGIN
	SELECT *
    FROM post
    WHERE writer_id = user_id;
END$$
DELIMITER;
