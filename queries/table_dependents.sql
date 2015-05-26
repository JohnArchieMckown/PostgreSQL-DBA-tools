SELECT n.nspname as schema,
       pa.relname as parent,
       ch.relname as dependent,
       cn.conname as constraint_name
  FROM pg_constraint cn
  JOIN pg_class pa ON (pa.oid = cn.confrelid)
  JOIN pg_class ch ON (ch.oid = cn.conrelid)
  JOIN pg_namespace n ON (n.oid = pa.relnamespace)
 WHERE pa.relname LIKE '%%'
   AND contype = 'f'
 ORDER BY 1, 2, 3;
