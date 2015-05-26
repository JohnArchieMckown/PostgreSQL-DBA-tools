SELECT pg_cancel_backend(procpid),
       pg_terminate_backend(procpid)
FROM pg_stat_activity
WHERE usename = '<user_name>';
