SELECT n.nspname as schema,
       i.relname as table,
       i.indexrelname as index,
       i.idx_scan,
       i.idx_tup_read,
       i.idx_tup_fetch,
       pg_size_pretty(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(i.relname))) AS table_size,
       pg_size_pretty(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(i.indexrelname))) AS index_size,
       pg_get_indexdef(idx.indexrelid) as idx_definition
  FROM pg_stat_all_indexes i
  JOIN pg_class c ON (c.oid = i.relid)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_index idx ON (idx.indexrelid =  i.indexrelid )
 WHERE i.idx_scan < 200
   AND NOT idx.indisprimary
   AND NOT idx.indisunique
 ORDER BY 1, 2, 3;


