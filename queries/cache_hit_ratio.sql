SELECT pg_stat_database.datname,
       pg_stat_database.blks_read,
       pg_stat_database.blks_hit,
       round((pg_stat_database.blks_hit::double precision
	      / (pg_stat_database.blks_read
		 + pg_stat_database.blks_hit
		 +1)::double precision * 100::double precision)::numeric, 2) AS cachehitratio
   FROM pg_stat_database
  WHERE pg_stat_database.datname !~ '^(template(0|1)|postgres)$'::text
  ORDER BY round((pg_stat_database.blks_hit::double precision
		 / (pg_stat_database.blks_read
		    + pg_stat_database.blks_hit
		    + 1)::double precision * 100::double precision)::numeric, 2) DESC;
