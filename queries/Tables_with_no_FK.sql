SELECT relname as table
  FROM pg_class
 WHERE relkind = 'r'
   AND relname NOT LIKE 'pg_%'
   AND relname NOT LIKE 'sql_%'
   AND OID NOT IN 
(SELECT conrelid
   FROM pg_constraint
  WHERE contype = 'f'
    AND contype <> 'p'
    AND contype <> 'c')
  ORDER BY relname;