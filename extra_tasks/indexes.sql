CREATE INDEX idx_pending ON BOOKING(client_id)
WHERE status = 'pending';

CREATE INDEX idx_res_time ON BOOKING(resource_id, start_time);