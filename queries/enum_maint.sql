SELECT t.typname,
       e.enumlabel,
       e.enumsortorder,
       e.enumtypid
  FROM pg_type t
  JOIN pg_enum e ON e.enumtypid = t.oid
 WHERE t.typtype = 'e'
 ORDER BY 1, enumsortorder; 

--DELETE FROM pg_enum
--WHERE enumtypid = 9999999
--  AND enumsortorder = 4;

--DELETE FROM pg_enum
--WHERE enumtypid = 9999999
--  AND enumlabel = 'medium';

--ALTER TYPE some_enum ADD VALUE 'medium' AFTER 'small';
