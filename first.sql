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
('Алексей Иванов', 'alex@example.com', '+79991234567'),
('Мария Смирнова', 'maria@example.com', '+79997654321');

INSERT INTO RESOURCE (type, name, status, capacity) VALUES
('Room', 'Переговорка №1', 'active', 10),
('Desk', 'Рабочее место №5', 'active', 1);

INSERT INTO TARIFF (resource_id, hourly_rate, valid_from, valid_to, is_active) VALUES
(1, 1000.00, '2026-01-01 00:00:00', NULL, true),
(2, 300.00, '2026-01-01 00:00:00', NULL, true);

INSERT INTO BOOKING (client_id, resource_id, start_time, end_time, status, total_price) VALUES
(1, 1, '2026-04-10 14:00:00', '2026-04-10 16:00:00', 'confirmed', 2000.00),
(2, 2, '2026-04-11 10:00:00', '2026-04-11 18:00:00', 'pending', 2400.00);

INSERT INTO PAYMENT (booking_id, amount, payment_date, status) VALUES
(1, 2000.00, '2026-04-09 15:30:00', 'completed');