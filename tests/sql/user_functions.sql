-- The user_id is generated outside of the rbac extension
SELECT 'd48572ae-6087-432a-927b-0c6604b9d84d'::UUID AS user_id \gset
SELECT rbac.add_user(:'user_id'::UUID);
SELECT rbac.add_user(:'user_id'::UUID); -- error since already added
SELECT rbac.add_user(NULL::UUID); -- error since NULL is invalid
SELECT rbac.delete_user(NULL::UUID); -- NULL since NULL is invalid
SELECT rbac.delete_user(:'user_id'::UUID);
SELECT rbac.delete_user(:'user_id'::UUID); -- NULL since already deleted
SELECT rbac.delete_user('fd939c0d-728e-46ff-a535-58464c20917a'::UUID); -- NULL since non-existing
