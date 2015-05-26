SELECT pg_postmaster_start_time() as pg_start,
       current_timestamp - pg_postmaster_start_time() as runtime;
