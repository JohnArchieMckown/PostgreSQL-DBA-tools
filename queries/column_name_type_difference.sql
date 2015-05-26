SELECT sa.nspname as schemaa,
       ca.relname as tablea,
       a.attname as columna, ta.typname,
       sb.nspname as schemab,
       cb.relname as tableb,
       a.attname as columnb, tb.typname
  FROM pg_attribute a
       JOIN pg_type ta ON (ta.oid = a.atttypid)
       JOIN pg_class ca ON (ca.oid = a.attrelid)
       JOIN pg_catalog.pg_namespace sa ON (ca.relnamespace = sa.oid),
       pg_attribute b
       JOIN pg_type tb ON (tb.oid = b.atttypid)
       JOIN pg_class cb ON (cb.oid = b.attrelid)
       JOIN pg_catalog.pg_namespace sb ON (cb.relnamespace = sb.oid)
 WHERE a.attname = b.attname
   AND ta.typname <> tb.typname
   AND ca.relname NOT LIKE 'pg_%'
   AND ca.relname NOT LIKE 'information%'
   AND ca.relname NOT LIKE 'sql_%'
   AND ca.relkind = 'r'
   AND cb.relname NOT LIKE 'pg_%'
   AND cb.relname NOT LIKE 'information%'
   AND cb.relname NOT LIKE 'sql_%'
   AND cb.relkind = 'r'
   AND 'rollback' NOT IN (sa.nspname, sb.nspname)
   AND 'id' NOT IN (a.attname, b.attname);
