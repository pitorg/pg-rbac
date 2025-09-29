CREATE TABLE rbac.sessions
(
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (id, user_id),
    FOREIGN KEY (user_id) REFERENCES rbac.users
);

SELECT pg_catalog.pg_extension_config_dump('rbac.sessions', '');
