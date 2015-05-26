#!/bin/bash

DBNAME="postgres"
USER="-U postgres"
PORT="-p 5432"
SLEEPTIME=5
CANCEL="F"
NOIDLE=""

usage() {
    echo "Usage: $0 [-s <sleeptime> -d <dbname> -h <host> -U <user> -p <port> -x -i]"
    echo "-x will exit after 1 iteration"
    echo "-i will exclude <IDLE> queries"
    exit 1
}

while getopts "d:s:h:p:uU:xi" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      s) SLEEPTIME=$OPTARG
	 ;;
      h) HOST="-h $OPTARG"
	 ;;
      p) PORT="-p $OPTARG"
	 ;;
      U) USER="-U $OPTARG"
	 ;;
      x) CANCEL="T"
	 ;;
      i) NOIDLE="AND current_query <> '<IDLE>'"
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

getver() {
VER=$(psql  -q -t $HOST $PORT $USER $DBNAME <<_VER_

SELECT SUBSTR(version(), 1, 16);

_VER_

)

}

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

getver
echo "$VER"
sleep 2

current_qry() {
QRYLIST=$(psql -q $HOST $PORT $USER $DBNAME <<_QUERY_

SELECT datname,
       $COL as pid,
--	 procpid as pid,
       client_addr,
       usename as user,
--	 regexp_replace(current_query, '	(..)', ' ', 'g') as query,
       regexp_replace($QRY, '	(..)', ' ', 'g') as query,
       waiting,
       query_start,
       clock_timestamp() - query_start as duration
  FROM pg_stat_activity
 --WHERE procpid != pg_backend_pid()
 WHERE $COL != pg_backend_pid()
  $NOIDLE
ORDER BY datname,
	 query_start;

_QUERY_

)

}

#### MAIN ####

while [ 1 -ge 0 ]
do
  clear
  current_qry
  echo "${QRYLIST}"
  if [ "$CANCEL" = "T" ]
    then
    exit 0
  fi
  echo "Sleeping $SLEEPTIME"
  sleep $SLEEPTIME
done

