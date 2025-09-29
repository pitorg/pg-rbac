CREATE OR REPLACE FUNCTION rbac.delete_role(role_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    DELETE FROM rbac.session_roles
          WHERE rbac.session_roles.role_id = delete_role.role_id;
    DELETE FROM rbac.assigned_permissions
          WHERE rbac.assigned_permissions.role_id = delete_role.role_id;
    DELETE FROM rbac.assigned_users
          WHERE rbac.assigned_users.role_id = delete_role.role_id;
    DELETE FROM rbac.roles
          WHERE rbac.roles.id = delete_role.role_id
    RETURNING TRUE;
END;
