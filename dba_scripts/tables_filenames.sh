#!/bin/bash

# SHOWS TABLES AND SIZES FOR ALL TABLES
# SHOULD BE RUN AS postgres user

PORT=""
USER=""

usage() {
    echo "Usage: $0 -d <dbname> [-p <port> -U <user>]"
    exit 1
}

while getopts "d:p:U:u" OPT;
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
       c.relname as table,
--       c.relkind,
       a.rolname as owner,
       d.oid as directory,
       c.relfilenode as filename,
       pg_size_pretty(pg_relation_size( quote_ident(n.nspname ) || '.' || quote_ident( c.relname ) )) as size
  FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_authid a ON ( a.oid = c.relowner ),
       pg_database d  
WHERE d.datname = current_database()
  AND relname NOT LIKE 'pg_%' 
  AND relname NOT LIKE 'information%' 
  AND relname NOT LIKE 'sql_%' 
  AND relkind = 'r'
--  AND relkind IN ('i', 'r')
ORDER BY 1, 2;

_CODE_
