DROP TABLE IF EXISTS coupon_group_histories;
DROP TABLE IF EXISTS coupon_groups;
DROP TABLE IF EXISTS coupons;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id            varchar(50) NOT NULL PRIMARY KEY,
  name          varchar(30) NOT NULL,
  point         int NOT NULL DEFAULT 0,
  created_at    datetime NOT NULL,
  updated_at    datetime
);

CREATE TABLE coupon_groups (
  id            bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  issuer_id     varchar(50) NOT NULL,
  code          varchar(50) NOT NULL,
  name          varchar(50) NOT NULL,
  status        enum('CREATED', 'PUBLISHED', 'DISABLED') NOT NULL,
  amount        int NOT NULL,
  max_count     int NOT NULL,
  current_count int NOT NULL DEFAULT 0,
  valid_from_dt datetime NOT NULL,
  valid_to_dt   datetime NOT NULL,
  created_at    datetime NOT NULL,
  updated_at    datetime,
  UNIQUE KEY unq_coupon_groups_on_code (code)
);

CREATE TABLE coupon_group_histories (
  id            bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  coupon_group_id bigint NOT NULL,
  user_id       varchar(50) NOT NULL,
  data          json NOT NULL,
  created_at    datetime NOT NULL,
  KEY idx_coupon_group_histories_on_coupon_group_id (coupon_group_id)
);

CREATE TABLE coupons (
  id            bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id       varchar(50) NOT NULL,
  code          varchar(50) NOT NULL,
  name          varchar(50) NOT NULL,
  status        enum('ISSUED', 'USED', 'EXPIRED') NOT NULL,
  amount        int NOT NULL,
  valid_from_dt datetime NOT NULL,
  valid_to_dt   datetime NOT NULL,
  used_at       datetime,
  created_at    datetime NOT NULL,
  updated_at    datetime,
  UNIQUE KEY unq_coupons_on_user_id_and_code (user_id, code)
);
