CREATE OR REPLACE FUNCTION rbac.delete_session(user_id UUID, session_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
BEGIN ATOMIC
    DELETE FROM rbac.session_roles
          WHERE rbac.session_roles.user_id    = delete_session.user_id
            AND rbac.session_roles.session_id = delete_session.session_id;
    DELETE FROM rbac.sessions
          WHERE rbac.sessions.user_id = delete_session.user_id
            AND rbac.sessions.id      = delete_session.session_id
    RETURNING TRUE;
END;
