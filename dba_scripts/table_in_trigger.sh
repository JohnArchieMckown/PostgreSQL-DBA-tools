#!/bin/bash

# Shows trigger functions that specified table occurs in

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
SELECT c.relname,
       t.tgname,
       p.proname
  FROM pg_proc p
  JOIN pg_trigger t ON (t.tgfoid = p.oid)
  JOIN pg_class c ON (c.oid = t.tgrelid)
 WHERE prosrc LIKE ('%$TBL%')
 ORDER BY c.relname;
_CODE_

exit 0
