-- При створенні перевірочних обмежень використати апарат збережених процедур/функцій.
DROP PROCEDURE IF EXISTS Check_Ticket_Availability;
DELIMITER //
CREATE PROCEDURE Check_Ticket_Availability(IN ticket_id INT)
BEGIN
    DECLARE ticket_count INT;
    DECLARE booking_count INT;
    SELECT COUNT(*) INTO ticket_count FROM Ticket WHERE Ticket_ID = ticket_id;
    SELECT COUNT(*) INTO booking_count FROM Booking WHERE Ticket_ID = ticket_id;
    IF ticket_count = 0 THEN
        SELECT 'Цей квиток недоступний для бронювання' AS message;
    ELSEIF booking_count > 0 THEN
        SELECT 'Цей квиток вже заброньований' AS message;
    ELSE
        SELECT 'Квиток доступний для бронювання' AS message;
    END IF;
END;//
DELIMITER ;

CALL Check_Ticket_Availability(5);


-- Один пасажир може одночасно забронювати  Для підтримки цілісності використати тригер
або купити не більше чотирьох квитків
DELIMITER //
CREATE TRIGGER CheckTicketLimit 
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE ticket_count INT;
    SELECT COUNT(*) INTO ticket_count 
    FROM Booking 
    WHERE Passenger_First_Name = NEW.Passenger_First_Name AND Passenger_Last_Name = NEW.Passenger_Last_Name;
    IF ticket_count >= 4 THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One passenger can book or buy no more than four tickets at the same time.';
    END IF;
END;//
DELIMITER ;



-- отримання звіту "Касова відомість" за вказаний місяць із вказанням дати, № маршруту кількості проданих квитків, сумарної вартості проданих квитків. 
DELIMITER //
CREATE PROCEDURE CashReport(IN month INT, IN year INT)
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE a INT;
  DECLARE b INT;
  DECLARE c DECIMAL(6, 2);
  DECLARE cur CURSOR FOR 
    SELECT Route_ID, COUNT(*), SUM(Cost) 
    FROM Ticket 
    WHERE MONTH(Departure_Date) = month AND YEAR(Departure_Date) = year
    GROUP BY Route_ID;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO a, b, c;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SELECT a AS 'Route Number', b AS 'Number of Tickets Sold', c AS 'Total Value of Tickets Sold';
  END LOOP;

  CLOSE cur;
END; //
DELIMITER ;

CALL CashReport(12, 2023);


-- 4а
WITH RECURSIVE route_path (Departure_Station, Arrival_Station, Route_ID, path, depth) AS (
    SELECT Departure_Station, Arrival_Station, Route_ID, CONCAT(Departure_Station, '->', Arrival_Station), 1
    FROM Route
    WHERE Departure_Station = 'Київ'
    UNION ALL
    SELECT route_path.Departure_Station, Route.Arrival_Station, Route.Route_ID, CONCAT(route_path.path, '->', Route.Arrival_Station), route_path.depth + 1
    FROM route_path
    JOIN Route ON route_path.Arrival_Station = Route.Departure_Station
    WHERE route_path.path NOT LIKE CONCAT('%', Route.Arrival_Station, '%')
)
SELECT path
FROM route_path
WHERE Arrival_Station = 'Львів'
ORDER BY depth;



-- 4b
SELECT Route_ID, COUNT(*) as Count
FROM Ticket
WHERE Departure_Station = 'Київ' AND Departure_Date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY Route_ID
ORDER BY Count DESC
LIMIT 1;

-- 4c
SELECT COUNT(*) as Count
FROM Schedule
JOIN Route ON Schedule.Route_ID = Route.Route_ID
JOIN Station_List ON Route.Route_ID = Station_List.Route_ID
WHERE Arrival_Station = 'Дніпро' AND Departure_Date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY Schedule.Route_ID
ORDER BY COUNT(Station_List.Station_ID) ASC
LIMIT 1;

-- 4d
SELECT MONTH(Departure_Date) as Month, COUNT(*) as Count
FROM Ticket
JOIN Booking ON Ticket.Ticket_ID = Booking.Ticket_ID
WHERE Passenger_First_Name LIKE '%ел%' AND Departure_Date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
GROUP BY Month;



