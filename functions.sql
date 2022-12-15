USE `outmeta`;

DROP function IF EXISTS `add_post`;
DELIMITER $$
CREATE FUNCTION `add_post`(add_post_id INT, add_post_content VARCHAR(1000), add_post_media BLOB, add_writer_id VARCHAR(25)) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	INSERT INTO post (post_id, post_datetime, post_content, post_media, writer_id)
    VALUES (add_post_id, current_timestamp(), add_post_content, add_post_media, add_writer_id);
RETURN TRUE;
END$$
DELIMITER;


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
DELIMITER;

DROP function IF EXISTS `change_manager`;
DELIMITER $$
CREATE FUNCTION `change_manager`(user_id varchar(25), group_manager_id INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	IF (SELECT COUNT(*) FROM `group` WHERE `group`.group_id = group_manager_id)
    THEN
		UPDATE `group`
		SET
			`group`.manager_id = user_id
		WHERE
			`group`.group_id = group_manager_id;
		RETURN TRUE;
    ELSE
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Group not found in group table';
	END IF;
END$$
DELIMITER;

/* Add new user */
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
    THEN --TRUE
		RETURN "DUPLICATED user_id";
	ELSE --FALSE
		INSERT INTO `user` (user_id, password, description, name, address, dob, phone_number, email) 
        VALUES 
        (new_user_id, new_password, new_description, new_name, new_address, new_dob, new_phoneno, new_email);
        RETURN "SUCCESSFUL";
	END IF;
END$$
DELIMITER;

/* Change_user_info */
DROP function IF EXISTS `change_user_info`;
DELIMITER $$
CREATE FUNCTION change_user_info ( --modifies infomation of the given userid
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
	THEN --TRUE
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
	ELSE --FALSE
		RETURN "USER NOT FOUND";
END IF;
END$$
DELIMITER;
