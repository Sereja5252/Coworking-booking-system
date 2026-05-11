CREATE OR REPLACE FUNCTION check_busy()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM BOOKING
    WHERE resource_id = NEW.resource_id
      AND status IN ('pending', 'confirmed')
      AND booking_id IS DISTINCT FROM NEW.booking_id
      AND NEW.start_time < end_time 
      AND NEW.end_time > start_time;

    IF v_count > 0 THEN
        RAISE EXCEPTION 'Ресурс занят';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_busy
BEFORE INSERT OR UPDATE ON BOOKING
FOR EACH ROW EXECUTE FUNCTION check_busy();


CREATE OR REPLACE FUNCTION calc_total()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_rate DECIMAL;
    v_hours NUMERIC;
BEGIN
    IF NEW.total_price IS NOT NULL THEN
        RETURN NEW;
    END IF;

    SELECT hourly_rate INTO v_rate
    FROM TARIFF
    WHERE resource_id = NEW.resource_id AND is_active = true;

    v_hours := get_hours(NEW.start_time, NEW.end_time);
    NEW.total_price := v_rate * v_hours;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_total
BEFORE INSERT ON BOOKING
FOR EACH ROW EXECUTE FUNCTION calc_total();