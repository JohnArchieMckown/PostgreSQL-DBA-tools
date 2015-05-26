--SELECT DISTINCT (c.data_type),
--	 COALESCE(character_maximum_length::text, 'N/A'),
--	 c.numeric_precision,
--	 c.numeric_scale
--  FROM information_schema.columns c;

SELECT c.table_schema as schema,
       c.table_name as table,
       c.column_name as column,
       c.data_type as type,
       case when c.data_type LIKE '%char%'
	      then COALESCE(character_maximum_length::text, 'N/A')
	    when c.data_type LIKE '%numeric%'
	      then  '(' || c.numeric_precision::text || ', ' || c.numeric_scale::text || ')'
	    when c.data_type LIKE '%int%'
	      then  c.numeric_precision::text
	 else COALESCE(character_maximum_length::text, 'N/A')
       end as size
  FROM information_schema.columns c
WHERE c.table_schema NOT LIKE 'pg_%'
  AND c.table_schema NOT LIKE 'information%'
  AND c.table_name NOT LIKE 'sql_%'
  AND c.data_type LIKE '%<TYPE>%'
  AND c.is_updatable = 'YES'
ORDER BY c.table_name, c.column_name;

