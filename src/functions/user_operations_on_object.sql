CREATE OR REPLACE FUNCTION rbac.user_operations_on_object(user_id UUID, object_id UUID)
RETURNS TABLE
(
    operation_id UUID,
    operation_name TEXT
)
SECURITY DEFINER
BEGIN ATOMIC
    SELECT DISTINCT
        rbac.operations.id,
        rbac.operations.name
    FROM rbac.assigned_users
    JOIN rbac.roles
      ON rbac.roles.id = rbac.assigned_users.role_id
    JOIN rbac.assigned_permissions
      ON rbac.assigned_permissions.role_id = rbac.roles.id
    JOIN rbac.operations
      ON rbac.operations.id = rbac.assigned_permissions.operation_id
    WHERE rbac.assigned_users.user_id = user_operations_on_object.user_id
      AND rbac.assigned_permissions.object_id = user_operations_on_object.object_id;
END;
