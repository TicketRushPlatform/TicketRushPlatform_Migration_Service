-- +goose Up
-- +goose StatementBegin
WITH duplicate_active_seat_maps AS (
  SELECT
    id,
    name,
    ROW_NUMBER() OVER (
      PARTITION BY name
      ORDER BY created_at, id
    ) AS duplicate_number
  FROM seat_maps
  WHERE deleted_at IS NULL
)
UPDATE seat_maps sm
SET
  name = duplicate_active_seat_maps.name || ' (' || sm.id::text || ')',
  updated_at = now()
FROM duplicate_active_seat_maps
WHERE sm.id = duplicate_active_seat_maps.id
  AND duplicate_active_seat_maps.duplicate_number > 1;

CREATE UNIQUE INDEX IF NOT EXISTS uq_seat_maps_name
  ON seat_maps (name)
  WHERE deleted_at IS NULL;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS uq_seat_maps_name;
-- +goose StatementEnd
