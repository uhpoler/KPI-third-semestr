

CREATE DATABASE TrollDepo;
USE TrollDepo;
CREATE TABLE car_brand(
	car_brandID INT PRIMARY KEY AUTO_INCREMENT,
    car_brand_name VARCHAR(30),
    manufacture_year YEAR, 
    producing_country VARCHAR(30),
    technical_characteristics VARCHAR(100)
);

CREATE TABLE trolleybus(
	troll_number VARCHAR(10) PRIMARY KEY,
    car_brandID  INT,
    FOREIGN KEY (car_brandID) REFERENCES car_brand(car_brandID),
    number_of_passengers INT,
    date_last_tech_insp DATE,
    wifi_available BOOLEAN DEFAULT TRUE
    
);


CREATE TABLE schedule(
	scheduleID INT PRIMARY KEY AUTO_INCREMENT,
    start_work TIME,
    end_work TIME,
    weekday VARCHAR(20)
);


CREATE TABLE bus_stop(
    bus_stopID INT PRIMARY KEY AUTO_INCREMENT,
    bus_stop_name VARCHAR(40)
);

CREATE TABLE route(
    route_number VARCHAR(20) PRIMARY KEY,
	start_time TIME,
	end_time TIME,
    starting_point VARCHAR(50),
    end_point VARCHAR(50),
    route_duration TIME
);

CREATE TABLE bus_stop_list(
    list_of_bus_stopID INT PRIMARY KEY AUTO_INCREMENT,
    bus_stopID INT,
    FOREIGN KEY (bus_stopID) REFERENCES bus_stop(bus_stopID),
    route_number VARCHAR(20),
    FOREIGN KEY (route_number) REFERENCES route(route_number)
);


CREATE TABLE driver(
	DriverID INT PRIMARY KEY AUTO_INCREMENT,
    roll_number INT,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    surname VARCHAR(50),
    date_of_birth DATE,
    scheduleID INT,
    FOREIGN KEY (scheduleID) REFERENCES schedule(scheduleID),
    troll_number VARCHAR(10),
    FOREIGN KEY (troll_number) REFERENCES trolleybus(troll_number),
    route_number  VARCHAR(20),
    FOREIGN KEY (route_number) REFERENCES route(route_number)
);

SET foreign_key_checks = 0;
DROP TABLE IF EXISTS `bus_stop`;
DROP TABLE IF EXISTS `bus_stop_list`;
DROP TABLE IF EXISTS `car_brand`;
DROP TABLE IF EXISTS `driver`;
DROP TABLE IF EXISTS `route`;
DROP TABLE IF EXISTS `schedule`;
DROP TABLE IF EXISTS `trolleybus`;
SET foreign_key_checks = 1;



