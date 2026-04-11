
DROP TABLE IF EXISTS PAYMENT, BOOKING, TARIFF, RESOURCE, CLIENT CASCADE;

CREATE TABLE CLIENT (
    client_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(50)
);

CREATE TABLE RESOURCE (
    resource_id SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'maintenance', 'retired')),
    capacity INT CHECK (capacity >= 0)
);

CREATE TABLE TARIFF (
    tariff_id SERIAL PRIMARY KEY,
    resource_id INT REFERENCES RESOURCE(resource_id),
    hourly_rate DECIMAL(10, 2) NOT NULL CHECK (hourly_rate >= 0),
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE BOOKING (
    booking_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES CLIENT(client_id),
    resource_id INT REFERENCES RESOURCE(resource_id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    total_price DECIMAL(10, 2) CHECK (total_price >= 0)
);

CREATE TABLE PAYMENT (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES BOOKING(booking_id),
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    payment_date TIMESTAMP NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded'))
);

INSERT INTO CLIENT (name, email, phone) VALUES
('Алексей Иванов', 'alex.iv@example.com', '+79001234501'),
('Мария Смирнова', 'maria.sm@example.com', '+79001234502'),
('Иван Петров', 'ivan.p@example.com', '+79001234503'),
('Елена Соколова', 'elena.sok@example.com', '+79001234504'),
('Дмитрий Волков', 'dima.volk@example.com', '+79001234505'),
('Анна Кузнецова', 'anna.k@example.com', '+79001234506'),
('Сергей Морозов', 'serg.moroz@example.com', '+79001234507'),
('Ольга Новикова', 'olga.nov@example.com', '+79001234508'),
('Павел Васильев', 'pavel.vas@example.com', '+79001234509'),
('Екатерина Зайцева', 'katya.z@example.com', '+79001234510'),
('Михаил Павлов', 'misha.pav@example.com', '+79001234511'),
('Наталья Семенова', 'natasha.s@example.com', '+79001234512'),
('Андрей Голубев', 'andrey.gol@example.com', '+79001234513'),
('Татьяна Виноградова', 'tanya.v@example.com', '+79001234514'),
('Виктор Богданов', 'viktor.bog@example.com', '+79001234515'),
('Алина Воробьева', 'alina.vor@example.com', '+79001234516'),
('Роман Федоров', 'roman.fed@example.com', '+79001234517'),
('Юлия Михайлова', 'yulia.mix@example.com', '+79001234518'),
('Игорь Белов', 'igor.belov@example.com', '+79001234519'),
('Дарья Тарасова', 'dasha.tar@example.com', '+79001234520');

INSERT INTO RESOURCE (type, name, status, capacity) VALUES
('Room', 'Переговорка Альфа', 'active', 10),
('Room', 'Переговорка Бета', 'active', 8),
('Room', 'Лекционный зал', 'active', 30),
('Room', 'Комната отдыха', 'active', 15),
('Desk', 'Рабочее место №1', 'active', 1),
('Desk', 'Рабочее место №2', 'active', 1),
('Desk', 'Рабочее место №3', 'active', 1),
('Desk', 'Рабочее место №4', 'active', 1),
('Desk', 'Рабочее место №5', 'maintenance', 1),
('Desk', 'Рабочее место №6', 'active', 1),
('Desk', 'Рабочее место №7', 'active', 1),
('Desk', 'Рабочее место №8', 'active', 1),
('Desk', 'Рабочее место №9', 'active', 1),
('Desk', 'Рабочее место №10', 'active', 1),
('Equipment', 'Проектор 4K Epson', 'active', 0),
('Equipment', 'Проектор BenQ', 'maintenance', 0),
('Equipment', 'Ноутбук Mac Air', 'active', 0),
('Equipment', 'Ноутбук ThinkPad', 'active', 0),
('Equipment', 'Флипчарт', 'active', 0),
('Equipment', 'Колонка JBL', 'active', 0);

INSERT INTO TARIFF (resource_id, hourly_rate, valid_from, valid_to, is_active) VALUES
(1, 800.00, '2025-01-01', '2026-01-01', false), 
(1, 1000.00, '2026-01-01', NULL, true),        
(2, 900.00, '2026-01-01', NULL, true),
(3, 2000.00, '2026-01-01', NULL, true),
(4, 500.00, '2026-01-01', NULL, true),
(5, 200.00, '2026-01-01', NULL, true),
(6, 200.00, '2026-01-01', NULL, true),
(7, 200.00, '2026-01-01', NULL, true),
(8, 200.00, '2026-01-01', NULL, true),
(9, 200.00, '2026-01-01', NULL, true),
(10, 200.00, '2026-01-01', NULL, true),
(11, 200.00, '2026-01-01', NULL, true),
(12, 200.00, '2026-01-01', NULL, true),
(13, 200.00, '2026-01-01', NULL, true),
(14, 200.00, '2026-01-01', NULL, true),
(15, 300.00, '2025-01-01', '2026-03-01', false), 
(15, 400.00, '2026-03-01', NULL, true),          
(16, 300.00, '2026-01-01', NULL, true),
(17, 500.00, '2026-01-01', NULL, true),
(18, 450.00, '2026-01-01', NULL, true),
(19, 100.00, '2026-01-01', NULL, true),
(20, 150.00, '2026-01-01', NULL, true);

INSERT INTO BOOKING (client_id, resource_id, start_time, end_time, status, total_price) VALUES
(1, 1, '2026-04-10 10:00:00', '2026-04-10 12:00:00', 'completed', 2000.00), 
(1, 15, '2026-04-10 10:00:00', '2026-04-10 12:00:00', 'completed', 800.00), 
(1, 5, '2026-04-12 10:00:00', '2026-04-12 18:00:00', 'confirmed', 1600.00), 
(2, 2, '2026-04-11 14:00:00', '2026-04-11 16:00:00', 'completed', 1800.00),
(3, 3, '2026-04-15 09:00:00', '2026-04-15 12:00:00', 'pending', 6000.00),
(4, 6, '2026-04-10 10:00:00', '2026-04-10 20:00:00', 'completed', 2000.00),
(5, 7, '2026-04-14 10:00:00', '2026-04-14 15:00:00', 'cancelled', 1000.00),
(6, 17, '2026-04-16 10:00:00', '2026-04-16 14:00:00', 'confirmed', 2000.00),
(7, 18, '2026-04-17 12:00:00', '2026-04-17 16:00:00', 'confirmed', 1800.00),
(8, 1, '2026-04-18 10:00:00', '2026-04-18 11:00:00', 'pending', 1000.00),
(9, 4, '2026-04-19 18:00:00', '2026-04-19 22:00:00', 'confirmed', 2000.00),
(10, 8, '2026-04-20 09:00:00', '2026-04-20 18:00:00', 'completed', 1800.00),
(11, 10, '2026-04-10 09:00:00', '2026-04-10 18:00:00', 'completed', 1800.00),
(12, 11, '2026-04-11 12:00:00', '2026-04-11 16:00:00', 'completed', 800.00),
(13, 12, '2026-04-12 10:00:00', '2026-04-12 15:00:00', 'completed', 1000.00),
(14, 13, '2026-04-13 14:00:00', '2026-04-13 19:00:00', 'completed', 1000.00),
(15, 14, '2026-04-14 10:00:00', '2026-04-14 18:00:00', 'pending', 1600.00),
(16, 19, '2026-04-15 10:00:00', '2026-04-15 12:00:00', 'confirmed', 200.00),
(17, 20, '2026-04-16 18:00:00', '2026-04-16 22:00:00', 'confirmed', 600.00),
(18, 1, '2026-04-25 10:00:00', '2026-04-25 12:00:00', 'pending', 2000.00),
(19, 2, '2026-04-26 14:00:00', '2026-04-26 16:00:00', 'confirmed', 1800.00),
(20, 3, '2026-04-27 09:00:00', '2026-04-27 12:00:00', 'confirmed', 6000.00),
(2, 15, '2026-04-11 14:00:00', '2026-04-11 16:00:00', 'completed', 800.00),
(3, 19, '2026-04-15 09:00:00', '2026-04-15 12:00:00', 'pending', 300.00),
(4, 20, '2026-04-10 10:00:00', '2026-04-10 20:00:00', 'completed', 1500.00);

INSERT INTO PAYMENT (booking_id, amount, payment_date, status) VALUES
(1, 2000.00, '2026-04-09 10:00:00', 'completed'),
(2, 800.00, '2026-04-09 10:05:00', 'completed'),
(3, 1600.00, '2026-04-11 09:00:00', 'completed'),
(4, 1800.00, '2026-04-10 14:00:00', 'completed'),
(6, 2000.00, '2026-04-09 18:00:00', 'completed'),
(7, 1000.00, '2026-04-13 10:00:00', 'refunded'), 
(8, 2000.00, '2026-04-15 10:00:00', 'completed'),
(9, 1800.00, '2026-04-16 12:00:00', 'completed'),
(11, 2000.00, '2026-04-18 18:00:00', 'completed'),
(12, 1800.00, '2026-04-19 09:00:00', 'completed'),
(13, 1800.00, '2026-04-09 09:00:00', 'completed'),
(14, 800.00, '2026-04-10 12:00:00', 'completed'),
(15, 1000.00, '2026-04-11 10:00:00', 'completed'),
(16, 1000.00, '2026-04-12 14:00:00', 'completed'),
(18, 200.00, '2026-04-14 10:00:00', 'completed'),
(19, 600.00, '2026-04-15 18:00:00', 'completed'),
(21, 1800.00, '2026-04-25 14:00:00', 'completed'),
(22, 6000.00, '2026-04-26 09:00:00', 'completed'),
(23, 800.00, '2026-04-10 14:00:00', 'completed'),
(25, 1500.00, '2026-04-09 10:00:00', 'completed');