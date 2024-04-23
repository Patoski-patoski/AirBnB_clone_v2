-- script that prepares a MySQL server
CREATE DATABASE IF NOT EXISTS hbnb_dev_db;
CREATE USER IF NOT EXISTS 'hbnb_dev'@'localhost' IDENTIFIED BY 'p4Christ+';
GRANT SELECT ON hbnb_dev_db.*  TO 'hbnb_dev' @'localhost';
FLUSH PRIVILEGES;