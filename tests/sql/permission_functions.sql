\set VERBOSITY terse

SELECT id AS create_sale_object_id FROM rbac.objects WHERE name = 'create_sale' \gset
SELECT id AS give_discount_object_id FROM rbac.objects WHERE name = 'give_discount' \gset
SELECT id AS userless_object_id FROM rbac.objects WHERE name = 'userless' \gset

SELECT id AS execute_operation_id FROM rbac.operations WHERE name = 'execute' \gset

SELECT '67dc8571-eed5-40b8-b3d6-666b82dee77b'::UUID AS user_id \gset
SELECT rbac.add_user(:'user_id'::UUID);
SELECT rbac.add_role('role_1') AS role_id_1 \gset
SELECT rbac.add_role('role_2') AS role_id_2 \gset
SELECT rbac.add_role('role_3') AS role_id_3 \gset
SELECT rbac.add_role('role_4') AS role_id_4 \gset

SELECT rbac.assign_user(:'user_id'::UUID, :'role_id_1'::UUID);
SELECT rbac.assign_user(:'user_id'::UUID, :'role_id_4'::UUID);

SELECT role_name FROM rbac.assigned_roles(:'user_id'::UUID) ORDER BY role_name;

SELECT user_id FROM rbac.assigned_users(:'role_id_1'::UUID);
SELECT user_id FROM rbac.assigned_users(:'role_id_2'::UUID);

SELECT rbac.create_session
(
    :'user_id'::UUID,
    ARRAY[:'role_id_1'::UUID, :'role_id_4'::UUID]
) AS session_id \gset

SELECT operation_name, object_name FROM rbac.session_permissions(:'session_id'::UUID); -- none yet

SELECT role_name FROM rbac.session_roles(:'session_id'::UUID) ORDER BY role_name; -- role_1, role_4

SELECT rbac.grant_permission(:'execute_operation_id'::UUID, :'create_sale_object_id'::UUID, :'role_id_2'::UUID);
SELECT rbac.check_access(:'session_id'::UUID, :'execute_operation_id'::UUID, :'create_sale_object_id'::UUID); -- false
SELECT rbac.check_access(:'session_id'::UUID, :'execute_operation_id'::UUID, :'give_discount_object_id'::UUID); -- false
SELECT rbac.grant_permission(:'execute_operation_id'::UUID, :'create_sale_object_id'::UUID, :'role_id_3'::UUID);
SELECT rbac.check_access(:'session_id'::UUID, :'execute_operation_id'::UUID, :'create_sale_object_id'::UUID); -- false
SELECT rbac.check_access(:'session_id'::UUID, :'execute_operation_id'::UUID, :'give_discount_object_id'::UUID); -- false
SELECT rbac.add_active_role(:'user_id'::UUID, :'session_id'::UUID, :'role_id_3');
SELECT rbac.assign_user(:'user_id'::UUID, :'role_id_3'::UUID);
SELECT rbac.add_active_role(:'user_id'::UUID, :'session_id'::UUID, :'role_id_3');
SELECT rbac.check_access(:'session_id'::UUID, :'execute_operation_id'::UUID, :'create_sale_object_id'::UUID); -- true
SELECT rbac.drop_active_role(:'user_id'::UUID, :'session_id'::UUID, :'role_id_3');
SELECT rbac.check_access(:'session_id'::UUID, :'execute_operation_id'::UUID, :'create_sale_object_id'::UUID); -- false
SELECT rbac.grant_permission(:'execute_operation_id'::UUID, :'create_sale_object_id'::UUID, :'role_id_1'::UUID);
SELECT rbac.check_access(:'session_id'::UUID, :'execute_operation_id'::UUID, :'create_sale_object_id'::UUID); -- true
SELECT rbac.check_access(:'session_id'::UUID, :'execute_operation_id'::UUID, :'give_discount_object_id'::UUID); -- false
SELECT rbac.grant_permission(:'execute_operation_id'::UUID, :'give_discount_object_id'::UUID, :'role_id_4'::UUID);
SELECT rbac.check_access(:'session_id'::UUID, :'execute_operation_id'::UUID, :'give_discount_object_id'::UUID); -- true

SELECT operation_name, object_name FROM rbac.role_permissions(:'role_id_4');

SELECT operation_name, object_name FROM rbac.session_permissions(:'session_id'::UUID) ORDER BY operation_name, object_name;
SELECT rbac.drop_active_role(:'user_id'::UUID, :'session_id'::UUID, :'role_id_4');
SELECT operation_name, object_name FROM rbac.session_permissions(:'session_id'::UUID) ORDER BY operation_name, object_name;

SELECT operation_name, object_name FROM rbac.user_permissions(:'user_id'::UUID) ORDER BY operation_name, object_name;

SELECT operation_name FROM rbac.role_operations_on_object(:'role_id_4'::UUID, :'give_discount_object_id'::UUID);
SELECT operation_name FROM rbac.role_operations_on_object(:'role_id_3'::UUID, :'give_discount_object_id'::UUID);
SELECT operation_name FROM rbac.user_operations_on_object(:'user_id'::UUID, :'give_discount_object_id'::UUID);
SELECT operation_name FROM rbac.user_operations_on_object(:'user_id'::UUID, :'userless_object_id'::UUID);

SELECT rbac.revoke_permission(:'execute_operation_id'::UUID, :'create_sale_object_id'::UUID, :'role_id_1'::UUID);
SELECT rbac.revoke_permission(:'execute_operation_id'::UUID, :'create_sale_object_id'::UUID, :'role_id_2'::UUID);
SELECT rbac.revoke_permission(:'execute_operation_id'::UUID, :'create_sale_object_id'::UUID, :'role_id_3'::UUID);
SELECT rbac.revoke_permission(:'execute_operation_id'::UUID, :'give_discount_object_id'::UUID, :'role_id_4'::UUID);

SELECT rbac.deassign_user(:'user_id'::UUID, :'role_id_1'::UUID);
SELECT rbac.deassign_user(:'user_id'::UUID, :'role_id_3'::UUID);
SELECT rbac.deassign_user(:'user_id'::UUID, :'role_id_4'::UUID);

SELECT rbac.delete_session(:'user_id'::UUID, :'session_id'::UUID);

SELECT rbac.delete_user(:'user_id'::UUID);
SELECT rbac.delete_role(:'role_id_1'::UUID);
SELECT rbac.delete_role(:'role_id_2'::UUID);
SELECT rbac.delete_role(:'role_id_3'::UUID);
SELECT rbac.delete_role(:'role_id_4'::UUID);
