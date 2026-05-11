CREATE OR REPLACE FUNCTION get_hours(p_start TIMESTAMP, p_end TIMESTAMP)
RETURNS NUMERIC
LANGUAGE sql
STABLE
AS $$
    SELECT (EXTRACT(EPOCH FROM (p_end - p_start)) / 3600.0)::NUMERIC;
$$;

CREATE OR REPLACE FUNCTION client_history(p_client_id INT)
RETURNS TABLE (booking_id INT, name VARCHAR, start_time TIMESTAMP, price DECIMAL)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT b.booking_id, r.name, b.start_time, b.total_price
    FROM BOOKING b
    JOIN RESOURCE r ON b.resource_id = r.resource_id
    WHERE b.client_id = p_client_id
    ORDER BY b.start_time DESC;
END;
$$;

CREATE OR REPLACE PROCEDURE update_price(p_res_id INT, p_new_rate DECIMAL)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE TARIFF SET valid_to = CURRENT_TIMESTAMP, is_active = false
    WHERE resource_id = p_res_id AND is_active = true;

    INSERT INTO TARIFF (resource_id, hourly_rate, valid_from, valid_to, is_active)
    VALUES (p_res_id, p_new_rate, CURRENT_TIMESTAMP, NULL, true);
END;
$$;