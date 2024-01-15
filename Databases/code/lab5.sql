USE Trolldepo;

-- створення тимчасової таблиці через процедуру
DROP PROCEDURE IF EXISTS CreateTempTable;
DELIMITER //
CREATE PROCEDURE CreateTempTable ()
BEGIN
CREATE TABLE temp_table(
	tempID INT PRIMARY KEY AUTO_INCREMENT,
    temp_line VARCHAR(30)
);
END //
DELIMITER ;

Select * from temp_table;


-- якщо у розкладі субота, то буде хороший настрій
DROP PROCEDURE IF EXISTS ifProcedure;
DELIMITER //
CREATE PROCEDURE ifProcedure()
BEGIN
	SELECT scheduleID, start_work,
    IF(weekday = 'Sunday', 'Good mood', 'Lasy day') AS moode
	FROM schedule;
END //
DELIMITER ;

Call ifProcedure;


--  процедура додає нових водіїв з прізвищем "Podoliak" та різними ідентифікаторами водія до таблиці 
DROP PROCEDURE IF EXISTS whileProcedure;
DELIMITER //
CREATE PROCEDURE whileProcedure()
BEGIN
    DECLARE dr_ID INT;
    SET dr_ID = 27;
    WHILE dr_ID < 31 DO
		insert into driver (DriverID, surname) values (dr_ID, CONCAT('Podoliak', dr_ID));
        SET dr_ID = dr_ID+1;
	END WHILE;
END //
DELIMITER ;
Call whileProcedure;

Select * from driver;



-- процедура рахує водіїв
DELIMITER //
CREATE PROCEDURE calcDrivers()
BEGIN
	SELECT COUNT(DriverID) FROM driver;
END //
DELIMITER ;
CALL calcDrivers;



-- видає назву зупинки за номером
DROP PROCEDURE IF EXISTS GetBusStopNameByNumber;
DELIMITER //
CREATE PROCEDURE GetBusStopNameByNumber(IN stopID INT)
BEGIN
    DECLARE stopName VARCHAR(40);

    SELECT bus_stop_name INTO stopName
    FROM bus_stop
    WHERE bus_stopID = stopID;

	SELECT CONCAT('Bus stop name: ', stopName) AS message;
     
END //
DELIMITER ;
CALL GetBusStopNameByNumber(2);


-- рахує кількість зупинок
DROP PROCEDURE IF EXISTS CountBusStopWithReturn;
DELIMITER //
CREATE PROCEDURE CountBusStopWithReturn(OUT count_stop INT)
BEGIN
    SET count_stop = (SELECT COUNT(bus_stopID) FROM bus_stop);
END //
DELIMITER ;
CALL CountBusStopWithReturn(@count_stop);
SELECT @count_stop;


-- перейменування вказаної зупинки
DELIMITER //
CREATE PROCEDURE UpdateBusStopName(IN id INT, IN newName VARCHAR(45))
BEGIN
	UPDATE bus_stop SET bus_stop_name = newName WHERE bus_stopID = id;
END //
DELIMITER ;
CALL UpdateBusStopName(1,"Шулявка");

Select * from bus_stop;


-- показує шлях тролейбуса
DROP PROCEDURE IF EXISTS wayOfTrolleybus;
DELIMITER //
CREATE PROCEDURE wayOfTrolleybus(id VARCHAR(5))
BEGIN
	SELECT * FROM route WHERE route_number IN(	
	SELECT DISTINCT d.route_number FROM driver d, trolleybus t WHERE t.troll_number=d.troll_number AND t.troll_number = id); 
END //
DELIMITER ;
CALL wayOfTrolleybus('T13');




-- функції

-- знаходить загальну кількість пасажирів на маршруті
DELIMITER //
CREATE FUNCTION GetTotalPassengers(routeNumber VARCHAR(20)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE totalPassengers INT;
    SELECT SUM(number_of_passengers)
    INTO totalPassengers
    FROM trolleybus
    WHERE troll_number IN (SELECT troll_number FROM driver WHERE route_number = routeNumber);
    RETURN totalPassengers;
END //
DELIMITER ;
SELECT GetTotalPassengers('Route13') AS TotalPassengers;


-- виводить інформацію про маршрути 
DELIMITER //
CREATE PROCEDURE DynamicTable()
BEGIN
    SET @sql = CONCAT('SELECT * FROM ', 'route');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//
DELIMITER ;

CALL DynamicTable;



-- створює таблицю з водіями та брендом тролейбусу на якому вони працюють
DROP PROCEDURE IF EXISTS driver_and_trolleybus;
DROP TABLE IF EXISTS driver_trolleybus;
DELIMITER //
CREATE PROCEDURE driver_and_trolleybus()
BEGIN
	CREATE TEMPORARY TABLE driver_trolleybus (full_name VARCHAR(90), brand VARCHAR(45));
    INSERT INTO driver_trolleybus SELECT CONCAT(d.first_name,' ',d.surname,' ',d.last_name) AS driver, c.car_brand_name 
        FROM car_brand c, driver d, trolleybus t
        WHERE c.car_brandID = t.car_brandID;
END //
DELIMITER ;
CALL driver_and_trolleybus();
SELECT * FROM driver_trolleybus;



-- cursors

-- створеня курсору для отримання інформації про водіїв та марки транспортних засобів
DROP PROCEDURE IF EXISTS CreateDriverCursor;
DELIMITER //
CREATE PROCEDURE CreateDriverCursor()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE driverName VARCHAR(150);
    DECLARE carBrandName VARCHAR(30);
    DECLARE driverCursor CURSOR FOR
        SELECT CONCAT(d.first_name, ' ', d.last_name, ' ', d.surname) AS driver, c.car_brand_name AS carBrand
        FROM car_brand c, driver d, trolleybus t
        WHERE c.car_brandID = t.car_brandID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN driverCursor;
    CLOSE driverCursor;
END //
DELIMITER ;
CALL CreateDriverCursor;


-- процедура для відкриття курсора
DROP PROCEDURE IF EXISTS OpenDriverCursor;
DELIMITER //
CREATE PROCEDURE OpenDriverCursor()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE driverName VARCHAR(150);
    DECLARE carBrandName VARCHAR(30);
    DECLARE driverCursor CURSOR FOR
        SELECT CONCAT(d.first_name, ' ', d.last_name, ' ', d.surname) AS driver, c.car_brand_name AS carBrand
        FROM car_brand c, driver d, trolleybus t
        WHERE c.car_brandID = t.car_brandID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN driverCursor;

    CLOSE driverCursor;
END //
DELIMITER ;
CALL OpenDriverCursor;


-- процедура яка обирає та виводить дані з курсора
DROP PROCEDURE IF EXISTS SelectDataFromCursor;
DELIMITER //
CREATE PROCEDURE SelectDataFromCursor()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE driverName VARCHAR(150);
    DECLARE carBrandName VARCHAR(30);
    DECLARE driverCursor CURSOR FOR
        SELECT CONCAT(d.first_name, ' ', d.last_name, ' ', d.surname) AS driver, c.car_brand_name AS carBrand
        FROM car_brand c, driver d, trolleybus t
        WHERE c.car_brandID = t.car_brandID;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN driverCursor;
	read_loop: LOOP
        FETCH driverCursor INTO driverName, carBrandName;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Driver: ', driverName, ', Car Brand: ', carBrandName) AS result;
    END LOOP;
    CLOSE driverCursor;
END //
DELIMITER ;
CALL SelectDataFromCursor;


-- triggers

-- таблиця для відслідковування змін
drop table audit_log;
CREATE TABLE audit_log(
    id INT PRIMARY KEY AUTO_INCREMENT,
    DriverID INT,
    time DATETIME,
    action  VARCHAR(20)
);


-- тригер який спрацьовує після видалення
DROP  TRIGGER IF EXISTS driver_after_delete;
DELIMITER //
CREATE TRIGGER driver_after_delete
AFTER DELETE ON driver
FOR EACH ROW
BEGIN
    INSERT INTO audit_log(DriverID, time, action)
    VALUES (OLD.DriverID, NOW(), 'DELETE');
END; //
DELIMITER ;

DELETE FROM driver WHERE DriverID = 22;

Select * from  audit_log;
Select * from  driver;


-- тригер який спрацьовує після зміни
DROP  TRIGGER IF EXISTS driver_after_update;
DELIMITER //
CREATE TRIGGER driver_after_update
AFTER UPDATE ON driver
FOR EACH ROW
BEGIN
    INSERT INTO audit_log(DriverID, time, action)
    VALUES (NEW.DriverID, NOW(), 'UPDATE');
END; //
DELIMITER ;

UPDATE driver SET DriverID = 34 WHERE DriverID = 23;
Select * from  audit_log;
Select * from  driver;



-- тригер який спрацьовує після вставки
DROP  TRIGGER IF EXISTS driver_after_insert;
DELIMITER //
CREATE TRIGGER driver_after_insert
AFTER INSERT ON driver
FOR EACH ROW
BEGIN
    INSERT INTO audit_log(DriverID, time, action)
    VALUES (NEW.DriverID, NOW(), 'INSERT');
END; //
DELIMITER ;

INSERT INTO driver(DriverID, surname)
VALUES (35, 'Gryban');

Select * from audit_log;
