CREATE OR REPLACE FUNCTION rbac.role_operations_on_object(role_id UUID, object_id UUID)
RETURNS TABLE
(
    operation_id UUID,
    operation_name TEXT
)
SECURITY DEFINER
BEGIN ATOMIC
    SELECT
        rbac.operations.id,
        rbac.operations.name
    FROM rbac.assigned_permissions
    JOIN rbac.operations
      ON rbac.operations.id = rbac.assigned_permissions.operation_id
    WHERE rbac.assigned_permissions.role_id   = role_operations_on_object.role_id
      AND rbac.assigned_permissions.object_id = role_operations_on_object.object_id;
END;
