SELECT datname,
       pg_size_pretty(pg_database_size(datname))as size_pretty,
       pg_database_size(datname) as size,
       (SELECT pg_size_pretty (SUM( pg_database_size(datname))::bigint)
	  FROM pg_database)  AS total,
       ((pg_database_size(datname) / (SELECT SUM( pg_database_size(datname))
				       FROM pg_database) ) * 100)::numeric(6,3) AS pct
  FROM pg_database
  ORDER BY datname;
