CREATE OR REPLACE FUNCTION rbac.session_roles(session_id UUID)
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
    FROM rbac.session_roles
    JOIN rbac.roles
      ON rbac.roles.id = rbac.session_roles.role_id
    WHERE rbac.session_roles.session_id = session_roles.session_id;
END;
