SELECT 'ALTER INDEX ' || i.indexrelname
	 || ' SET TABLESPACE <new_table_space>;'
  FROM pg_stat_all_indexes i
  JOIN pg_class c ON (c.oid = i.relid)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_index idx ON (idx.indexrelid =  i.indexrelid )
 WHERE n.nspname = 'public'
 ORDER BY 1;
