SELECT schemaname,
       relname,
       idx_tup_fetch + seq_tup_read as TotalReads
  FROM pg_stat_all_tables
WHERE idx_tup_fetch + seq_tup_read != 0
  AND schemaname NOT IN ( 'pg_catalog', 'pg_toast' )
order by TotalReads desc
LIMIT 10;
