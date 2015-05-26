SELECT n.nspname        AS schema,
       c.relname,
       t.tgname,
       p.proname	AS function_called,
--       t.tgisconstraint AS is_constraint,
--       t.tgconstrname	AS constraint_nm,
       CASE WHEN t.tgconstrrelid > 0
	    THEN (SELECT relname
		   FROM pg_class
		  WHERE oid = t.tgconstrrelid)
	    ELSE ''
	END		AS constr_tbl,
       t.tgenabled
  FROM pg_trigger t
  INNER JOIN pg_proc p	    ON ( p.oid = t.tgfoid)
  INNER JOIN pg_class c     ON (c.oid = t.tgrelid)
  INNER JOIN pg_namespace n ON  (n.oid = c.relnamespace)
  WHERE tgname NOT LIKE 'pg_%'
    AND tgname NOT LIKE 'RI_%'	-- < comment out to see constraints
--    AND t.tgenabled = FALSE
 ORDER BY 1;
