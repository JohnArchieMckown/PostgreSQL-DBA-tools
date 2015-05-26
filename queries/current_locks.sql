SELECT database,
       relation,
       n.nspname,
       c.relname,
       pid,
       a.usename,
       locktype,
       mode,
       granted,
       tuple
  FROM pg_locks l
  JOIN pg_class c ON (c.oid = l.relation)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_stat_activity a ON (a.procpid = l.pid)
ORDER BY database,
	 relation,
	 pid;

