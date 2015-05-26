/* Requires PostgreSQL 8.4 or greater */
WITH s AS(
  SELECT SUM(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(c.relname))::bigint) AS table_size,
       pg_size_pretty(SUM(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(c.relname))::bigint)::bigint) AS table_size_pretty
  FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
   WHERE c.relkind = 'r'
   AND c.relname NOT LIKE 'pg_%'
   AND c.relname NOT LIKE 'sql%'
)
SELECT s.table_size,
       s.table_size_pretty,
       SUM(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(i.indexrelname))::bigint) AS unused_idx_size,
       pg_size_pretty(SUM(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(i.indexrelname))::bigint)::bigint) AS unused_idx_size_pretty,
           pg_database_size(current_database()) as db_size,
           pg_size_pretty(pg_database_size(current_database()))as db_size_pretty,
           pg_size_pretty(pg_database_size(current_database()) -  SUM(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(i.indexrelname))::bigint)::bigint) as db_minus_wasted_space

  FROM s, pg_stat_all_indexes i
  JOIN pg_class c ON (c.oid = i.relid)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_index idx ON (idx.indexrelid =  i.indexrelid )
 WHERE i.idx_scan = 0
   AND NOT idx.indisprimary
   AND NOT idx.indisunique
      GROUP BY table_size, table_size_pretty;
