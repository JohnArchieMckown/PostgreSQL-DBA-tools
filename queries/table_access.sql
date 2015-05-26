--r=SELECT
--r=SELECT
--a=INSERT
--w=UPDATE
--d=DELETE
--x=REFERENCES

SELECT n.nspname as schema,
       c.relname,
       array_to_string(c.relacl, '  ')
  FROM pg_class c
   JOIN pg_namespace n ON (n.oid = c.relnamespace)
 WHERE c.relkind = 'r'
   AND n.nspname = 'public'
 ORDER BY c.relname;

