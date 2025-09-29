CREATE OR REPLACE FUNCTION rbac.assigned_roles(user_id UUID)
RETURNS TABLE
(
    role_id UUID,
    role_name TEXT
)
SECURITY DEFINER
BEGIN ATOMIC
    SELECT
        rbac.roles.id,
        rbac.roles.name
    FROM rbac.assigned_users
    JOIN rbac.roles ON rbac.roles.id = rbac.assigned_users.role_id
    WHERE rbac.assigned_users.user_id = assigned_roles.user_id;
END;
