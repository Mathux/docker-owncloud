CREATE USER 'owncloud'@'localhost' IDENTIFIED BY 'db_user_password';
CREATE DATABASE IF NOT EXISTS owncloud;
GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'localhost' IDENTIFIED BY 'db_user_password';
