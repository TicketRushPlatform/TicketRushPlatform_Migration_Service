-- +goose Up
-- +goose StatementBegin
CREATE TABLE IF NOT EXISTS role_definitions (
  id          uuid         PRIMARY KEY DEFAULT uuid_generate_v4(),
  name        varchar(64)  NOT NULL UNIQUE,
  created_at  timestamptz  NOT NULL DEFAULT now(),
  updated_at  timestamptz  NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_role_definitions_name
  ON role_definitions(name);

CREATE TABLE IF NOT EXISTS role_permissions (
  id          uuid          PRIMARY KEY DEFAULT uuid_generate_v4(),
  role_id     uuid          NOT NULL,
  permission  varchar(128)  NOT NULL,
  created_at  timestamptz   NOT NULL DEFAULT now(),

  CONSTRAINT fk_role_permissions_role
    FOREIGN KEY (role_id) REFERENCES role_definitions(id) ON DELETE CASCADE,
  CONSTRAINT ux_role_permissions_role_permission
    UNIQUE (role_id, permission)
);

CREATE INDEX IF NOT EXISTS idx_role_permissions_role_id
  ON role_permissions(role_id);

INSERT INTO role_definitions (name)
VALUES ('PROFILE_OWNER'), ('EVENT_OWNER'), ('BOOKING_OWNER')
ON CONFLICT (name) DO NOTHING;

INSERT INTO role_permissions (role_id, permission)
SELECT rd.id, p.permission
FROM role_definitions rd
JOIN (
  VALUES
    ('PROFILE_OWNER', 'PROFILE_VIEW'),
    ('PROFILE_OWNER', 'PROFILE_EDIT'),
    ('EVENT_OWNER', 'EVENT_VIEW'),
    ('EVENT_OWNER', 'EVENT_CREATE'),
    ('EVENT_OWNER', 'EVENT_UPDATE'),
    ('EVENT_OWNER', 'EVENT_DELETE'),
    ('BOOKING_OWNER', 'BOOKING_VIEW'),
    ('BOOKING_OWNER', 'BOOKING_CREATE'),
    ('BOOKING_OWNER', 'BOOKING_CONFIRM'),
    ('BOOKING_OWNER', 'BOOKING_CANCEL')
) AS p(role_name, permission)
ON rd.name = p.role_name
ON CONFLICT (role_id, permission) DO NOTHING;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_role_permissions_role_id;
DROP TABLE IF EXISTS role_permissions;
DROP INDEX IF EXISTS idx_role_definitions_name;
DROP TABLE IF EXISTS role_definitions;
-- +goose StatementEnd
