SELECT n.nspname as schema,
       c.relname as table,
       c.reltablespace,
       CASE WHEN c.reltablespace > 0 THEN (SELECT t.spcname
					    FROM pg_tablespace
					   WHERE oid = c.reltablespace)
       ELSE '' END
  FROM pg_class c
  JOIN pg_authid a ON ( a.OID = c.relowner )
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_tablespace t ON ( CASE WHEN c.reltablespace > 0 THEN t.oid = c.reltablespace
				 ELSE NULL END)
WHERE c.relname NOT LIKE 'pg_%'
  AND n.nspname NOT LIKE 'information%'
  AND n.nspname NOT LIKE 'sql_%'
  AND c.relkind = 'i'
--  AND n.nspname = '<target_schema>'
--  AND c.relname = '<table_name>'
ORDER BY n.nspname, c.relname;

