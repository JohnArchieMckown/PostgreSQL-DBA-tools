#!/bin/bash

DBNAME="postgres"
USER="-U postgres"
PORT="-p 5432"

usage() {
    echo "Usage: $0 [-d <dbname> -h <host> -U <user> -p <port> u]"
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


set $(date '+%m%d')
MMDD=$1

LOGDIR='/var/log/postgresql'

getver()
{
VER=$(psql $HOST $PORT $USER $DBNAME <<_QUERY_
SELECT version();

_QUERY_

)

#VER=$(cat ${PGDATA}/PG_VERSION)
#use next line only if PGDATA has version in path
#VER=$(echo $PGDATA | cut -d / -f 5)
}

clear

getver
echo "PostgreSQL Version is $VER"

connect_cnts() {
DBLIST=$(psql -q -t $HOST $PORT $USER $DBNAME <<_QUERY_

SELECT d.datname
  FROM pg_database d
 WHERE datallowconn = TRUE
   AND datistemplate = FALSE
 ORDER BY 1;

_QUERY_

)


}

get_cnt() {


CNT=$(psql -t $PORT $USER $DBNAME <<_QUERY_

/*
SELECT count(*)
  FROM pg_stat_activity
 WHERE datname = '$DB';
*/
SELECT usename,
       count(*)
  FROM pg_stat_activity
 WHERE datname = '$DB'
  GROUP BY usename;


_QUERY_
)

}

all_count() {
CNT=$(psql -t $PORT $USER $DBNAME <<_QUERY_

SELECT count(*)
  FROM pg_stat_activity;

_QUERY_
)

}

###############################################################
#			  MAIN				      #
###############################################################

connect_cnts

for DB in $DBLIST;
do
 echo -n "$DB "
get_cnt
# grep -E -c "$DB.*connection auth" #LOGDIR/postgresql.${MMDD}
echo -e "\t$CNT"
done

all_count
echo
echo -e "TOTAL \t\t$CNT"

#exit 0

#echo "$(hostname -f) CONNECTION COUNTS"
#echo "Current log file is: $logdir/postgresql.$MMDD"
#echo

#for DB in $DBLIST
#    do
#	 echo -n "$DB: "
#	 grep 'connection authorized' $LOGDIR/postgresql.${MMDD} | grep -c "$DB"
#done
#exit 0
