CREATE TABLE rbac.users
(
    id UUID NOT NULL,
    PRIMARY KEY (id)
);

SELECT pg_catalog.pg_extension_config_dump('rbac.users', '');
