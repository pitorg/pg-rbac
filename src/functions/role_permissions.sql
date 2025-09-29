CREATE OR REPLACE FUNCTION rbac.role_permissions(role_id UUID)
RETURNS TABLE
(
    operation_id UUID,
    operation_name TEXT,
    object_id UUID,
    object_name TEXT
)
SECURITY DEFINER
BEGIN ATOMIC
    SELECT
        rbac.operations.id,
        rbac.operations.name,
        rbac.objects.id,
        rbac.objects.name
    FROM rbac.assigned_permissions
    JOIN rbac.operations
      ON rbac.operations.id = rbac.assigned_permissions.operation_id
    JOIN rbac.objects
      ON rbac.objects.id = rbac.assigned_permissions.object_id
    WHERE rbac.assigned_permissions.role_id = role_permissions.role_id;
END;
