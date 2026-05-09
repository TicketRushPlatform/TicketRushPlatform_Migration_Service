-- +goose Up
-- +goose StatementBegin
CREATE TABLE IF NOT EXISTS booking_items (
  id                uuid          PRIMARY KEY DEFAULT uuid_generate_v4(),

  booking_id        uuid          NOT NULL,
  show_time_seat_id uuid          NOT NULL,
  price             numeric(10,2) NOT NULL,

  created_at        timestamptz   NOT NULL DEFAULT now(),
  updated_at        timestamptz   NOT NULL DEFAULT now(),
  deleted_at        timestamptz,

  CONSTRAINT fk_booking_items_booking
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
  CONSTRAINT fk_booking_items_show_time_seat
    FOREIGN KEY (show_time_seat_id) REFERENCES show_time_seats(id),

  CONSTRAINT unique_booking_seat
    UNIQUE (booking_id, show_time_seat_id),

  CONSTRAINT chk_booking_items_price_positive
    CHECK (price > 0)
);

CREATE INDEX IF NOT EXISTS idx_bi_booking
  ON booking_items(booking_id)
  WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_bi_showtime_seat
  ON booking_items(show_time_seat_id)
  WHERE deleted_at IS NULL;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_bi_showtime_seat;
DROP INDEX IF EXISTS idx_bi_booking;
DROP TABLE IF EXISTS booking_items;
-- +goose StatementEnd
