

INSERT INTO car_brand (car_brand_name, manufacture_year, producing_country, technical_characteristics)
VALUES
    ('Богдан', 2022, 'Japan', 'Hybrid, Advanced Safety Features'),
    ('Ford', 2021, 'USA', 'Fuel-Efficient, EcoBoost Engine'),
    ('Богдан', 2020, 'Japan', 'Reliable, Fuel-Efficient'),
    ('BMW', 2022, 'Germany', 'Luxury, Performance-oriented'),
    ('Богдан', 2021, 'USA', 'Diverse Model Range'),
    ('Mercedes-Benz', 2020, 'Germany', 'Elegance, Advanced Technology'),
    ('Богдан', 2022, 'South Korea', 'Affordable, Good Warranty'),
    ('Богдан', 2021, 'Japan', 'Innovative Technology'),
    ('Богдан', 2020, 'Germany', 'Premium Design, Advanced Tech'),
    ('Богдан', 2022, 'South Korea', 'Value for Money, Warranty');
    
INSERT INTO trolleybus (troll_number, car_brandID, number_of_passengers, date_last_tech_insp, wifi_available)
VALUES
    ('T4', 1, 35, '2022-05-15', TRUE),
    ('T5', 2, 28, '2021-07-20', FALSE),
    ('T6', 3, 22, '2020-10-10', TRUE),
    ('T7', 4, 30, '2022-01-05', FALSE),
    ('T8', 5, 25, '2021-03-25', TRUE),
    ('T9', 6, 32, '2020-06-30', TRUE),
    ('T10', 7, 18, '2022-02-12', FALSE),
    ('T11', 8, 27, '2021-08-15', TRUE),
    ('T12', 9, 29, '2020-11-20', FALSE),
    ('T13', 10, 23, '2022-04-02', TRUE);



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
    ('Політехнічний інститут'),
    ('Житомирська');
    
 INSERT INTO route (route_number, start_time, end_time, starting_point, end_point, route_duration)
VALUES
    ('Route4', '08:30:00', '09:30:00', 'Central Station', 'City Square',  '01:00:00'),
    ('Route5', '09:45:00', '11:00:00',  'Житомирська', 'Park View',  '01:15:00'),
    ('Route6', '10:30:00', '12:00:00', 'Політехнічний інститут', 'Ocean View',  '01:30:00'),
    ('Route7', '11:00:00', '12:30:00', 'Park View', 'Політехнічний інститут',  '01:30:00'),
    ('Route8', '12:00:00', '13:15:00', 'Житомирська', 'Політехнічний інститут',  '01:15:00'),
    ('Route9', '13:30:00', '15:00:00', 'City Square', 'Житомирська',  '01:30:00'),
    ('Route10', '14:00:00', '15:30:00', 'Політехнічний інститут', 'Mountain Top',  '01:30:00'),
    ('Route11', '15:15:00', '16:30:00', 'Житомирська', 'Central Station',  '01:15:00'),
    ('Route12', '16:00:00', '17:00:00', 'Central Station', 'Політехнічний інститут',  '01:00:00'),
    ('Route13', '17:30:00', '18:30:00', 'University Campus', 'Житомирська', '01:00:00');   
    
    
    
INSERT INTO bus_stop_list (bus_stopID, route_number)
VALUES
    (1, 'Route4'),
    (2, 'Route4'),
	(3, 'Route5'),
	(10, 'Route5'),
	(6, 'Route6'),
	(9, 'Route6'),
	(3, 'Route7'),
	(9, 'Route7'),
	(9, 'Route8'),
	(10, 'Route8'),
	(2, 'Route9'),
	(10, 'Route9'),
	(9, 'Route10'),
	(7, 'Route10'),
	(1, 'Route11'),
	(10, 'Route11'),
	(1, 'Route12'),
	(9, 'Route12'),
    (5, 'Route13'),
	(10, 'Route13');

    


INSERT INTO driver (roll_number, last_name, first_name, surname, date_of_birth, scheduleID, troll_number, route_number)
VALUES
    (136, 'Smith', 'John', 'Doe', '1993-04-01', 4, 'T4', 'Route4'),
    (137, 'Johnson', 'Emily', 'Williams', '1994-05-01', 5, 'T5', 'Route5'),
    (138, 'Brown', 'Michael', 'Jones', '1995-06-01', 6, 'T6', 'Route6'),
    (139, 'Miller', 'Emma', 'Davis', '1996-07-01', 7, 'T7', 'Route7'),
    (140, 'Davis', 'Christopher', 'Martinez', '1997-08-01', 8, 'T8', 'Route8'),
    (141, 'Garcia', 'Sophia', 'Smith', '1998-09-01', 9, 'T9', 'Route9'),
    (142, 'Rodriguez', 'Jacob', 'Taylor', '1999-10-01', 10, 'T10', 'Route10'),
    (143, 'Martinez', 'Olivia', 'Brown', '2000-11-01', 1, 'T11', 'Route11'),
    (144, 'Jones', 'Daniel', 'Johnson', '2001-12-01', 2, 'T12', 'Route12'),
    (145, 'Taylor', 'Ava', 'Garcia', '2002-01-01', 3, 'T13', 'Route13');
    