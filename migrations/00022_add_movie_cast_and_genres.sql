-- +goose Up
-- +goose StatementBegin
ALTER TABLE events
  ADD COLUMN IF NOT EXISTS movie_cast JSONB NOT NULL DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS movie_cast_members JSONB NOT NULL DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS movie_genres JSONB NOT NULL DEFAULT '[]'::jsonb;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
ALTER TABLE events
  DROP COLUMN IF EXISTS movie_genres,
  DROP COLUMN IF EXISTS movie_cast_members,
  DROP COLUMN IF EXISTS movie_cast;
-- +goose StatementEnd
