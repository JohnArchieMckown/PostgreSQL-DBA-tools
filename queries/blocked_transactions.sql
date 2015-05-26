/* Requires PostgreSQL version is 9.2 or Greater */
SELECT
 w.query as waiting_query,
 w.pid as w_pid,
 w.usename as w_user,
 l.query as locking_query,
 l.pid as l_pid,
 l.usename as l_user,
 t.schemaname || '.' || t.relname as tablename
 FROM pg_stat_activity w
 JOIN pg_locks l1 ON (w.pid = l1.pid and not l1.granted)
 JOIN pg_locks l2 on (l1.relation = l2.relation and l2.granted)
 JOIN pg_stat_activity l ON (l2.pid = l.pid)
 JOIN pg_stat_user_tables t ON (l1.relation = t.relid)
 WHERE w.waiting;
