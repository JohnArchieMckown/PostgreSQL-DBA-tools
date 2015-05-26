
SELECT DISTINCT t.typname
  FROM pg_class c
  JOIN pg_attribute a ON ( a.attrelid = c.oid )
  JOIN pg_type t ON (t.oid = a.atttypid)
  JOIN pg_catalog.pg_namespace s ON (c.relnamespace = s.oid)
WHERE c.relname NOT LIKE 'pg_%'
  AND c.relname NOT LIKE 'information%'
  AND c.relname NOT LIKE 'sql_%'
  AND c.relkind = 'r'
ORDER BY t.typname;
