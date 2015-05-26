#!/bin/bash
# Reports sizes for all or selected database

PORT=""
USER=""
DBNAME="%"
usage() {
    echo "Usage: $0 [-d <dbname> -U <user> -p <port>]"
    exit 1
}

while getopts "d:p:uU:" OPT;
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


psql $PORT $USER postgres <<_EOF_
SELECT datname,
       rolname as owner,
       pg_size_pretty(pg_database_size(datname)  )as size_pretty,
       pg_database_size(datname) as size,
       (SELECT pg_size_pretty (SUM( pg_database_size(datname))::bigint)
	  FROM pg_database)  AS total,
       ((pg_database_size(datname) / (SELECT SUM( pg_database_size(datname))
				       FROM pg_database) ) * 100)::numeric(6,3) AS pct
  FROM pg_database d
  JOIN pg_authid a ON a.oid = datdba
  WHERE datname LIKE '%$DBNAME%'
ORDER BY datname;
_EOF_
