-- +goose Up
-- +goose StatementBegin
-- Update any existing users with legacy roles back to standard 'USER' role
-- This prevents SQLAlchemy from crashing when fetching users with removed Enum values
UPDATE users 
SET role = 'USER' 
WHERE role IN ('PROFILE_OWNER', 'EVENT_OWNER', 'BOOKING_OWNER');
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
