SELECT n.nspname,
       c.relname,
       pg_size_pretty (pg_total_relation_size(c.oid)) as size
  FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE c.relname NOT LIKE 'pg_%'
  AND c.relname NOT LIKE 'information%'
  AND c.relname NOT LIKE 'sql_%'
  AND c.relkind = 'r'
  AND n.nspname = '<schema_name>'
ORDER BY n.nspname;

