#!/bin/bash
# Disables or Enables connections to specified database

PORT=""
USER=""

usage() {
    echo "Usage: $0 -d <dbname> [-p <port> -U <user>]"
    echo Database name to disable/enable is required
    exit 1
}

while getopts "d:p:U:u" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
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
    usage
    exit 1
fi

if [ $DBNAME == "postgres" ]
  then
    echo Disable of postgres is prohibited
    exit
fi

echo changing $DBNAME

psql $PORT $USER -v ON_ERROR_STOP=on postgres  <<_EOF_
SELECT datname, datallowconn
  FROM pg_database
  WHERE datname = '$DBNAME' ;

UPDATE pg_database
  SET datallowconn = CASE
		     WHEN datallowconn = TRUE THEN
		       FALSE
		     ELSE
		       TRUE
		     END
WHERE datname = '$DBNAME' ;

SELECT datname, datallowconn
  FROM pg_database
    WHERE datname = '$DBNAME' ;

\echo Connect status for $DBNAME has been reversed

_EOF_

