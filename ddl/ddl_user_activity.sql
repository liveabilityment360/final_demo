#Cloud sql ddl

CREATE DATABASE IF NOT EXISTS db_liveability;
USE db_liveability;
CREATE TABLE IF NOT EXISTS user_activity (
created_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
details VARCHAR(10) NULL,
name VARCHAR(100) NULL,
email VARCHAR(50)  NULL,
addresses VARCHAR(10) NULL,
current__address VARCHAR(250) NULL,
confirm_current_postcode VARCHAR(10) NULL,
new_address VARCHAR(250) NULL,
confirm_new_postcode VARCHAR(10) NULL,
work_address VARCHAR(250) NULL,
confirm_work_postcode VARCHAR(10) NULL,
user_interests VARCHAR(200) NULL,
thank_you VARCHAR(10) NULL,
current_geo varchar(200)  NULL,
new_geo varchar(200) NULL,
work_geo varchar(200) NULL,
is_active BOOLEAN NOT NULL DEFAULT True
)COMMENT 'This is the user table information/details that gets populated as part of the user data entry process or the usage of the app.';
