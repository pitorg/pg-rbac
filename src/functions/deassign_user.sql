CREATE OR REPLACE FUNCTION rbac.deassign_user(user_id UUID, role_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    DELETE FROM rbac.session_roles
    WHERE rbac.session_roles.user_id = deassign_user.user_id
      AND rbac.session_roles.role_id = deassign_user.role_id;
    DELETE FROM rbac.assigned_users
    WHERE rbac.assigned_users.user_id = deassign_user.user_id
      AND rbac.assigned_users.role_id = deassign_user.role_id
    RETURNING TRUE;
END;
