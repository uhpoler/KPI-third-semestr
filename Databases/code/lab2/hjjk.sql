USE Aeroport;

DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS passenger_check;
DROP TABLE IF EXISTS passenger;
DROP TABLE IF EXISTS plane;
DROP TABLE IF EXISTS route;
DROP TABLE IF EXISTS baggage;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS characteristic;
DROP TABLE IF EXISTS employee;


CREATE TABLE employee(
	employeeID INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50),
    emp_lastname VARCHAR(50),
    emp_surname VARCHAR(50),
    date_of_birth DATE
);


CREATE TABLE characteristic (
    characteristicID INT PRIMARY KEY AUTO_INCREMENT,
    brand VARCHAR(50),
    date_last_tech_insp DATE,
    producing_country VARCHAR(30)
);


CREATE TABLE schedule (
    scheduleID INT PRIMARY KEY AUTO_INCREMENT,
    schedule_date DATE,
    departure_time Time,
    arrival_time Time
);

CREATE TABLE city (
    cityID INT PRIMARY KEY AUTO_INCREMENT,
    city_name VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE baggage (
    baggageID INT PRIMARY KEY AUTO_INCREMENT,
    weight INT,
    type VARCHAR(50),
    registration_date DATE
);

CREATE TABLE route (
    routeID INT PRIMARY KEY AUTO_INCREMENT,
    scheduleID INT,
    starting_pointID INT,
    end_pointID INT,
    duration INT,
    FOREIGN KEY (scheduleID) REFERENCES schedule(scheduleID),
    FOREIGN KEY (starting_pointID) REFERENCES city(cityID),
    FOREIGN KEY (end_pointID) REFERENCES city(cityID)
);

CREATE TABLE plane (
    planeID INT PRIMARY KEY AUTO_INCREMENT,
    carrying_capacity  INT,
    max_number_of_passengers INT,
    characteristicID INT,
    routeID INT,
    FOREIGN KEY (characteristicID) REFERENCES characteristic(characteristicID),
    FOREIGN KEY (routeID) REFERENCES route(routeID),
	CHECK (max_number_of_passengers > 1)
);

CREATE TABLE passenger (
    passengerID INT PRIMARY KEY AUTO_INCREMENT,
    baggageID INT,
    pas_name VARCHAR(50),
    pas_lastname VARCHAR(50),
    pas_surname VARCHAR(50),
    passport_number INT(9),
    citizenship VARCHAR(50),
    FOREIGN KEY (baggageID) REFERENCES baggage(baggageID)
);


CREATE TABLE passenger_check (
    passenger_checkID INT PRIMARY KEY AUTO_INCREMENT,
    passengerID INT,
    baggageID INT,
    employeeID INT,
    check_result BOOLEAN,
    FOREIGN KEY (passengerID) REFERENCES passenger(passengerID),
    FOREIGN KEY (baggageID) REFERENCES baggage(baggageID),
    FOREIGN KEY (employeeID) REFERENCES employee(employeeID)
);

CREATE TABLE booking (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    passengerID INT,
    baggageID INT,
    routeID INT,
    booking_date DATE,
    booking_time TIME,
    FOREIGN KEY (passengerID) REFERENCES passenger(passengerID),
    FOREIGN KEY (baggageID) REFERENCES baggage(baggageID),
    FOREIGN KEY (routeID) REFERENCES route(routeID)
);



