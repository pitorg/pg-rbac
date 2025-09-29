CREATE OR REPLACE FUNCTION rbac.create_session(user_id UUID, active_role_set UUID[])
RETURNS UUID
SECURITY DEFINER
BEGIN ATOMIC
    WITH
    insert_session AS
    (
        INSERT INTO rbac.sessions
            (user_id)
        VALUES
            (create_session.user_id)
        RETURNING rbac.sessions.id
    ),
    insert_session_roles AS
    (
        INSERT INTO rbac.session_roles
            (session_id, user_id, role_id)
        SELECT
            insert_session.id,
            create_session.user_id,
            active_roles.id
        FROM insert_session
        CROSS JOIN unnest(active_role_set) AS active_roles(id)
    )
    SELECT id FROM insert_session;
END;
