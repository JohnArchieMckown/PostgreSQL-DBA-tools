SELECT n.nspname as schema,
      t.relname as table, 
      c.conname as pk_name
  FROM pg_class t
  JOIN pg_namespace n ON ( n.oid = t.relnamespace )
  JOIN pg_constraint c ON ( c.conrelid = t.OID AND c.contype = 'p')
 WHERE relkind = 'r'
   AND t.relname NOT LIKE 'pg_%'
   AND t.relname NOT LIKE 'sql_%'
   ORDER BY t.relname, c.conname;
