SELECT (SELECT oid 
          FROM pg_database 
         WHERE datname = current_database()) AS database,
       c.relfilenode as filename,
       n.nspname as schema,
       c.relname as table
  FROM pg_class c
  JOIN pg_namespace n ON ( n.oid = c.relnamespace )
WHERE relname NOT LIKE 'pg_%' AND
      relname NOT LIKE 'information%' AND
      relname NOT LIKE 'sql_%' AND
      relkind = 'r' 
ORDER BY relfilenode;

