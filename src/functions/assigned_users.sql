CREATE OR REPLACE FUNCTION rbac.assigned_users(role_id UUID)
RETURNS TABLE
(
    user_id UUID
)
SECURITY DEFINER
BEGIN ATOMIC
    SELECT
        au.user_id
    FROM rbac.assigned_users AS au
    WHERE au.role_id = assigned_users.role_id;
END;
