#!/bin/bash

# SHOWS FOREIGN KEY COUNT FOR EACH TABLE
# THEN SHOWS FOREIGN KEYS FOR EACH TABLE

PORT=""
USER=""

usage() {
    echo "Usage: $0 -d <dbname> [-U <user> -p <port>]"
    exit 1
}

while getopts "d:p:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      p) PORT="-p $OPTARG"
	 ;;
      U) USER="-U $OPTARG"
	 ;;
      u) usage
	 ;;
    [?]) usage
   esac;
done

if [ "$DBNAME" = "" ]
  then
    usage
fi

psql $PORT $USER $DBNAME <<_CODE_

SELECT n.nspname as schema,
       t.relname as table,
       count(c.conname)
  FROM pg_class t
  JOIN pg_constraint c ON ( c.conrelid = t.OID AND c.contype = 'f')
  JOIN pg_namespace n ON (n.oid = t.relnamespace)
 WHERE relkind = 'r'
   AND t.relname NOT LIKE 'pg_%'
   AND t.relname NOT LIKE 'sql_%'
   GROUP BY 1, 2
   ORDER BY 1, 3;

SELECT n.nspname as schema,
       t.relname as table,
       c.conname as fk_name
  FROM pg_class t
  JOIN pg_constraint c ON ( c.conrelid = t.OID AND c.contype = 'f')
  JOIN pg_namespace n ON (n.oid = t.relnamespace)
 WHERE relkind = 'r'
   AND t.relname NOT LIKE 'pg_%'
   AND t.relname NOT LIKE 'sql_%'
   ORDER BY 1, 2, 3;

_CODE_
