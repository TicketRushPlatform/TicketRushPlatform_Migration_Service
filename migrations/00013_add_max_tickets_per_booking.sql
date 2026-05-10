-- +goose Up
-- Add max_tickets_per_booking column to events table
ALTER TABLE events ADD COLUMN IF NOT EXISTS max_tickets_per_booking INTEGER DEFAULT NULL;

COMMENT ON COLUMN events.max_tickets_per_booking IS 'Maximum number of tickets a user can book per showtime for this event. NULL means unlimited.';

-- +goose Down
ALTER TABLE events DROP COLUMN IF EXISTS max_tickets_per_booking;
