CREATE OR REPLACE FUNCTION rbac.add_object(object_name TEXT)
RETURNS UUID
SECURITY DEFINER
BEGIN ATOMIC
    INSERT INTO rbac.objects (name) VALUES (add_object.object_name) RETURNING rbac.objects.id;
END;
