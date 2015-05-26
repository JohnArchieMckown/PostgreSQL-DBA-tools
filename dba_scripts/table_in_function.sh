#!/bin/bash

# Shows functions that specified table occurs in

USER=""
PORT=""

usage() {
    echo "Usage: $0 -d <dbname> -t <table> [-U <user> -p <port>]"
    exit 1
}

while getopts "d:t:p:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      t) TBL=$OPTARG
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
    DBNAME="enf"
fi

if [ "$TBL" = "" ]
  then
    usage
    exit 1
fi

echo "$TBL"

psql $USER $PORT $DBNAME <<_CODE_
SELECT p.proname,
       CASE WHEN p.proretset = TRUE
	    THEN 'SET OF '
	    ELSE ''
	END ||
       UPPER( (SELECT typname
	  FROM pg_type
	 WHERE oid = p.prorettype) ) AS return_type,
       proargnames as parameters
  FROM pg_proc p
 WHERE prosrc LIKE '%$TBL%'
 ORDER BY p.proname;

_CODE_

exit 0
