SELECT DISTINCT n1.nspname || '.' || p.relname AS parent, n2.nspname || '.' || c.relname AS child
--	 , cstr.conname
  FROM pg_class c
  JOIN pg_constraint cstr ON (cstr.conrelid = c.oid AND c.relkind = 'r' AND cstr.contype = 'f')
  JOIN pg_namespace n2 ON (n2.oid = c.relnamespace)
  JOIN pg_class p ON (p.oid = cstr.confrelid)
  JOIN pg_namespace n1 ON (n1.oid = p.relnamespace)
 WHERE p.relkind = 'r'
--   AND n1.nspname = '<schema_name>'
--   AND p.relname = '<paren_table>'
   AND p.relname NOT LIKE 'pg_%'
   AND p.relname NOT LIKE 'sql_%'
   AND p.oid IN (SELECT confrelid
		   FROM pg_constraint)
 ORDER BY parent, child;

