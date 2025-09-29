CREATE OR REPLACE FUNCTION rbac.assign_user(user_id UUID, role_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    INSERT INTO rbac.assigned_users
        (user_id, role_id)
    VALUES
        (user_id, role_id)
    RETURNING TRUE;
END;
