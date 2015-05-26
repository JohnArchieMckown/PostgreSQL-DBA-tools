SELECT table_schema,
       table_name,
       constraint_name as constraint,
       constraint_type as type
  FROM information_schema.table_constraints
 WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY 1, 2;
