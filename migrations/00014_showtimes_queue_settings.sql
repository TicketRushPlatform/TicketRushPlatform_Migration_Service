-- +goose Up
ALTER TABLE show_times ADD COLUMN IF NOT EXISTS queue_enabled BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE show_times ADD COLUMN IF NOT EXISTS queue_limit INTEGER NOT NULL DEFAULT 50;

-- +goose Down
ALTER TABLE show_times DROP COLUMN IF EXISTS queue_limit;
ALTER TABLE show_times DROP COLUMN IF EXISTS queue_enabled;
