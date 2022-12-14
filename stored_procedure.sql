-- procedure for sort top 50 posts base on interaction point (react + comment)
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


-- procedure for sort top 3 most commented posts in current week
DROP PROCEDURE IF EXISTS sortWeekMostCommentPost;
DELIMITER $$
CREATE PROCEDURE sortWeekMostCommentPost()
BEGIN
    SELECT  *, COUNT(comment.comment_id) AS week_comment_count
    FROM    post, 
            post_comment, 
            comment_reply,
            comment       
    WHERE   comment.comment_id = post_comment.comment_id
        AND comment.comment_id = comment_reply.reply_id
        AND post.post_id = post_comment.post_id 
        AND post_comment.comment_id = comment_reply.comment_id
        AND comment.comment_datetime > SUBDATE(CURDATE(), weekday(CURDATE()))
        AND comment.comment_datetime < CURDATE()
	GROUP BY comment.comment_id
    ORDER BY week_comment_count DESC
    LIMIT 3;
END $$
DELIMITER ;


-- procedure for sort top 3 most commented group posts in current week
DROP PROCEDURE IF EXISTS sortWeekMostCommentGroupPost;
DELIMITER $$
CREATE PROCEDURE sortWeekMostCommentGroupPost()
BEGIN
    SELECT  *, COUNT(comment.comment_id) AS week_comment_count
    FROM    post, 
            post_comment, 
            comment_reply,
            comment,
            group_post       
    WHERE   comment.comment_id = post_comment.comment_id
        AND comment.comment_id = comment_reply.reply_id
        AND post.post_id = post_comment.post_id 
        AND post_comment.comment_id = comment_reply.comment_id
        AND comment.comment_datetime > SUBDATE(CURDATE(), weekday(CURDATE()))
        AND comment.comment_datetime < CURDATE()
        AND post.post_id = group_post.post_id
	GROUP BY comment.comment_id
    ORDER BY week_comment_count DESC
    LIMIT 3;
END $$
DELIMITER ;


-- procedure for sort top 3 most commented topic posts in current week
DROP PROCEDURE IF EXISTS sortWeekMostCommentTopicPost;
DELIMITER $$
CREATE PROCEDURE sortWeekMostCommentTopicPost() 
BEGIN
    SELECT  *, COUNT(comment.comment_id) AS week_comment_count
    FROM    post, 
            post_comment, 
            comment_reply,
            comment,
            topic_post     
    WHERE   comment.comment_id = post_comment.comment_id
        AND comment.comment_id = comment_reply.reply_id
        AND post.post_id = post_comment.post_id 
        AND post_comment.comment_id = comment_reply.comment_id
        AND comment.comment_datetime > SUBDATE(CURDATE(), weekday(CURDATE()))
        AND comment.comment_datetime < CURDATE()
        AND post.post_id = topic_post.post_id
	GROUP BY comment.comment_id
    ORDER BY week_comment_count DESC
    LIMIT 3;
END $$
DELIMITER ;


-- procedure for sort top 3 most commented personal posts in current week
DROP PROCEDURE IF EXISTS sortWeekMostCommentPersonalPost;
DELIMITER $$
CREATE PROCEDURE sortWeekMostCommentPersonalPost()
BEGIN
    SELECT  *, COUNT(comment.comment_id) AS week_comment_count
    FROM    post, 
            post_comment, 
            comment_reply,
            comment,
            topic_post,
            personal_post   
    WHERE   comment.comment_id = post_comment.comment_id
        AND comment.comment_id = comment_reply.reply_id
        AND post.post_id = post_comment.post_id 
        AND post_comment.comment_id = comment_reply.comment_id
        AND comment.comment_datetime > SUBDATE(CURDATE(), weekday(CURDATE()))
        AND comment.comment_datetime < CURDATE()
        AND post.post_id = topic_post.post_id
        AND post.post_id = personal_post.post_id 
        AND personal_post.privacy = 'PUBLIC'
	GROUP BY comment.comment_id
    ORDER BY week_comment_count DESC
    LIMIT 3;
END $$
DELIMITER ;


-- procedure for sort top 50 followed topic
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
DROP PROCEDURE IF EXISTS sortTop50MemberGroup;
DELIMITER $$
CREATE PROCEDURE sortTop50MemberGroup()
BEGIN
    SELECT  *
    FROM    group
    ORDER BY member_count DESC
    LIMIT 50;
END $$
DELIMITER ;
