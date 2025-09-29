CREATE TABLE rbac.operations
(
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name)
);

SELECT pg_catalog.pg_extension_config_dump('rbac.operations', '');
