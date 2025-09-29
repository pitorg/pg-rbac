CREATE OR REPLACE FUNCTION rbac.user_permissions(user_id UUID)
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
    FROM rbac.assigned_users
    JOIN rbac.roles
      ON rbac.roles.id = rbac.assigned_users.role_id
    JOIN rbac.assigned_permissions
      ON rbac.assigned_permissions.role_id = rbac.roles.id
    JOIN rbac.operations
      ON rbac.operations.id = rbac.assigned_permissions.operation_id
    JOIN rbac.objects
      ON rbac.objects.id = rbac.assigned_permissions.object_id
    WHERE rbac.assigned_users.user_id = user_permissions.user_id;
END;
