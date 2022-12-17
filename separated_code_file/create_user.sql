-- First, we create a user name 'bao' on the 'localhost'
CREATE USER 'bao'@'localhost'
IDENTIFIED BY '123456789';
-- Then, we grant create, alter and drop privileges on all table to this user
GRANT CREATE, ALTER, DROP
ON *.*
TO 'bao'@'localhost';

-- We can create another user name 'hung' on the 'localhost'
-- and give him the right to create users login and reset passwords
CREATE USER 'hung'@'localhost'
IDENTIFIED BY '987654321';
GRANT CREATE USER, RELOAD
ON *.*
TO 'hung'@'localhost';

-- Or we can create another user name 'hoang' on the 'localhost'
-- and give him full right on all databases (superuser)
CREATE USER 'hoang'@'localhost'
IDENTIFIED BY '159753';
GRANT ALL
ON *.*
TO 'hoang'@'localhost';