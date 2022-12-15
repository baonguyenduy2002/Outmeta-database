USE `outmeta`;
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