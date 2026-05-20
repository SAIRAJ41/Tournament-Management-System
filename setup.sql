CREATE DATABASE IF NOT EXISTS tournamentdb;

USE tournamentdb;

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(50),
    role VARCHAR(20)
);

INSERT IGNORE INTO users(username, password, role)
VALUES ('admin', 'admin123', 'ADMIN');

INSERT IGNORE INTO users(username, password, role)
VALUES ('user', 'user123', 'USER');

CREATE TABLE IF NOT EXISTS tournaments (
    tournament_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    sport VARCHAR(100),
    start_date VARCHAR(50),
    end_date VARCHAR(50),
    venue VARCHAR(100),
    status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_id INT,
    team_name VARCHAR(100),
    captain_name VARCHAR(100),
    contact VARCHAR(20),
    user_id INT
);

CREATE TABLE IF NOT EXISTS matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_id INT,
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    match_date VARCHAR(50),
    match_time VARCHAR(50),
    venue VARCHAR(100),
    result VARCHAR(100),
    winner VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS points_table (
    point_id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_id INT,
    team_name VARCHAR(100),
    played INT DEFAULT 0,
    won INT DEFAULT 0,
    lost INT DEFAULT 0,
    draw INT DEFAULT 0,
    points INT DEFAULT 0
);

-- Run this if the database already exists and teams table lacks user_id:
-- ALTER TABLE teams ADD COLUMN user_id INT;
