SELECT n.nspname,
       c.relname,
       array_to_string(ARRAY[c.relacl], '|') as permits,
       position('<USERNAME>' in array_to_string(ARRAY[relacl], '|'))
  FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE n.nspname not like 'pg_%'
  AND n.nspname not like 'inform_%'
  AND relkind = 'r'
  AND (position('<USERNAME>' in array_to_string(ARRAY[relacl], '|')) > 0
  OR  position( (SELECT g.rolname
		 FROM pg_auth_members r
		 JOIN pg_authid g ON (r.roleid = g.oid)
		 JOIN pg_authid u ON (r.member = u.oid)
		  AND u.rolname LIKE '%<USERNAME>%') in array_to_string(ARRAY[relacl], '|')) > 0 )
ORDER BY 1;
