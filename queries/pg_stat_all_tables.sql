SELECT n.nspname,
       s.relname,
       c.reltuples::bigint,
--	 n_live_tup,
       n_tup_ins,
       n_tup_upd,
       n_tup_del,
       date_trunc('second', last_vacuum) as last_vacuum,
       date_trunc('second', last_autovacuum) as last_autovacuum,
       date_trunc('second', last_analyze) as last_analyze,
       date_trunc('second', last_autoanalyze) as last_autoanalyze
       ,
       round( current_setting('autovacuum_vacuum_threshold')::integer + current_setting('autovacuum_vacuum_scale_factor')::numeric * C.reltuples) AS av_threshold
/*	 ,CASE WHEN reltuples > 0
	      THEN round(100.0 * n_dead_tup / (reltuples))
	    ELSE 0
       END AS pct_dead,
       CASE WHEN n_dead_tup > round( current_setting('autovacuum_vacuum_threshold')::integer + current_setting('autovacuum_vacuum_scale_factor')::numeric * C.reltuples)
	      THEN 'VACUUM'
	    ELSE 'ok'
	END AS "av_needed"
*/
  FROM pg_stat_all_tables s
  JOIN pg_class c ON c.oid = s.relid
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
 WHERE s.relname NOT LIKE 'pg_%'
   AND s.relname NOT LIKE 'sql_%'
--   AND s.relname LIKE '%TBL%'
 ORDER by 1, 2;
