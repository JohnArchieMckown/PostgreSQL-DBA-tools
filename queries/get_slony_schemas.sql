SELECT nspname AS "Schema Name"
  FROM pg_namespace nsp
  JOIN pg_proc pro ON pronamespace=nsp.oid AND proname = 'slonyversion'
 ORDER BY nspname;
