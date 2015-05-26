SELECT n.nspname as schema,
       c.relname as table,
       a.rolname as owner,
       c.relacl as permits
  FROM pg_class c
  JOIN pg_namespace n ON ( n.oid = c.relnamespace )
  JOIN pg_authid a ON ( a.OID = c.relowner )
WHERE relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  AND relkind = 'r'
  --AND position('cp' in ARRAY_TO_STRING(c.relacl, '') )> 0
ORDER BY n.nspname,
         c.relname;

