EXTENSION = rbac
DATA = rbac--1.0.sql
REGRESS = create_extension pre_defined_data user_functions role_functions user_role_functions session_functions permission_functions
REGRESS_OPTS = --inputdir=tests
EXTRA_CLEAN = rbac--1.0.sql

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

all: rbac--1.0.sql

SQL_SRC = \
	src/header.sql \
	src/tables/objects.sql \
	src/functions/add_object.sql \
	src/tables/operations.sql \
	src/functions/add_operation.sql \
	src/tables/users.sql \
	src/functions/add_user.sql \
	src/tables/roles.sql \
	src/functions/add_role.sql \
	src/tables/assigned_users.sql \
	src/functions/assign_user.sql \
	src/tables/sessions.sql \
	src/tables/session_roles.sql \
	src/functions/create_session.sql \
	src/functions/delete_session.sql \
	src/functions/deassign_user.sql \
	src/tables/assigned_permissions.sql \
	src/functions/grant_permission.sql \
	src/functions/revoke_permission.sql \
	src/functions/check_access.sql \
	src/functions/add_active_role.sql \
	src/functions/drop_active_role.sql \
	src/functions/assigned_roles.sql \
	src/functions/assigned_users.sql \
	src/functions/role_permissions.sql \
	src/functions/session_permissions.sql \
	src/functions/user_permissions.sql \
	src/functions/session_roles.sql \
	src/functions/role_operations_on_object.sql \
	src/functions/user_operations_on_object.sql \
	src/functions/delete_user.sql \
	src/functions/delete_role.sql



rbac--1.0.sql: $(SQL_SRC)
	cat $^ > $@

.PHONY: schema
schema: schema_diagram.svg

schema_diagram.svg: schema_diagram.sql
	@echo "Generating schema diagram..."
	@DB_NAME="temp_rbac_schema_$$$$" && \
	createdb "$$DB_NAME" 2>/dev/null && \
	trap "dropdb \"$$DB_NAME\" 2>/dev/null || true" EXIT && \
	psql "$$DB_NAME" -c "CREATE EXTENSION rbac;" >/dev/null && \
	psql "$$DB_NAME" -f schema_diagram.sql >/dev/null && \
	if [ -f schema_diagram.dot ]; then \
		dot -Tsvg schema_diagram.dot -o schema_diagram.svg && \
		rm -f schema_diagram.dot && \
		echo "Schema diagram generated: schema_diagram.svg"; \
	else \
		echo "ERROR: DOT file not generated" >&2 && \
		exit 1; \
	fi
