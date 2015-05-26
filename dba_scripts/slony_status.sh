#!/bin/bash

PORT=""

usage() {
    echo "Usage: $0 [-p <port>]"
    exit 1
}

while getopts "p:u" OPT;
do case "${OPT}" in
      p) PORT="-p $OPTARG"
	 ;;
      u) usage
	 ;;
    [?]) usage
   esac;
done


getver()
{
VER=$(psql $PORT -t -U postgres postgres <<_QRYVER_
SELECT version();
_QRYVER_
)
}
getver

VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

slony_status() {
STATUS=$(psql $PORT -q <<_QUERY_

BEGIN;

SELECT st_origin as org,
       st_last_event as last_event,
       st_lag_num_events as lag_events,
       st_lag_time
  FROM _slony.sl_status;

COMMIT;

_QUERY_

)

}

slony_status
echo "${STATUS}"

exit 0
