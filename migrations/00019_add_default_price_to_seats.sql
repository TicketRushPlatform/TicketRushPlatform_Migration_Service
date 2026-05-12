-- +goose Up
-- +goose StatementBegin
ALTER TABLE seats
  ADD COLUMN default_price numeric(10,2);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
ALTER TABLE seats
  DROP COLUMN IF EXISTS default_price;
-- +goose StatementEnd
