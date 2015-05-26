SELECT table_schema as schema,
       table_name as table,
       column_name as column,
       column_default,
       data_type
  FROM information_schema.columns
  WHERE column_default LIKE 'nextval%'
  ORDER BY 1, 2, 3;

SELECT tbl.relname,
       col.attname,
       col.attnum
  FROM pg_attrdef def
  JOIN pg_class tbl ON tbl.oid = def.adrelid
  JOIN pg_attribute col ON col.attrelid = tbl.oid
 WHERE def.adsrc LIKE 'nextval%'
   AND col.attnum = def.adnum
 ORDER BY 1;



