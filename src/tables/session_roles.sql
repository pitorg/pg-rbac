CREATE TABLE rbac.session_roles
(
    session_id UUID NOT NULL,
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    PRIMARY KEY (session_id, role_id),
    FOREIGN KEY (session_id, user_id) REFERENCES rbac.sessions (id, user_id),
    FOREIGN KEY (user_id, role_id) REFERENCES rbac.assigned_users (user_id, role_id)
);

SELECT pg_catalog.pg_extension_config_dump('rbac.session_roles', '');
