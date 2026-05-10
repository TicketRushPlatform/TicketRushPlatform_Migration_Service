-- +goose Up
-- +goose StatementBegin

-- Junction table: many-to-many between users and role_definitions
CREATE TABLE IF NOT EXISTS user_roles (
  id          uuid         PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     uuid         NOT NULL,
  role_id     uuid         NOT NULL,
  assigned_at timestamptz  NOT NULL DEFAULT now(),
  assigned_by uuid,        -- admin who assigned this role (NULL = system)

  CONSTRAINT fk_user_roles_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_user_roles_role
    FOREIGN KEY (role_id) REFERENCES role_definitions(id) ON DELETE CASCADE,
  CONSTRAINT ux_user_roles_user_role
    UNIQUE (user_id, role_id)
);

CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role_id ON user_roles(role_id);

-- Notifications table (replaces localStorage mock)
CREATE TABLE IF NOT EXISTS notifications (
  id          uuid         PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     uuid         NOT NULL,
  title       varchar(255) NOT NULL,
  message     text         NOT NULL,
  tone        varchar(20)  NOT NULL DEFAULT 'INFO',
  read        boolean      NOT NULL DEFAULT false,
  link        varchar(512),
  created_at  timestamptz  NOT NULL DEFAULT now(),

  CONSTRAINT fk_notifications_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);

-- Seed: assign default PROFILE_OWNER role to all existing users who don't have an assignment
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, rd.id
FROM users u
CROSS JOIN role_definitions rd
WHERE rd.name = 'PROFILE_OWNER'
  AND NOT EXISTS (
    SELECT 1 FROM user_roles ur WHERE ur.user_id = u.id AND ur.role_id = rd.id
  );

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_notifications_created_at;
DROP INDEX IF EXISTS idx_notifications_user_id;
DROP TABLE IF EXISTS notifications;
DROP INDEX IF EXISTS idx_user_roles_role_id;
DROP INDEX IF EXISTS idx_user_roles_user_id;
DROP TABLE IF EXISTS user_roles;
-- +goose StatementEnd
