SELECT rel.relname,
       con.conname,
       con.contype,
       con.consrc
  FROM pg_class rel
  JOIN pg_constraint con ON (con.conrelid = rel.oid)
 --WHERE contype = 'f'
 ORDER by relname,
	  contype,
	  conname;
