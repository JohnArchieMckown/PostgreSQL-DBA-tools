BEGIN;

DROP TABLE IF EXISTS tmp_trans_stats;

CREATE TEMP TABLE tmp_trans_stats AS
SELECT 'start_cnt'::varchar(10) AS taken,
       SUM(xact_commit + xact_rollback) AS cnt
  FROM pg_stat_database;

COMMIT;

SELECT pg_sleep(60);

INSERT INTO tmp_trans_stats
SELECT 'end_cnt'::varchar(10) AS taken,
       SUM(xact_commit + xact_rollback) AS cnt
  FROM pg_stat_database;

SELECT (
	(SELECT cnt
	  FROM tmp_trans_stats
	 WHERE taken = 'end_cnt')
     - (SELECT cnt
	  FROM tmp_trans_stats
	 WHERE taken = 'start_cnt')
       ) as tot_trans;

