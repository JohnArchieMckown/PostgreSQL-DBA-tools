SELECT c.relname as table,
       t.tgname as tg_name,
       p.proname as tg_function
  FROM pg_proc p
  JOIN pg_trigger t ON (t.tgfoid = p.oid)
  JOIN pg_class c ON (c.oid = t.tgrelid)
 WHERE prosrc LIKE ('%<table>%')
 ORDER BY c.relname;

