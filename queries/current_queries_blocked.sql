/* Use for PostgreSQL 9.2 or greater */
SELECT c.datname,
       c.pid as pid,
       c.client_addr,
       c.usename as user,
       c.query,
       CASE WHEN c.waiting = TRUE
	    THEN 'BLOCKED'
	    ELSE 'no'
	END as waiting,
       l.pid as blocked_by,
       current_timestamp - c.query_start as duration
  FROM pg_stat_activity c
  LEFT JOIN pg_locks l1 ON (c.pid = l1.pid and not l1.granted)
  LEFT JOIN pg_locks l2 on (l1.relation = l2.relation and l2.granted)
  LEFT JOIN pg_stat_activity l ON (l2.pid = l.pid)
  LEFT JOIN pg_stat_user_tables t ON (l1.relation = t.relid)
 WHERE pg_backend_pid() <> c.pid
ORDER BY datname,
	 query_start;

/* Use for PostgreSQL 9.1 or less */
/*
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
*/
