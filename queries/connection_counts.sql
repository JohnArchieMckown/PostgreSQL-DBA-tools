SELECT COUNT(*)
  FROM pg_stat_activity;

SELECT usename,
       count(*)
 FROM pg_stat_activity
GROUP BY 1
ORDER BY 1;

SELECT datname,
       usename,
       count(*)
 FROM pg_stat_activity
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT usename,
       datname,
       count(*)
 FROM pg_stat_activity
GROUP BY 1, 2
ORDER BY 1, 2;
