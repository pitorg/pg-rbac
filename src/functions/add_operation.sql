CREATE OR REPLACE FUNCTION rbac.add_operation(operation_name TEXT)
RETURNS UUID
SECURITY DEFINER
BEGIN ATOMIC
    INSERT INTO rbac.operations (name) VALUES (add_operation.operation_name) RETURNING rbac.operations.id;
END;
