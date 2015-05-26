SELECT n.nspname,
       c.relname as table,
       (SELECT oid FROM pg_database WHERE datname = current_database() ) as db_dir,
       c.relfilenode as filename
  FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE relname NOT LIKE 'pg_%' AND
      relname NOT LIKE 'information%' AND
      relname NOT LIKE 'sql_%' AND
      relkind = 'r'
ORDER BY 1, relname;


