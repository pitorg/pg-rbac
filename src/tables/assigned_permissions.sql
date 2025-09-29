CREATE TABLE rbac.assigned_permissions
(
    operation_id UUID NOT NULL,
    object_id UUID NOT NULL,
    role_id UUID NOT NULL,
    PRIMARY KEY (operation_id, object_id, role_id),
    FOREIGN KEY (operation_id) REFERENCES rbac.operations,
    FOREIGN KEY (object_id) REFERENCES rbac.objects,
    FOREIGN KEY (role_id) REFERENCES rbac.roles
);

SELECT pg_catalog.pg_extension_config_dump('rbac.assigned_permissions', '');
