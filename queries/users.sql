SELECT rolname as user,
       CASE WHEN rolcanlogin THEN 'user'
	    ELSE 'group'
       END,
       CASE WHEN rolsuper THEN 'SUPERUSER'
	    ELSE 'normal'
	END AS super
  FROM pg_authid
ORDER BY rolcanlogin ,
	 rolname;
