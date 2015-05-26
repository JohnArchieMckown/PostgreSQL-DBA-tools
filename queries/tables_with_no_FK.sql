SELECT n.nspname as schema,
       relname as table
  FROM pg_class c
  JOIN pg_namespace n ON ( n.oid = c.relnamespace )
 WHERE relkind = 'r'
   AND relname NOT LIKE 'pg_%'
   AND relname NOT LIKE 'sql_%'
   AND c.oid NOT IN
       (SELECT conrelid
          FROM pg_constraint
         WHERE contype = 'f'
           AND contype <> 'p'
           AND contype <> 'c')
  ORDER BY n.nspname,
           relname;
