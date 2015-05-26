#!/bin/bash

# SHOWS TABLES AND SIZES FOR ALL TABLES
# SHOULD BE RUN AS SUPERUSER

PORT=""
USER=""
TBL=""

usage() {
    echo "Usage: $0 -d <dbname> [-t <table> -p <port> -U <user>]"
    exit 1
}

while getopts "d:p:t:U:u" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      p) PORT="-p $OPTARG"
	 ;;
      t) TBL="$OPTARG"
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
    exit 1
fi

psql $PORT $USER $DBNAME <<_CODE_

SELECT n.nspname as schema,
       c.relname as table,
       a.rolname as owner,
       d.oid as directory,
       c.relfilenode as filename,
       c.reltuples::integer,
       pg_size_pretty(pg_relation_size( quote_ident( n.nspname ) || '.' || quote_ident( c.relname ) )) as size,
       pg_size_pretty(pg_relation_size( quote_ident( n.nspname ) || '.' || quote_ident( c.relname ) )  
                   +  pg_relation_size(   i.indexrelid   ) ) as total_size,
       pg_relation_size( quote_ident( n.nspname ) || '.' || quote_ident( c.relname ) ) as size_bytes,
       pg_total_relation_size( quote_ident( n.nspname ) || '.' || quote_ident( c.relname ) ) as total_size_bytes,
       CASE WHEN c.reltablespace = 0
	    THEN 'pg_default'
	    ELSE (SELECT t.spcname
		    FROM pg_tablespace t WHERE (t.oid = c.reltablespace) )
	END as tablespace
  FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_index i  ON (i.indrelid = c.oid ) 
  JOIN pg_authid a ON ( a.oid = c.relowner ),
       pg_database d
WHERE d.datname = current_database()
  AND relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  AND relname LIKE '%$TBL%'
  AND relkind = 'r'
ORDER BY 9 DESC, 1, 2;

_CODE_
