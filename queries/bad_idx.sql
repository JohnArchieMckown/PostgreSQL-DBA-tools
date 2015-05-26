SELECT n.nspname,
       i.relname,
       i.indexrelname,
       CASE WHEN idx.indisprimary
	    THEN 'pkey'
	    WHEN idx.indisunique
	    THEN 'uidx'
	    ELSE 'idx'
	END AS type,
	'INVALID'
  FROM pg_stat_all_indexes i
  JOIN pg_class c     ON (c.oid = i.relid)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_index idx   ON (idx.indexrelid =  i.indexrelid )
 WHERE idx.indisvalid = FALSE
 ORDER BY 1, 2;
