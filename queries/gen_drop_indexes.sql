SELECT 'DROP INDEX IF EXISTS "' || n.nspname || '"' || '.' || '"' || i.indexrelname || '"' ||';'
  FROM pg_stat_all_indexes i
  JOIN pg_class c ON (c.oid = i.relid)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_index idx ON (idx.indexrelid =  i.indexrelid )
 WHERE NOT idx.indisprimary
   AND i.relname NOT LIKE 'pg_%'
 ORDER BY i.indexrelname;
