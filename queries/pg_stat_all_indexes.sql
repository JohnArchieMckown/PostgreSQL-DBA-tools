SELECT n.nspname as schema,
       i.relname as table,
       i.indexrelname as index,
       i.idx_scan,
       i.idx_tup_read,
       i.idx_tup_fetch,
       CASE WHEN idx.indisprimary
	    THEN 'pkey'
	    WHEN idx.indisunique
	    THEN 'uidx'
	    ELSE 'idx'
	    END AS type,
/*
       pg_get_indexdef(idx.indexrelid, 1, FALSE) as idxcol1,
       pg_get_indexdef(idx.indexrelid, 2, FALSE) as idxcol2,
       pg_get_indexdef(idx.indexrelid, 3, FALSE) as idxcol3,
       pg_get_indexdef(idx.indexrelid, 4, FALSE) as idxcol4,

*/
       CASE WHEN idx.indisvalid
	    THEN 'valid'
	    ELSE 'INVALID'
	    END as statusi,
       pg_relation_size( quote_ident(n.nspname) || '.' || quote_ident(i.relname) ) as size_in_bytes,
       pg_size_pretty(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(i.relname) )) as size
  FROM pg_stat_all_indexes i
  JOIN pg_class c ON (c.oid = i.relid)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_index idx ON (idx.indexrelid =  i.indexrelid )
 WHERE i.relname LIKE '%%'
   AND n.nspname NOT LIKE 'pg_%'
--   AND idx.indisunique = TRUE
--   AND NOT idx.indisprimary
--   AND i.indexrelname LIKE 'tmp%'
--   AND idx.indisvalid IS false
/*   AND NOT idx.indisprimary
   AND NOT idx.indisunique
   AND idx_scan = 0
*/ ORDER BY 1, 2, 3;
