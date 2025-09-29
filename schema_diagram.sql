-- schema_diagram.sql
-- Generates a GraphViz DOT digraph showing foreign key relationships
-- Each column is a node, columns are clustered by table
-- All FK edges have the same style, only color differs:
--   - Single column FKs: green edges
--   - Composite FKs: unique colors per constraint to show which edges belong together

\t
\a
\o schema_diagram.dot

-- Generate DOT header
SELECT 'digraph DatabaseSchema {
    rankdir=LR;
    compound=true;
    node [shape=box, style=filled, fillcolor=lightblue, fontsize=10];
    edge [color=darkgreen, arrowhead=vee, fontsize=8];
    
    // Table clusters with column nodes
';

-- Generate table clusters with individual column nodes
WITH columns_with_info AS (
    SELECT 
        c.table_schema,
        c.table_name,
        c.column_name,
        c.data_type,
        c.ordinal_position,
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM information_schema.constraint_column_usage ccu
                JOIN information_schema.table_constraints tc 
                    ON tc.constraint_name = ccu.constraint_name 
                    AND tc.constraint_schema = ccu.constraint_schema
                WHERE tc.constraint_type = 'PRIMARY KEY'
                    AND ccu.table_schema = c.table_schema
                    AND ccu.table_name = c.table_name
                    AND ccu.column_name = c.column_name
            ) THEN 'PK'
            ELSE ''
        END AS is_pk
    FROM information_schema.columns c
    JOIN information_schema.tables t 
        ON c.table_schema = t.table_schema 
        AND c.table_name = t.table_name
    WHERE t.table_schema NOT IN ('pg_catalog', 'information_schema')
        AND t.table_type = 'BASE TABLE'
    ORDER BY c.table_schema, c.table_name, c.ordinal_position
)
SELECT '    subgraph cluster_' || replace(table_schema || '_' || table_name, '.', '_') || ' {
        label="' || table_schema || '.' || table_name || '";
        style=filled;
        color=lightgrey;
        fontsize=12;
        
' || string_agg(
    '        "' || table_schema || '.' || table_name || '.' || column_name || 
    '" [label="' || column_name || 
    CASE WHEN is_pk = 'PK' THEN ' ⚷' ELSE '' END || 
    '\n' || data_type || '"' ||
    CASE WHEN is_pk = 'PK' THEN ', fillcolor=gold' ELSE '' END || 
    '];', E'\n' ORDER BY ordinal_position
) || '
    }
'
FROM columns_with_info
GROUP BY table_schema, table_name
ORDER BY table_schema, table_name;

-- Generate composite FK group nodes and single column FK edges
SELECT '    
    // Foreign Key Relationships
';

-- Get all foreign key relationships with proper column mapping
-- For multi-column FKs, we need to match positions using pg_constraint
WITH fk_details AS (
    SELECT 
        con.conname::text AS constraint_name,
        n.nspname AS source_schema,
        c.relname AS source_table,
        a.attname AS source_column,
        af.attname AS target_column,
        n2.nspname AS target_schema,
        c2.relname AS target_table,
        i AS position
    FROM pg_constraint con
    JOIN pg_class c ON con.conrelid = c.oid
    JOIN pg_namespace n ON c.relnamespace = n.oid
    JOIN pg_class c2 ON con.confrelid = c2.oid
    JOIN pg_namespace n2 ON c2.relnamespace = n2.oid
    CROSS JOIN LATERAL unnest(con.conkey, con.confkey) WITH ORDINALITY AS u(src, tgt, i)
    JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = u.src
    JOIN pg_attribute af ON af.attrelid = c2.oid AND af.attnum = u.tgt
    WHERE con.contype = 'f'
        AND n.nspname NOT IN ('pg_catalog', 'information_schema')
),
fk_grouped AS (
    SELECT 
        constraint_name,
        source_schema,
        source_table,
        target_schema,
        target_table,
        COUNT(*) AS column_count,
        string_agg(source_column, ',' ORDER BY position) AS source_columns,
        string_agg(target_column, ',' ORDER BY position) AS target_columns,
        string_agg('"' || source_schema || '.' || source_table || '.' || source_column || '"', E'\n        ' ORDER BY position) AS source_nodes,
        string_agg('"' || target_schema || '.' || target_table || '.' || target_column || '"', E'\n        ' ORDER BY position) AS target_nodes,
        MIN(source_column) AS first_source_col,
        MIN(target_column) AS first_target_col
    FROM fk_details
    GROUP BY constraint_name, source_schema, source_table, target_schema, target_table
),
-- Assign unique colors to composite foreign keys
fk_colors AS (
    SELECT 
        constraint_name,
        CASE row_number() OVER (ORDER BY constraint_name) % 12
            WHEN 0 THEN 'red'
            WHEN 1 THEN 'blue'
            WHEN 2 THEN 'darkviolet'
            WHEN 3 THEN 'darkorange'
            WHEN 4 THEN 'deeppink'
            WHEN 5 THEN 'darkturquoise'
            WHEN 6 THEN 'brown'
            WHEN 7 THEN 'indigo'
            WHEN 8 THEN 'darkmagenta'
            WHEN 9 THEN 'darkslateblue'
            WHEN 10 THEN 'crimson'
            WHEN 11 THEN 'darkgoldenrod'
        END AS edge_color
    FROM fk_grouped
    WHERE column_count > 1
),
-- Expand composite FKs into individual column pairs
fk_expanded AS (
    SELECT 
        fg.constraint_name,
        fg.source_schema,
        fg.source_table,
        fg.target_schema,
        fg.target_table,
        fg.column_count,
        fd.source_column,
        fd.target_column,
        fd.position,
        fg.source_columns,
        fg.target_columns,
        fc.edge_color
    FROM fk_grouped fg
    LEFT JOIN fk_details fd 
        ON fg.constraint_name = fd.constraint_name
    LEFT JOIN fk_colors fc
        ON fg.constraint_name = fc.constraint_name
    WHERE fg.column_count > 1
    
    UNION ALL
    
    SELECT 
        constraint_name,
        source_schema,
        source_table,
        target_schema,
        target_table,
        column_count,
        source_columns AS source_column,
        target_columns AS target_column,
        1 AS position,
        source_columns,
        target_columns,
        NULL AS edge_color
    FROM fk_grouped
    WHERE column_count = 1
)
SELECT CASE 
    WHEN column_count > 1 THEN
        CASE WHEN position = 1 THEN
            '    // Composite FK: ' || constraint_name || ' (' || source_columns || ' -> ' || target_columns || ', color: ' || edge_color || ')' || E'\n'
        ELSE '' END ||
        '    "' || source_schema || '.' || source_table || '.' || source_column || 
        '" -> "' || target_schema || '.' || target_table || '.' || target_column || 
        '" [color="' || edge_color || '", label="' || 
        CASE WHEN position = 1 THEN constraint_name ELSE '' END || 
        '"];'
    ELSE
        -- Single column FK - direct edge
        '    "' || source_schema || '.' || source_table || '.' || source_column || 
        '" -> "' || target_schema || '.' || target_table || '.' || target_column || 
        '" [label="' || constraint_name || '"];'
    END AS fk_definition
FROM fk_expanded
ORDER BY constraint_name, position;

-- Close the digraph
SELECT '
}';

\o
\a
\t

-- Display message
SELECT 'GraphViz DOT file generated: schema_diagram.dot' AS message;
SELECT 'To generate an SVG, run: dot -Tsvg schema_diagram.dot -o schema_diagram.svg' AS hint;
