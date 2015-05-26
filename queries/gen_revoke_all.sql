SELECT 'REVOKE ALL PRIVILEGES FROM TABLE public."' || relname || '"  FROM <some_user>;'
  FROM pg_class
WHERE relname NOT LIKE 'pg_%' AND
relname NOT LIKE 'information%' AND
relname NOT LIKE 'sql_%' AND
relkind = 'r'
ORDER BY relname;
