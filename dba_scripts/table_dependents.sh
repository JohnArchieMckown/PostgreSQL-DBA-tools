#!/bin/bash

USER=""
PORT=""
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
VER=$(psql $PORT -t $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_
)
}
getver

VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

get_dependents() {
DEPLIST=$(psql $PORT -q $USER $DBNAME <<_QUERY_

SELECT n.nspname as schema,
       pa.relname as parent,
       ch.relname as dependent,
       cn.conname as constraint_name
  FROM pg_constraint cn
  JOIN pg_class pa ON (pa.oid = cn.confrelid)
  JOIN pg_class ch ON (ch.oid = cn.conrelid)
  JOIN pg_namespace n ON (n.oid = pa.relnamespace)
 WHERE pa.relname LIKE '%$TBL%'
   AND contype = 'f'
 ORDER BY 1, 2, 3;

_QUERY_

)

}

get_dependents
echo "${DEPLIST}"

exit 0
