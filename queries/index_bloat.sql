SELECT N.nspname,
       T.relname AS "table",
       C.relname AS idx_name,
       round(100 * pg_relation_size(indexrelid) / pg_relation_size(indrelid) ) / 100 AS "index_ratio %",
       pg_size_pretty(pg_relation_size(indexrelid) ) AS index_size,
       pg_size_pretty(pg_relation_size(indrelid) )   AS table_size_size
  FROM pg_index I
  LEFT JOIN pg_class C ON (c.oid = I.indexrelid)
  LEFT JOIN pg_class T ON (T.oid = I.indrelid)
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
 WHERE nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
   AND c.relkind = 'i'
   AND pg_relation_size(indrelid) > 0
 ORDER BY 4 desc, 1;

