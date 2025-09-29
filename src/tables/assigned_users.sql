CREATE TABLE rbac.assigned_users
(
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES rbac.users,
    FOREIGN KEY (role_id) REFERENCES rbac.roles
);

SELECT pg_catalog.pg_extension_config_dump('rbac.assigned_users', '');
