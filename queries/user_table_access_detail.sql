SELECT n.nspname,
       c.relname,
       CASE WHEN has_table_privilege('<CKUSER>', n.nspname || '.' || c.relname, 'SELECT')
	    THEN 'YES'
	    ELSE 'no'
	END AS select,
       CASE WHEN has_table_privilege('<CKUSER>', n.nspname || '.' || c.relname, 'INSERT')
	    THEN 'YES'
	    ELSE 'no'
	END AS insert,
       CASE WHEN has_table_privilege('<CKUSER>', n.nspname || '.' || c.relname, 'UPDATE')
	    THEN 'YES'
	    ELSE 'no'
	END AS update,
       CASE WHEN has_table_privilege('<CKUSER>', n.nspname || '.' || c.relname, 'DELETE')
	    THEN 'YES'
	    ELSE 'no'
	END AS delete,
       array_to_string(ARRAY[c.relacl], '|') as permits
  FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE n.nspname not like 'pg_%'
  AND n.nspname not like 'inform_%'
  AND relkind = 'r'
/*
  AND (position('$CKUSER' in array_to_string(ARRAY[relacl], '|')) > 0
  OR  position( (SELECT g.rolname
		 FROM pg_auth_members r
		 JOIN pg_authid g ON (r.roleid = g.oid)
		 JOIN pg_authid u ON (r.member = u.oid)
		  AND u.rolname LIKE '$CKUSER%') in array_to_string(ARRAY[relacl], '|')) > 0 )
*/
ORDER BY 1, 2;
