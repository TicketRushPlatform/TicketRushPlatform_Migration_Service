-- +goose Up
-- +goose StatementBegin
CREATE UNIQUE INDEX uq_seat_maps_name
  ON seat_maps (name)
  WHERE deleted_at IS NULL;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS uq_seat_maps_name;
-- +goose StatementEnd
