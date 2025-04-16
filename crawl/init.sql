CREATE DATABASE IF NOT EXISTS law_service;
GRANT ALL PRIVILEGES ON law_service.* TO 'auth_user'@'%' IDENTIFIED BY 'auth_password';
FLUSH PRIVILEGES;