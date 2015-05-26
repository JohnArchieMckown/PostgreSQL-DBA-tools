#!/bin/bash

psql -U postgres postgres <<_EOF_
SELECT g.rolname as group,
       u.rolname as user,
       r.admin_option,
       CASE WHEN g.rolsuper = TRUE
	    THEN 'SUPERUSER'
	    ELSE 'f'
	END as g_super,
       CASE WHEN u.rolsuper = TRUE
	    THEN 'SUPERUSER'
	    ELSE 'f'
	END as u_super
  FROM pg_auth_members r
  JOIN pg_authid g ON (r.roleid = g.oid)
  JOIN pg_authid u ON (r.member = u.oid)
  ORDER BY 1;
_EOF_
