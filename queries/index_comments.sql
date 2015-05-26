SELECT n.nspname as schema,
       c.relname,
       d.description as comment
       FROM pg_class c
      LEFT JOIN pg_description d ON (d.objoid = c.oid)
      JOIN pg_namespace n ON (n.oid = c.relnamespace)
     WHERE n.nspname NOT LIKE 'information%'
       AND relname NOT LIKE 'pg_%'
       AND relname NOT LIKE 'information%'
       AND relname NOT LIKE 'sql_%'
--	 AND relname LIKE '%IDX%'
       AND relkind = 'i'
       AND d.description IS NOT NULL
     ORDER BY 2;
