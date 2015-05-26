SELECT n.nspname as schema,
       t.relname as table, 
       count(c.conname)
  FROM pg_class t
  JOIN pg_namespace n ON n.oid = t.relnamespace
  JOIN pg_constraint c ON ( c.conrelid = t.OID AND c.contype = 'f')
 WHERE relkind = 'r'
   AND t.relname NOT LIKE 'pg_%'
   AND t.relname NOT LIKE 'sql_%'
   GROUP BY n.nspname, 
            t.relname
   ORDER BY count, n.nspname, t.relname;


SELECT n.nspname as schema, 
       t.relname as table, 
       c.conname as fk_name
  FROM pg_class t
  JOIN pg_namespace n ON n.oid = t.relnamespace
  JOIN pg_constraint c ON ( c.conrelid = t.OID AND c.contype = 'f')
 WHERE relkind = 'r'
   AND t.relname NOT LIKE 'pg_%'
   AND t.relname NOT LIKE 'sql_%'
   ORDER BY n.nspname, 
            t.relname, 
            c.conname;