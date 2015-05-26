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

SELECT quote_ident(N.nspname),
       quote_ident(T.relname) AS "table",
       quote_ident(C.relname) AS idx_name,
       round(100 * pg_relation_size(indexrelid) / pg_relation_size(indrelid) ) / 100 AS "index_ratio %",
       pg_size_pretty(pg_relation_size(indexrelid) ) AS index_size,
       pg_size_pretty(pg_relation_size(indrelid) )   AS table_size_size
  FROM pg_index I
  LEFT JOIN pg_class C ON (c.oid = I.indexrelid)
  LEFT JOIN pg_class T ON (T.oid = I.indrelid)
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
 WHERE nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
   AND c.relkind = 'i'
   AND pg_relation_size(indrelid) > 0
   AND C.relname LIKE '%$TBL%'
 ORDER BY 4 DESC, 2;

_CODE_
