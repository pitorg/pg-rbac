SELECT '63d412c1-6752-42f2-a71b-be7f8dda83da'::UUID AS user_id \gset
SELECT rbac.add_user(:'user_id'::UUID);
SELECT rbac.add_role('cashier') AS cashier_role_id \gset
SELECT rbac.add_role('manager') AS manager_role_id \gset
SELECT rbac.add_role('admin') AS admin_role_id \gset
SELECT rbac.assign_user(:'user_id'::UUID, :'cashier_role_id'::UUID);
SELECT rbac.assign_user(:'user_id'::UUID, :'admin_role_id'::UUID);

SELECT roles.name
FROM rbac.assigned_users
JOIN rbac.roles ON roles.id = assigned_users.role_id
WHERE assigned_users.user_id = :'user_id'::UUID
ORDER BY roles.name;

\set VERBOSITY terse
SELECT rbac.assign_user(:'user_id'::UUID, :'admin_role_id'::UUID); -- error since already assigned
SELECT rbac.assign_user(:'user_id'::UUID, 'cdca237a-a240-448e-a4c5-7ae747d0156e'::UUID); -- error since non-existing role
SELECT rbac.assign_user('cdca237a-a240-448e-a4c5-7ae747d0156e'::UUID, :'admin_role_id'::UUID); -- error since non-existing user
