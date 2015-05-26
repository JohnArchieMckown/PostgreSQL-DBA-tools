SELECT 'ALTER TABLE ' || c.relname || ' SET TABLESPACE <new_table_space>;'
  FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  AND n.nspname = 'public'
  AND relkind = 'r'
ORDER BY relname;
