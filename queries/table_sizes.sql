SELECT n.nspname as schema,
       c.relname as table,
       a.rolname as owner,
       c.relfilenode as filename,
       c.reltuples,
       pg_size_pretty(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(c.relname) )) as size,
       pg_size_pretty(pg_total_relation_size(quote_ident(n.nspname) || '.' || quote_ident(c.relname) )) as total_size,
       pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(c.relname) ) as size_bytes,
       pg_total_relation_size(quote_ident(n.nspname) || '.' || quote_ident(c.relname) ) as total_size_bytes,
       CASE WHEN c.reltablespace = 0
	    THEN 'pg_default'
	    ELSE (SELECT t.spcname
		    FROM pg_tablespace t WHERE (t.oid = c.reltablespace) )
	END as tablespace
FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_authid a ON ( a.oid = c.relowner )
  WHERE relname NOT LIKE 'pg_%'
    AND relname NOT LIKE 'information%'
    AND relname NOT LIKE 'sql_%'
    AND relkind IN ('r')
ORDER BY 7 DESC, 1, 2;
