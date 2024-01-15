CREATE DATABASE TrollDepo;
USE TrollDepo;
CREATE TABLE car_brand(
    car_brand_name VARCHAR(30) PRIMARY KEY,
    manufacture_year YEAR, 
    producing_country VARCHAR(30),
    technical_characteristics VARCHAR(50)
);

CREATE TABLE trolleybus(
	troll_number VARCHAR(10) PRIMARY KEY,
    car_brand_name  VARCHAR(30),
    FOREIGN KEY (car_brand_name) REFERENCES car_brand(car_brand_name),
    number_of_passengers INT,
    date_last_tech_insp DATE
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


CREATE TABLE list_of_bus_stop(
    list_of_bus_stopID INT PRIMARY KEY AUTO_INCREMENT,
    bus_stopID INT,
    FOREIGN KEY (bus_stopID) REFERENCES bus_stop(bus_stopID)
);

CREATE TABLE route(
    route_number VARCHAR(20) PRIMARY KEY,
	start_time TIME,
	end_time TIME,
    starting_point VARCHAR(50),
    end_point VARCHAR(50),
    list_of_bus_stopID INT,
    FOREIGN KEY (list_of_bus_stopID) REFERENCES list_of_bus_stop(list_of_bus_stopID),
    route_duration TIME
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

ALTER TABLE car_brand
MODIFY COLUMN technical_characteristics VARCHAR(100);

ALTER TABLE trolleybus
ADD COLUMN wifi_available BOOLEAN;

ALTER TABLE trolleybus
MODIFY COLUMN wifi_available BOOLEAN DEFAULT TRUE;

RENAME TABLE list_of_bus_stop TO bus_stop_list;

ALTER TABLE bus_stop
MODIFY COLUMN bus_stop_name VARCHAR(40) NOT NULL;

ALTER TABLE trolleybus
ADD CHECK (number_of_passengers > 0);

ALTER TABLE bus_stop
ADD CONSTRAINT unique_bus_stop_name UNIQUE (bus_stop_name);

CREATE TABLE employee(
    employeeID INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(50),
    position VARCHAR(30),
    hire_date DATE
);


ALTER TABLE employee
DROP COLUMN  position;

DROP TABLE IF EXISTS employee;



CREATE ROLE AdministratorRole; 
CREATE ROLE DriverRole; 

GRANT USAGE ON *.* TO AdministratorRole;
GRANT USAGE ON *.* TO DriverRole;

GRANT USAGE ON TrollDepo.* TO AdministratorRole;
GRANT USAGE ON TrollDepo.* TO DriverRole;


GRANT SELECT, INSERT, UPDATE, DELETE ON TrollDepo.* TO AdministratorRole;
GRANT CREATE, ALTER, DROP ON TrollDepo.* TO AdministratorRole;
GRANT SELECT, UPDATE ON TrollDepo.* TO DriverRole;


CREATE USER admin_user IDENTIFIED BY 'admin_password';
CREATE USER driver_user IDENTIFIED BY 'driver_password';

GRANT AdministratorRole TO admin_user;
GRANT DriverRole TO driver_user;


INSERT INTO car_brand (car_brand_name, manufacture_year, producing_country, technical_characteristics)
VALUES
    ('Toyota', 2022, 'Japan', 'Hybrid, Advanced Safety Features'),
    ('Ford', 2021, 'USA', 'Fuel-Efficient, EcoBoost Engine'),
    ('Honda', 2020, 'Japan', 'Reliable, Fuel-Efficient'),
    ('BMW', 2022, 'Germany', 'Luxury, Performance-oriented'),
    ('Chevrolet', 2021, 'USA', 'Diverse Model Range'),
    ('Mercedes-Benz', 2020, 'Germany', 'Elegance, Advanced Technology'),
    ('Hyundai', 2022, 'South Korea', 'Affordable, Good Warranty'),
    ('Nissan', 2021, 'Japan', 'Innovative Technology'),
    ('Audi', 2020, 'Germany', 'Premium Design, Advanced Tech'),
    ('Kia', 2022, 'South Korea', 'Value for Money, Warranty');
    
INSERT INTO trolleybus (troll_number, car_brand_name, number_of_passengers, date_last_tech_insp, wifi_available)
VALUES
    ('T4', 'Toyota', 35, '2022-05-15', TRUE),
    ('T5', 'Ford', 28, '2021-07-20', FALSE),
    ('T6', 'Honda', 22, '2020-10-10', TRUE),
    ('T7', 'BMW', 30, '2022-01-05', FALSE),
    ('T8', 'Chevrolet', 25, '2021-03-25', TRUE),
    ('T9', 'Mercedes-Benz', 32, '2020-06-30', TRUE),
    ('T10', 'Hyundai', 18, '2022-02-12', FALSE),
    ('T11', 'Nissan', 27, '2021-08-15', TRUE),
    ('T12', 'Audi', 29, '2020-11-20', FALSE),
    ('T13', 'Kia', 23, '2022-04-02', TRUE);



INSERT INTO schedule (start_work, end_work, weekday)
VALUES
    ('08:00:00', '17:00:00', 'Monday'),
    ('09:00:00', '18:00:00', 'Tuesday'),
    ('10:00:00', '19:00:00', 'Wednesday'),
    ('07:30:00', '16:30:00', 'Thursday'),
    ('09:30:00', '18:30:00', 'Friday'),
    ('08:00:00', '16:00:00', 'Saturday'),
    ('10:30:00', '19:30:00', 'Sunday'),
    ('08:30:00', '17:30:00', 'Monday'),
    ('09:00:00', '18:00:00', 'Wednesday'),
    ('10:30:00', '20:30:00', 'Friday');


INSERT INTO bus_stop (bus_stop_name)
VALUES
    ('Central Station'),
    ('City Square'),
    ('Park View'),
    ('Market Street'),
    ('University Campus'),
    ('Ocean View'),
    ('Mountain Top'),
    ('Sunset Boulevard'),
    ('Riverside Park'),
    ('Green Valley');
    
    
INSERT INTO bus_stop_list (bus_stopID)
VALUES
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10);


INSERT INTO route (route_number, start_time, end_time, starting_point, end_point, list_of_bus_stopID, route_duration)
VALUES
    ('Route4', '08:30:00', '09:30:00', 'Central Station', 'City Square', 4, '01:00:00'),
    ('Route5', '09:45:00', '11:00:00', 'Park View', 'Market Street', 5, '01:15:00'),
    ('Route6', '10:30:00', '12:00:00', 'University Campus', 'Ocean View', 6, '01:30:00'),
    ('Route7', '11:00:00', '12:30:00', 'Mountain Top', 'Sunset Boulevard', 7, '01:30:00'),
    ('Route8', '12:00:00', '13:15:00', 'City Square', 'Riverside Park', 8, '01:15:00'),
    ('Route9', '13:30:00', '15:00:00', 'Green Valley', 'Central Station', 9, '01:30:00'),
    ('Route10', '14:00:00', '15:30:00', 'Ocean View', 'Mountain Top', 10, '01:30:00'),
    ('Route11', '15:15:00', '16:30:00', 'Sunset Boulevard', 'Riverside Park', 1, '01:15:00'),
    ('Route12', '16:00:00', '17:00:00', 'University Campus', 'Green Valley', 2, '01:00:00'),
    ('Route13', '17:30:00', '18:30:00', 'Market Street', 'Park View', 3, '01:00:00');

INSERT INTO driver (roll_number, last_name, first_name, surname, date_of_birth, scheduleID, troll_number, route_number)
VALUES
    (136, 'Smith', 'John', 'Doe', '1993-04-01', 4, 'T4', 'Route4'),
    (137, 'Johnson', 'Emily', 'Williams', '1994-05-01', 5, 'T5', 'Route5'),
    (138, 'Brown', 'Michael', 'Jones', '1995-06-01', 6, 'T6', 'Route6'),
    (139, 'Miller', 'Emma', 'Davis', '1996-07-01', 7, 'T7', 'Route7'),
    (140, 'Davis', 'Christopher', 'Martinez', '1997-08-01', 8, 'T8', 'Route8'),
    (141, 'Garcia', 'Sophia', 'Smith', '1998-09-01', 9, 'T9', 'Route9'),
    (142, 'Rodriguez', 'Jacob', 'Taylor', '1999-10-01', 10, 'T10', 'Route10city'),
    (143, 'Martinez', 'Olivia', 'Brown', '2000-11-01', 1, 'T11', 'Route11'),
    (144, 'Jones', 'Daniel', 'Johnson', '2001-12-01', 2, 'T12', 'Route12'),
    (145, 'Taylor', 'Ava', 'Garcia', '2002-01-01', 3, 'T13', 'Route13');
    
USE TrollDepo; 
Select * from bus_stop;
    
Select * from driver;



CREATE USER 'devuser'@'%' IDENTIFIED BY 'devuser';

GRANT ALL PRIVILEGES ON * . * TO 'devuser'@'%';




select * from route;
select * from schedule;

INSERT INTO schedule(start_work, end_work, weekday)
VALUES
('07:08:00', '09:00:00', 'Sunday');
