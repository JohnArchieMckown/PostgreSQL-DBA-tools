SELECT n.nspname,
       c.relname,
       r.rulename
  FROM pg_rewrite r
  JOIN pg_class c     ON (c.oid = ev_class)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
 WHERE rulename <> '_RETURN'
--   AND n.nspname <> 'inv'
  ORDER BY 1, 2, 3;

