-- +goose Up
-- +goose StatementBegin
-- Delete old system roles which cascades to role_permissions and user_roles
DELETE FROM role_definitions 
WHERE name IN ('PROFILE_OWNER', 'EVENT_OWNER', 'BOOKING_OWNER');

-- Insert new system roles
INSERT INTO role_definitions (name)
VALUES ('ORGANIZER'), ('ADMIN')
ON CONFLICT (name) DO NOTHING;

-- Insert simplified permissions
INSERT INTO role_permissions (role_id, permission)
SELECT rd.id, p.permission
FROM role_definitions rd
JOIN (
  VALUES
    ('ORGANIZER', 'EVENT_CREATE'),
    ('ADMIN', 'EVENT_MANAGE_ALL'),
    ('ADMIN', 'USER_MANAGE_ALL')
) AS p(role_name, permission)
ON rd.name = p.role_name
ON CONFLICT (role_id, permission) DO NOTHING;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DELETE FROM role_definitions 
WHERE name IN ('ORGANIZER', 'ADMIN');
-- +goose StatementEnd
