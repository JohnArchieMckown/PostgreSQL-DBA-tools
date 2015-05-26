#!/bin/bash

usage() {
    echo "Usage: $0 [-h <host> -p <port>]"
    echo "-p will default to 5432"
    exit 1
}

while getopts "h:p:" OPT;
do case "${OPT}" in
      h) HOST="-h $OPTARG"
	 ;;
      p) PORT="-p $OPTARG"
	 ;;
      u) usage
	 ;;
    [?]) usage
   esac;
done

getver()
{
VER=$(psql -t $HOST $PORT -U postgres <<_QRYVER_
SELECT substring(version() from 12 for 1);
_QRYVER_
)
}

cancel_pids()
{
psql -t $HOST $PORT -U postgres <<_QRYVER_
--SELECT pg_cancel_backend($PID)
SELECT pg_terminate_backend($PID)
  FROM pg_stat_activity WHERE pg_backend_pid() <> $PID);
_QRYVER_

}

##### MAIN #####

getveri
declare -i VER
if [ "$VER" -lt 9 ]
  then
    PID="procpid"
  else
    PID="pid"
fi
cancel_pids

exit 0;

