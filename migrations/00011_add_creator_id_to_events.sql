-- +goose Up
-- +goose StatementBegin
ALTER TABLE events ADD COLUMN creator_id UUID;
UPDATE events SET creator_id = '00000000-0000-0000-0000-000000000000' WHERE creator_id IS NULL;
ALTER TABLE events ALTER COLUMN creator_id SET NOT NULL;
CREATE INDEX idx_events_creator_id ON events (creator_id);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_events_creator_id;
ALTER TABLE events DROP COLUMN IF EXISTS creator_id;
-- +goose StatementEnd