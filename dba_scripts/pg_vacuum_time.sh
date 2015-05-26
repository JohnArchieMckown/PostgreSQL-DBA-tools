#!/bin/bash
# Shows vacuum time for all or selected table.

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
      U) USER="-U $OPTARG"
	 ;;
      t)  TBL="$OPTARG"
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
VER=$(psql $PORT -t $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_
)
}
getver

VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

vacuum_time() {
TIMEINFO=$(psql -q $PORT $USER $DBNAME <<_QUERY_

SELECT max(last_vacuum) - min(last_vacuum) as vacuum_time
  FROM pg_stat_all_tables s
 WHERE s.relname NOT LIKE 'pg_%'
   AND s.relname NOT LIKE 'sql_%'
   AND s.relname LIKE '%$TBL%'
 ORDER by 1;

_QUERY_

)

}

vacuum_time
echo "${TIMEINFO}"

exit 0
