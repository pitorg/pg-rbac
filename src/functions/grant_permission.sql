CREATE OR REPLACE FUNCTION rbac.grant_permission(operation_id UUID, object_id UUID, role_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    INSERT INTO rbac.assigned_permissions
        (operation_id, object_id, role_id)
    VALUES
        (operation_id, object_id, role_id)
    RETURNING TRUE;
END;
