-- Returns all columns for a specified table
SELECT c.relname as table,
       a.attname as column
  FROM pg_class c
  JOIN pg_attribute a ON ( a.attrelid = c.oid )
 WHERE relname = '<table>'
   AND attnum > 0
   AND NOT attisdropped
 ORDER BY attnum;
