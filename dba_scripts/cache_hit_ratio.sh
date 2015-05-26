#!/bin/bash
# Shows cache hit ratio for all databases

USER=""
PORT=""
DBNAME="postgres"

usage() {
    echo "Usage: $0 [-d <dbname> -h <host> -U <user> -p <port>]"
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
    usage
    exit 1
fi

psql $USER $HOST $PORT $DBNAME <<_EOF_
SELECT pg_stat_database.datname,
       pg_stat_database.blks_read,
       pg_stat_database.blks_hit,
       round((pg_stat_database.blks_hit::double precision
	      / (pg_stat_database.blks_read
		 + pg_stat_database.blks_hit
		 +1)::double precision * 100::double precision)::numeric, 2) AS cachehitratio
   FROM pg_stat_database
  WHERE pg_stat_database.datname !~ '^(template(0|1)|postgres)$'::text
  ORDER BY round((pg_stat_database.blks_hit::double precision
		 / (pg_stat_database.blks_read
		    + pg_stat_database.blks_hit
		    + 1)::double precision * 100::double precision)::numeric, 2) DESC;
_EOF_
