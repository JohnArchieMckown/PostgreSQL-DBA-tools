SELECT p.proname,
       CASE WHEN p.proretset = TRUE
	    THEN 'SET OF '
	    ELSE ''
	END ||
       UPPER( (SELECT typname
	  FROM pg_type
	 WHERE oid = p.prorettype) ) AS return_type,
       proargnames as parameters
  FROM pg_proc p
 WHERE prosrc ILIKE ('%<TABLE/COLUMN>%')
   AND proname NOT LIKE 'pg%'
 ORDER BY p.proname;
