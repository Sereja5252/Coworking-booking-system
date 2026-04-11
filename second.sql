SELECT c.name AS client_name, r.name AS resource_name, b.start_time, b.end_time, b.total_price
FROM BOOKING b
JOIN CLIENT c ON b.client_id = c.client_id
JOIN RESOURCE r ON b.resource_id = r.resource_id
WHERE b.status IN ('confirmed', 'completed')
ORDER BY b.start_time;

SELECT c.name, SUM(p.amount) as total_paid
FROM CLIENT c
JOIN BOOKING b ON c.client_id = b.client_id
JOIN PAYMENT p ON b.booking_id = p.booking_id
WHERE p.status = 'completed'
GROUP BY c.name
ORDER BY total_paid DESC;

SELECT type, name, status 
FROM RESOURCE 
WHERE status = 'maintenance';

SELECT c.name, c.phone, b.start_time, b.total_price
FROM CLIENT c
JOIN BOOKING b ON c.client_id = b.client_id
WHERE b.status = 'pending';

SELECT r.name, t.hourly_rate, t.valid_from, t.valid_to, t.is_active
FROM TARIFF t
JOIN RESOURCE r ON t.resource_id = r.resource_id
WHERE r.name = 'Проектор 4K Epson'
ORDER BY t.valid_from;

WITH ClientTotals AS (
    SELECT c.client_id, c.name, SUM(p.amount) AS total_paid
    FROM CLIENT c
    JOIN BOOKING b ON c.client_id = b.client_id
    JOIN PAYMENT p ON b.booking_id = p.booking_id
    WHERE p.status = 'completed'
    GROUP BY c.client_id, c.name
),
AverageTotal AS (
    SELECT AVG(total_paid) AS avg_all FROM ClientTotals
)
SELECT name, total_paid 
FROM ClientTotals, AverageTotal
WHERE total_paid > avg_all;

WITH RankedBookings AS (
    SELECT c.name, b.start_time, b.total_price,
           ROW_NUMBER() OVER (PARTITION BY c.client_id ORDER BY b.total_price DESC) as rn
    FROM CLIENT c
    JOIN BOOKING b ON c.client_id = b.client_id
)
SELECT name, start_time, total_price
FROM RankedBookings
WHERE rn = 1;

SELECT r.name, r.type
FROM RESOURCE r
WHERE NOT EXISTS (
    SELECT 1 
    FROM BOOKING b 
    WHERE b.resource_id = r.resource_id
);

SELECT r.name,
       SUM(CASE WHEN b.status = 'completed' THEN 1 ELSE 0 END) AS successful_bookings,
       SUM(CASE WHEN b.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings
FROM RESOURCE r
LEFT JOIN BOOKING b ON r.resource_id = b.resource_id
GROUP BY r.name
ORDER BY successful_bookings DESC;


SELECT name, email
FROM CLIENT
WHERE client_id IN (
    SELECT client_id
    FROM BOOKING
    WHERE resource_id = (
        SELECT resource_id
        FROM RESOURCE
        WHERE name = 'Лекционный зал'
    )
);

