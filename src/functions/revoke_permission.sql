CREATE OR REPLACE FUNCTION rbac.revoke_permission(operation_id UUID, object_id UUID, role_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    DELETE FROM rbac.assigned_permissions
    WHERE rbac.assigned_permissions.operation_id = revoke_permission.operation_id
      AND rbac.assigned_permissions.object_id    = revoke_permission.object_id
      AND rbac.assigned_permissions.role_id      = revoke_permission.role_id
    RETURNING TRUE;
END;
