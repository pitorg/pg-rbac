CREATE OR REPLACE FUNCTION rbac.session_permissions(session_id UUID)
RETURNS TABLE
(
    operation_id UUID,
    operation_name TEXT,
    object_id UUID,
    object_name TEXT
)
SECURITY DEFINER
BEGIN ATOMIC
    SELECT DISTINCT
        rbac.operations.id,
        rbac.operations.name,
        rbac.objects.id,
        rbac.objects.name
    FROM rbac.session_roles
    JOIN rbac.roles
      ON rbac.roles.id = rbac.session_roles.role_id
    JOIN rbac.assigned_permissions
      ON rbac.assigned_permissions.role_id = rbac.roles.id
    JOIN rbac.operations
      ON rbac.operations.id = rbac.assigned_permissions.operation_id
    JOIN rbac.objects
      ON rbac.objects.id = rbac.assigned_permissions.object_id
    WHERE rbac.session_roles.session_id = session_permissions.session_id;
END;
