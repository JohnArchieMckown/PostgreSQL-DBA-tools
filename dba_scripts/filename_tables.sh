#!/bin/bash

# SHOWS TABLES AND SIZES FOR ALL TABLES
# SHOULD BE RUN AS a SUPERUSER

HOST=""
PORT=""
USER=""

usage() {
    echo "Usage: $0 -d <dbname> [-h <host> -p <port> -U <user>]"
    exit 1
}

while getopts "d:h:p:U:u" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      p) PORT="-p $OPTARG"
	 ;;
      h) HOST="-h $OPTARG"
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

psql $HOST $PORT $USER $DBNAME <<_CODE_

SELECT d.oid as directory,
       c.relfilenode as filename,
       n.nspname as schema,
       c.relname as table,
       a.rolname as owner,
       pg_size_pretty(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(c.relname))) as size
  FROM pg_class c
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_authid a ON ( a.oid = c.relowner ),
       pg_database d
WHERE d.datname = current_database()
  AND relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  AND relkind = 'r'
ORDER BY relfilenode;

_CODE_
