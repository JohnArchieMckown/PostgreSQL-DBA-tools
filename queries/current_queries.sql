SELECT a.datname,
       a.procpid as pid,
       CASE WHEN a.client_addr IS NULL
            THEN 'local'
            ELSE a.client_addr::text
       END as client_addr,
       a.usename as user,
       a.waiting,
       l.procpid as blocking_pid,
       l.usename as blicking_user,
       a.current_query,
       a.query_start,
       current_timestamp - a.query_start as duration 
  FROM pg_stat_activity a
LEFT  JOIN pg_locks l1 ON (a.procpid = l1.pid )
LEFT  JOIN pg_locks l2 on (l1.relation = l2.relation )
LEFT  JOIN pg_stat_activity l ON (l2.pid = l.procpid)
LEFT  JOIN pg_stat_user_tables t ON (l1.relation = t.relid)
 WHERE pg_backend_pid() <> a.procpid
ORDER BY a.datname,
         a.query_start;


SELECT
 w.current_query as waiting_query,
 w.procpid as w_pid,
 w.usename as w_user,
 l.current_query as locking_query,
 l.procpid as l_pid,
 l.usename as l_user,
 t.schemaname || '.' || t.relname as tablename
 FROM pg_stat_activity w 
 JOIN pg_locks l1 ON (w.procpid = l1.pid and not l1.granted)
 JOIN pg_locks l2 on (l1.relation = l2.relation and l2.granted)
 JOIN pg_stat_activity l ON (l2.pid = l.procpid)
 JOIN pg_stat_user_tables t ON (l1.relation = t.relid)
 WHERE w.waiting;
SELECT datname,
       procpid as pid,
       client_addr,
       usename as user,
       current_query,
       CASE WHEN waiting = TRUE
	    THEN 'BLOCKED'
	    ELSE 'no'
	END as waiting,
       query_start,
       current_timestamp - query_start as duration
  FROM pg_stat_activity
 WHERE pg_backend_pid() <> procpid
ORDER BY datname,
	 query_start;

