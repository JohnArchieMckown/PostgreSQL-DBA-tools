SELECT g.rolname as group,
       u.rolname as user,
       r.admin_option as admin,
       g.rolsuper as g_super,
       u.rolsuper as u_super
  FROM pg_auth_members r
  JOIN pg_authid g ON (r.roleid = g.oid)
  JOIN pg_authid u ON (r.member = u.oid)
  WHERE u.rolsuper = TRUE
     OR g.rolsuper = TRUE
  ORDER BY 1, 2;

