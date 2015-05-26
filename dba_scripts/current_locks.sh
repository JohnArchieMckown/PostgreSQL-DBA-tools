#!/bin/bash

USER="-U postgres"
PORT="-p 5432"

usage() {
    echo "Usage: $0 -d <dbname> [-h <host> -U <user> -p <port>]"
    exit 1
}

while getopts "d:h:p:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      h) HOST="-h $OPTARG"
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
    DBNAME="postgres"
fi

#Column names changed from procpid $ current_query to pid & query from 9.2 up
gettstver()
{
TSTVER=$(psql  -q -t $HOST $PORT $USER $DBNAME <<_QRY_
SELECT CASE WHEN SUBSTRING(version() FROM 12 FOR 3) < '9.2'
	    THEN 'procpid'
	    ELSE 'pid'
	END;
_QRY_

)

TSTVER=${TSTVER:1:7}

}

gettstver

if [ "${TSTVER}" = "procpid" ]
  then
    COL="procpid"
    QRY="current_query"
  else
    COL="pid"
    QRY="query"
fi


getver()
{
VER=$(psql -t $HOST $PORT $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_
)
}

getver
VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

current_locks() {
LCKLIST=$(psql -q $HOST $PORT $USER $DBNAME <<_QUERY_

SELECT l.database,
       d.datname,
       l.relation,
       n.nspname,
       c.relname,
       l.pid,
       a.usename,
       l.locktype,
       l.mode,
       l.granted,
       l.tuple
  FROM pg_locks l
  JOIN pg_class c ON (c.oid = l.relation)
  JOIN pg_database d ON (CASE WHEN l.database = 0 THEN d.oid = 0 ELSE d.oid = l.database END)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_stat_activity a ON (a.$COL = l.pid)
ORDER BY l.database,
	 l.relation,
	 l.pid;

_QUERY_

)

}

if [ "$DBNAME" = "" ]
  then
    usage
fi

current_locks
echo "${LCKLIST}"

exit 0
