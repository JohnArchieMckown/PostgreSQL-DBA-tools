SELECT a.rolname as role,
       u.rolname as member,
       CASE
	 WHEN m.admin_option THEN
	 'YES'
	 ELSE
	  'no'
       END as admin
FROM pg_auth_members m
JOIN pg_authid a ON (a.oid = m.roleid)
JOIN pg_authid u ON (u.oid = m.member)
ORDER BY 1, 2
