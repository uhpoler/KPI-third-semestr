SET foreign_key_checks = 0;
DROP TABLE IF EXISTS `Transport`;
DROP TABLE IF EXISTS `Route`;
DROP TABLE IF EXISTS `Station_List`;
DROP TABLE IF EXISTS `Station`;
DROP TABLE IF EXISTS `Schedule`;
DROP TABLE IF EXISTS `Ticket`;
DROP TABLE IF EXISTS `Booking`;
SET foreign_key_checks = 1;


USE BusStation;

CREATE TABLE Transport (
    Transport_ID INT PRIMARY KEY AUTO_INCREMENT, 
    Type ENUM('RouteTaxi', 'Bus') NOT NULL,
    License_Plate VARCHAR(255) NOT NULL,
    Seat_Count INT CHECK (Seat_Count > 0),
    Driver VARCHAR(255) NOT NULL
);

CREATE TABLE Station (
    Station_ID INT PRIMARY KEY AUTO_INCREMENT,
    Station_Name VARCHAR(255) NOT NULL
);

CREATE TABLE Route (
    Route_ID INT PRIMARY KEY AUTO_INCREMENT,
    Departure_Station VARCHAR(255) NOT NULL,
    Arrival_Station VARCHAR(255) NOT NULL
);


CREATE TABLE Station_List (
    Station_List_ID INT PRIMARY KEY AUTO_INCREMENT,
    Station_ID INT,
    Route_ID INT,
    FOREIGN KEY (Station_ID) REFERENCES Station(Station_ID),
    FOREIGN KEY (Route_ID) REFERENCES Route(Route_ID)
);


CREATE TABLE Schedule (
    Schedule_ID INT PRIMARY KEY AUTO_INCREMENT,
    Route_ID INT,
    Departure_Date DATE NOT NULL,
    Departure_Time TIME NOT NULL,
    Arrival_Time TIME NOT NULL,
    FOREIGN KEY (Route_ID) REFERENCES Route(Route_ID)
);

CREATE TABLE Ticket (
    Ticket_ID INT PRIMARY KEY AUTO_INCREMENT,
    Transport_ID INT,
    Route_ID INT,
    Seat_Number INT CHECK (Seat_Number > 0),
    Departure_Date DATE NOT NULL,
    Departure_Time TIME NOT NULL,
    Cost DECIMAL(6, 2) CHECK (Cost >= 0),
    Departure_Station VARCHAR(255) NOT NULL,
    Arrival_Station VARCHAR(255) NOT NULL,
    FOREIGN KEY (Transport_ID) REFERENCES Transport(Transport_ID),
    FOREIGN KEY (Route_ID) REFERENCES Route(Route_ID)
);

CREATE TABLE Booking (
    Booking_ID INT PRIMARY KEY AUTO_INCREMENT,
    Ticket_ID INT UNIQUE,
    Passenger_First_Name VARCHAR(255) NOT NULL,
    Passenger_Last_Name VARCHAR(255) NOT NULL,
    Booking_Code VARCHAR(255) NOT NULL,
    FOREIGN KEY (Ticket_ID) REFERENCES Ticket(Ticket_ID)
);
