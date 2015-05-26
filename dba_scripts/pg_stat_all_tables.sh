#!/bin/bash
# Reports statistics for all tables

PORT=""
USER=""
TBL=""

usage() {
    echo "Usage: $0 -d <dbname> [-t <table> -U <user> -p <port>]"
    exit 1
}

while getopts "d:p:t:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      p) PORT="-p $OPTARG"
	 ;;
      t) TBL=$OPTARG
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

getver()
{
VER=$(psql -t $PORT $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_
)
}
getver

VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

if [ "${VER:11:3}"  \< "8.3" ]
  then
    QRY="SELECT n.nspname as schema,
       s.relname as table,
       c.reltuples::bigint,
       n_tup_ins,
       n_tup_upd,
       n_tup_del,
       date_trunc('second', last_vacuum) as last_vacuum,
       date_trunc('second', last_autovacuum) as last_autovacuum,
       date_trunc('second', last_analyze) as last_analyze,
       date_trunc('second', last_autoanalyze) as last_autoanalyze
  FROM pg_stat_all_tables s
  JOIN pg_class c ON c.oid = s.relid
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
 WHERE s.relname NOT LIKE 'pg_%'
   AND s.relname NOT LIKE 'sql_%'
   AND s.relname LIKE '%$TBL%'
  ORDER by 1, 2;"
else
  QRY="SELECT n.nspname as schema,
       s.relname as table,
       c.reltuples::bigint,
       n_live_tup,
       n_tup_ins,
       n_tup_upd,
       n_tup_del,
       date_trunc('second', last_vacuum) as last_vacuum,
       date_trunc('second', last_autovacuum) as last_autovacuum,
       date_trunc('second', last_analyze) as last_analyze,
       date_trunc('second', last_autoanalyze) as last_autoanalyze
  FROM pg_stat_all_tables s
  JOIN pg_class c ON c.oid = s.relid
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
 WHERE s.relname NOT LIKE 'pg_%'
   AND s.relname NOT LIKE 'sql_%'
   AND s.relname LIKE '%$TBL%'
  ORDER by 1, 2;"
fi

current_stats() {
STATLIST=$(psql -q $PORT $USER $DBNAME <<_QUERY_

${QRY}

_QUERY_

)

}

current_stats
echo "${STATLIST}"

exit 0
