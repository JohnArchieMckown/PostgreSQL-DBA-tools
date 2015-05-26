SELECT n.nspname as schema,
       t.typname as enum,
       e.enumsortorder as order,
       e.enumlabel as value,
       t.oid as oid
  FROM pg_type t
  JOIN pg_namespace n ON ( n.oid = t.typnamespace )
  JOIN pg_enum e ON ( e.enumtypid = t.oid )
 WHERE typtype = 'e'
 ORDER BY 1, 2, 3;

