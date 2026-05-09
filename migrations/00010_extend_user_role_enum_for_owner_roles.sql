-- +goose Up
-- +goose StatementBegin
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
    CREATE TYPE user_role AS ENUM ('USER', 'ADMIN', 'PROFILE_OWNER', 'EVENT_OWNER', 'BOOKING_OWNER');
  ELSE
    ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'PROFILE_OWNER';
    ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'EVENT_OWNER';
    ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'BOOKING_OWNER';
  END IF;
END$$;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- Enum value removal is intentionally skipped for safety.
SELECT 1;
-- +goose StatementEnd
