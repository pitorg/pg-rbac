CREATE OR REPLACE FUNCTION rbac.add_active_role(user_id UUID, session_id UUID, role_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    INSERT INTO rbac.session_roles
        (session_id, user_id, role_id)
    VALUES
        (session_id, user_id, role_id)
    RETURNING TRUE;
END;
