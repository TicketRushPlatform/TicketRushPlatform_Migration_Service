-- +goose Up
-- +goose StatementBegin
-- Tự động cấp quyền ORGANIZER cho các user đã từng tạo sự kiện (creator_id) 
-- để đảm bảo họ không bị mất quyền tạo/quản lý event sau khi refactor.
INSERT INTO user_roles (user_id, role_id)
SELECT DISTINCT e.creator_id, rd.id
FROM events e
CROSS JOIN role_definitions rd
WHERE rd.name = 'ORGANIZER'
  AND e.creator_id != '00000000-0000-0000-0000-000000000000'
  AND NOT EXISTS (
    SELECT 1 FROM user_roles ur 
    WHERE ur.user_id = e.creator_id AND ur.role_id = rd.id
  );
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
