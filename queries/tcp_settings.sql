SELECT name, setting, short_desc
  FROM pg_settings
 WHERE name LIKE 'tcp%';

