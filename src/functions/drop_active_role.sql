CREATE OR REPLACE FUNCTION rbac.drop_active_role(user_id UUID, session_id UUID, role_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    DELETE FROM rbac.session_roles
    WHERE rbac.session_roles.session_id = drop_active_role.session_id
      AND rbac.session_roles.user_id = drop_active_role.user_id
      AND rbac.session_roles.role_id = drop_active_role.role_id
    RETURNING TRUE;
END;
