SELECT table_schema,
       table_name,
       grantee,
       privilege_type
  FROM information_schema.role_table_grants
 WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
 ORDER BY table_schema, table_name, grantee;
