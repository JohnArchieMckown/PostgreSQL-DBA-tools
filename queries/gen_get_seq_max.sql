SELECT 'SELECT ''' || relname || ''' ,
       (SELECT max_value FROM ' || relname || ');'
  FROM pg_class
 WHERE relkind = 'S';
