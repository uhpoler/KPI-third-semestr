-- Підрахунок кількості автобусних зупинок для кожного маршруту
SELECT route_number, COUNT(bus_stopID) AS num_bus_stops
FROM bus_stop_list
GROUP BY route_number;



-- Підрахунок загальної кількості пасажирів на всіх тролейбусах
SELECT SUM(number_of_passengers) AS total_passengers
FROM trolleybus;



-- Підрахунок кількості тролейбусів для кожної марки та країни виробника
SELECT car_brand_name, producing_country, COUNT(troll_number) AS num_trolleybuses
FROM trolleybus
JOIN car_brand ON trolleybus.car_brandID = car_brand.car_brandID
GROUP BY car_brand_name, producing_country;


-- Пошук маршрутів, де кількість зупинок більше 1
SELECT route_number, COUNT(bus_stopID) AS num_bus_stops
FROM bus_stop_list
GROUP BY route_number
HAVING num_bus_stops > 1;




-- Пошук тролейбусів, які мають більше 30 пасажирів та доступ до Wi-Fi
SELECT troll_number, number_of_passengers
FROM trolleybus
WHERE number_of_passengers > 30 AND wifi_available = TRUE;



-- Нумерація рядків для водіїв з сортуванням за прізвищем у зростаючому порядку
-- Присвоює унікальний номер кожному рядку в межах вікна
SELECT *, ROW_NUMBER() OVER (ORDER BY last_name) AS row_num
FROM driver;


-- Сортування тролейбусів за кількістю пасажирів у спадаючому порядку, а потім за датою останньої інспекції
SELECT troll_number, number_of_passengers, date_last_tech_insp
FROM trolleybus
ORDER BY number_of_passengers DESC, date_last_tech_insp;


-- Створення представлення, що містить дані з декількох таблиць
DROP VIEW  combined_data;
CREATE VIEW combined_data AS
SELECT d.DriverID, d.last_name, d.first_name, d.troll_number, r.route_number
FROM driver d
JOIN route r ON d.route_number = r.route_number;

Select * from combined_data;


-- Створення представлення, що містить дані з декількох таблиць та використовує інше представлення
DROP VIEW  extended_combined_data;
CREATE VIEW extended_combined_data AS
SELECT cd.*, bs.bus_stop_name
FROM combined_data cd
JOIN bus_stop_list bsl ON cd.route_number = bsl.route_number
JOIN bus_stop bs ON bsl.bus_stopID = bs.bus_stopID;

Select * from extended_combined_data;

-- Модифікація представлення, додавання нового стовпця
ALTER VIEW combined_data AS
SELECT d.DriverID, d.last_name, d.first_name, d.troll_number, r.route_number, s.weekday
FROM driver d
JOIN route r ON d.route_number = r.route_number
JOIN schedule s ON d.scheduleID = s.scheduleID;

Select * from combined_data;



-- Використання вбудованої процедури для отримання інформації про представлення
SHOW CREATE VIEW combined_data;
SHOW CREATE VIEW extended_combined_data;


DESCRIBE combined_data;
DESCRIBE extended_combined_data;







-- запити-----------------
-- Знаходження маршрутів з найбільшою кількістю тролейбусів
SELECT route_number, COUNT(troll_number) AS num_trolleybuses
FROM driver
GROUP BY route_number
ORDER BY num_trolleybuses DESC
LIMIT 1;


-- Знаходження зупиноки з найбільшою кількістю тролейбусних маршрутів
SELECT bs.bus_stopID, bs.bus_stop_name, COUNT(DISTINCT bsl.route_number) AS num_routes
FROM bus_stop_list bsl
JOIN bus_stop bs ON bsl.bus_stopID = bs.bus_stopID
GROUP BY bs.bus_stopID, bs.bus_stop_name
ORDER BY num_routes DESC
LIMIT 1;


