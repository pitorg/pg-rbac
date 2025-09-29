CREATE OR REPLACE FUNCTION rbac.delete_user(user_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    DELETE FROM rbac.session_roles
          WHERE rbac.session_roles.user_id = delete_user.user_id;
    DELETE FROM rbac.sessions
          WHERE rbac.sessions.user_id = delete_user.user_id;
    DELETE FROM rbac.assigned_users
          WHERE rbac.assigned_users.user_id = delete_user.user_id;
    DELETE FROM rbac.users
          WHERE rbac.users.id = delete_user.user_id
    RETURNING TRUE;
END;
