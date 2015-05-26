SELECT 'SELECT ''' ||
       c.relname || ''' as table, ' ||
       c.reltuples::int4 || ' as rows, ' ||
       '(SELECT COUNT(*) FROM ' || s.nspname || '."' || c.relname || '") as cnt;'
  FROM pg_catalog.pg_class c
  JOIN pg_catalog.pg_namespace s ON (c.relnamespace = s.oid)
 WHERE nspname = 'public'
   AND relkind = 'r'
 ORDER BY c.reltuples::int4 DESC;

