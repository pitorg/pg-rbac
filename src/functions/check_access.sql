CREATE OR REPLACE FUNCTION rbac.check_access(session_id UUID, operation_id UUID, object_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    SELECT EXISTS
    (
        SELECT 1
        FROM rbac.sessions
        JOIN rbac.session_roles
          ON rbac.session_roles.session_id = rbac.sessions.id
        JOIN rbac.roles
          ON rbac.roles.id = rbac.session_roles.role_id
        JOIN rbac.assigned_permissions
          ON rbac.assigned_permissions.role_id = rbac.roles.id
        WHERE rbac.sessions.id                       = check_access.session_id
          AND rbac.assigned_permissions.operation_id = check_access.operation_id
          AND rbac.assigned_permissions.object_id    = check_access.object_id
    );
END;
