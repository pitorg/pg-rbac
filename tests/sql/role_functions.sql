SELECT rbac.add_role('admin') AS role_id \gset
SELECT rbac.add_role('admin'); -- error since already added
SELECT rbac.delete_role(:'role_id'::UUID);
SELECT rbac.delete_role(:'role_id'::UUID); -- NULL, already deleted
