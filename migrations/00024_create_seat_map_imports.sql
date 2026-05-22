-- +goose Up
-- +goose StatementBegin
CREATE TABLE seat_map_imports (
  id                uuid        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           uuid        NOT NULL,
  source_image_url  TEXT        NOT NULL,
  provider          TEXT        NOT NULL,
  model             TEXT        NOT NULL,
  image_type        TEXT        NOT NULL,
  confidence        numeric(5,4) NOT NULL DEFAULT 0,
  warnings          jsonb       NOT NULL DEFAULT '[]'::jsonb,
  normalized_layout jsonb       NOT NULL,
  raw_response      jsonb       NOT NULL,
  status            TEXT        NOT NULL DEFAULT 'DRAFT',
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL,
  deleted_at        timestamptz,

  CONSTRAINT fk_seat_map_imports_user
    FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT chk_seat_map_imports_status
    CHECK (status IN ('DRAFT', 'FAILED'))
);

CREATE INDEX idx_seat_map_imports_user_created
  ON seat_map_imports(user_id, created_at DESC);

ALTER TABLE seat_maps
  ADD COLUMN source_image_url TEXT,
  ADD COLUMN recognition_import_id uuid,
  ADD COLUMN recognition_confidence numeric(5,4);

ALTER TABLE seat_maps
  ADD CONSTRAINT fk_seat_maps_recognition_import
  FOREIGN KEY (recognition_import_id) REFERENCES seat_map_imports(id);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
ALTER TABLE seat_maps
  DROP CONSTRAINT IF EXISTS fk_seat_maps_recognition_import;

ALTER TABLE seat_maps
  DROP COLUMN IF EXISTS recognition_confidence,
  DROP COLUMN IF EXISTS recognition_import_id,
  DROP COLUMN IF EXISTS source_image_url;

DROP INDEX IF EXISTS idx_seat_map_imports_user_created;
DROP TABLE IF EXISTS seat_map_imports;
-- +goose StatementEnd
