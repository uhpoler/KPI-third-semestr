SELECT * FROM trolleybus WHERE number_of_passengers > 25;
SELECT * FROM trolleybus WHERE number_of_passengers > 25 AND wifi_available = TRUE;
SELECT * FROM trolleybus WHERE number_of_passengers > 30 OR wifi_available = 1;
SELECT * FROM trolleybus WHERE NOT (number_of_passengers < 20 OR troll_number = 'T11');

SELECT troll_number, number_of_passengers, 
       CASE WHEN wifi_available THEN 'Available' ELSE 'Not Available' END AS wifi_status
FROM trolleybus;

SELECT * FROM schedule WHERE weekday IN ('Monday', 'Wednesday', 'Friday');
SELECT * FROM trolleybus WHERE date_last_tech_insp BETWEEN '2020-11-20' AND '2021-07-20';
SELECT * FROM bus_stop WHERE bus_stop_name LIKE '%View%';
SELECT * FROM trolleybus WHERE date_last_tech_insp IS NULL;




-- a. Вибірка тролейбусів зі змінною, яка показує, чи має марка "B" у своєму імені
SELECT  car_brand_name, 
       (SELECT CASE WHEN car_brand_name LIKE '%B%' THEN 'Yes' ELSE 'No' END) AS has_B_in_name
FROM car_brand;

-- b. Вибірка тролейбусів з вайфаєм
SELECT troll_number, car_brand_name
FROM trolleybus, car_brand
WHERE EXISTS (
    SELECT 1
    FROM car_brand
    WHERE trolleybus.car_brandID = car_brand.car_brandID
    AND trolleybus.wifi_available = TRUE
);

-- b. Вибірка тролейбусів з країн виготовлення
SELECT troll_number, producing_country
FROM trolleybus, car_brand
WHERE trolleybus.car_brandID IN (
    SELECT car_brandID
    FROM car_brand
    WHERE producing_country IN ('Germany', 'USA')
);

-- c. Декартовий добуток між тролейбусами та маршрутами
SELECT troll_number, route_number FROM trolleybus, route;

-- d. З'єднання тролейбусів із марками автомобілів за рівністю назви марки
SELECT t.troll_number, t.car_brandID, c.technical_characteristics
FROM trolleybus t
JOIN car_brand c ON t.car_brandID = c.car_brandID;

-- e. З'єднання тролейбусів із марками автомобілів та вибірка лише тих, де кількість пасажирів більше 25
SELECT t.troll_number, t.car_brandID, c.technical_characteristics
FROM trolleybus t
JOIN car_brand c ON t.car_brandID = c.car_brandID
WHERE t.number_of_passengers > 25;

-- f. Внутрішнє з'єднання між розкладом і водіями за спільним ключем scheduleID
SELECT d.DriverID, d.last_name, d.first_name, s.weekday
FROM driver d
JOIN schedule s ON d.scheduleID = s.scheduleID;

-- g. Ліве зовнішнє з'єднання між розкладом і водіями за спільним ключем scheduleID
SELECT d.DriverID, d.last_name, d.first_name, s.weekday
FROM driver d
LEFT JOIN schedule s ON d.scheduleID = s.scheduleID;

-- h. Праве зовнішнє з'єднання між розкладом і водіями за спільним ключем scheduleID
SELECT d.DriverID, d.last_name, d.first_name, s.weekday
FROM driver d
RIGHT JOIN schedule s ON d.scheduleID = s.scheduleID;

-- i. Об'єднання розкладів для понеділка та водіїв з їхніми прізвищами
SELECT start_work, end_work FROM schedule
UNION
SELECT last_name, first_name FROM driver;



DESCRIBE  bus_stop;
DESCRIBE bus_stop_list;
DESCRIBE car_brand;
DESCRIBE driver;
DESCRIBE route;
DESCRIBE schedule;
DESCRIBE trolleybus;



-- Визначить тролейбуси марки «Богдан», котрі працюють на маршрутах, в переліку зупинок яких є зупинка «Політехнічний інститут». 
SELECT DISTINCT t.troll_number, cb.car_brand_name
FROM driver d
JOIN trolleybus t ON d.troll_number = t.troll_number
JOIN car_brand cb ON t.car_brandID = cb.car_brandID
JOIN route r ON d.route_number = r.route_number
JOIN bus_stop_list bsl ON r.route_number = bsl.route_number
JOIN bus_stop bs ON bsl.bus_stopID = bs.bus_stopID
WHERE cb.car_brand_name = 'Богдан' AND bs.bus_stop_name = 'Політехнічний інститут';


-- напряму
SELECT DISTINCT r.route_number AS direct_route, r.start_time, r.end_time, r.starting_point, r.end_point FROM route r
WHERE r.starting_point = 'Житомирська' AND r.end_point = 'Політехнічний інститут';

-- напряму
SELECT r.route_number
FROM route r
JOIN bus_stop_list bsl1 ON r.route_number = bsl1.route_number
JOIN bus_stop bs1 ON bsl1.bus_stopID = bs1.bus_stopID
JOIN bus_stop_list bsl2 ON r.route_number = bsl2.route_number
JOIN bus_stop bs2 ON bsl2.bus_stopID = bs2.bus_stopID
WHERE bs1.bus_stop_name = 'Житомирська' AND bs2.bus_stop_name = 'Політехнічний інститут';


-- з пересадкою
SELECT r1.route_number AS 'first_route', r2.route_number AS 'second_route'
FROM route r1
JOIN route r2 ON r1.end_point = r2.starting_point
WHERE r1.starting_point = 'Житомирська' AND r2.end_point = 'Політехнічний інститут';




Select * from route;
Select * from driver;
Select * from bus_stop;
Select * from bus_stop_list;
Select * from car_brand;
Select * from trolleybus;

