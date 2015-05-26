SELECT pg_get_indexdef(idx.indexrelid) || ';'
  FROM pg_stat_all_indexes i
  JOIN pg_class c ON (c.oid = i.relid)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_index idx ON (idx.indexrelid =  i.indexrelid )
 WHERE NOT idx.indisprimary
   AND NOT idx.indisunique
   AND i.relname NOT LIKE 'pg_%'
   AND i.idx_scan = 0
   ORDER BY n.nspname,
	  i.relname;
