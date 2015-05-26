SELECT idstat.schemaname AS schema,
       idstat.relname AS table_name,
       indexrelname AS index_name,
       idstat.idx_scan AS times_used,
       pg_size_pretty(pg_relation_size(quote_ident(idstat.schemaname) || '.' || quote_ident(idstat.relname))) AS table_size,
       pg_size_pretty(pg_relation_size(quote_ident(idstat.schemaname) || '.' || quote_ident(indexrelname))) AS index_size,
       n_tup_upd + n_tup_ins + n_tup_del as num_writes,
       indexdef AS definition
FROM pg_stat_user_indexes AS idstat
JOIN pg_indexes ON indexrelname = indexname
JOIN pg_stat_user_tables AS tabstat ON idstat.relname = tabstat.relname
WHERE idstat.idx_scan < 200
  AND indexdef !~* 'unique'
ORDER BY idstat.schemaname,
	 idstat.relname,
	 indexrelname;
