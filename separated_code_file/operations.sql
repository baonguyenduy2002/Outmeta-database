-- get followers of the manager of group "HCMUT Group"
SELECT
    `user_follower`.follower_id
FROM `group` JOIN `user_follower`
ON `group`.manager_id = `user_follower`.user_id
WHERE `group`.group_name = "HCMUT GROUP";

-- get detail info of all group managers 
SELECT
    `group`.group_name,
    `user`.user_id,
    password,
    description,
    name,
    address,
    dob,
    phone_number,
    email,
    follower_count
FROM `user` JOIN `group`
ON `group`.manager_id = `user`.user_id;

-- update adorcey2n3560's password
UPDATE `user`
	SET
		`user`.password = 'new_password'
	WHERE
		`user`.user_id = 'adorcey2n3560';

-- get all posts belong to topic superheroes

SELECT 
    post.post_id, 
    post_datetime, 
    post_content, 
    post_media, 
    comment_count, 
    react_count, 
    writer_id
FROM post, topic_post
WHERE post.post_id = topic_post.post_id AND
			topic_post.topic_id = 3;

-- List all comments to posts created by ymcbrideb6010 
SELECT
    `comment`.comment_id,
    `comment`.comment_content,
    `comment`.comment_datetime,
    `comment`.react_count,
    `comment`.writer_id,
FROM `comment` JOIN `post_comment`
ON `comment`.comment_id = `post_comment`.comment_id
JOIN `post`
ON `post`.post_id = `post_comment`.post_id
WHERE `post`.writer_id = "ymcbrideb6010";