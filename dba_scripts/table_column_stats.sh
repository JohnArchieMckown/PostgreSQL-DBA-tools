#!/bin/bash
# Reports statistics for all tables

HOST=""
PORT=""
USER=""
TBL=""

usage() {
    echo "Usage: $0 -d <dbname> -t <table> [-h <host> -U <user> -p <port>]"
    exit 1
}

while getopts "d:h:p:t:U:u" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      h) HOST="-h $OPTARG"
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
    DBNAME="playmaker"
fi

if [ "$TBL" = "" ]
  then
    usage
fi

getver()
{
VER=$(psql -t $PORT $HOST $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_
)
}

getver

current_stats() {
STATLIST=$(psql -q $HOST $PORT $USER $DBNAME <<_QUERY_

SELECT schemaname, 
       tablename,
       attname As colname,
       n_distinct,
       array_to_string(most_common_vals, E'\n') AS common_vals,
       array_to_string(most_common_freqs, E'\n') As dist_freq
  FROM pg_stats
 WHERE tablename = '$TBL'
 ORDER BY schemaname,
	  tablename,
	  attname;

_QUERY_

)

}

##### MAIN #####
echo "HOST=$HOST"
echo "PORT=$PORT"
echo "USER=$USER"
echo "TBL=$TBL"
echo "DBNAME=$DBNAME"

current_stats
echo "${STATLIST}"

exit 0
