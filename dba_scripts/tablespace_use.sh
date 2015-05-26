#!/bin/bash
# Shows tablespace use for all or selected table
# that are not in default tablespace

PORT=""
USER=""
TBL="%"

usage() {
    echo "Usage: $0 -d <dbname> [-t <table> -U <user> -p <port>]"
    exit 1
}

while getopts "d:t:p:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
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
    usage
    exit 1
fi

getver()
{
VER=$(psql -t $USER $PORT $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_
)
}
getver

VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

gettstver()
{
TSTVER=$(psql  -q -t $HOST $PORT $USER $DBNAME <<_QRY_
SELECT CASE WHEN SUBSTRING(version() FROM 12 FOR 3) < '9.2'
	    THEN 'oid'
	    ELSE 'func'
	END;
_QRY_

)

TSTVER=${TSTVER:1:4}

}

gettstver

if [ "${TSTVER}" = "oid" ]
  then
    TSL="t.spclocation"
  else
    TSL="pg_tablespace_location(t.oid)"
fi

tspace_use() {
TSPACELIST=$(psql -q $USER $PORT $DBNAME <<_QUERY_

SELECT CASE WHEN t.spcname IS NULL
	    THEN 'pg_default'
	    ELSE t.spcname
	END as tablespace,
       $TSL as location,
       n.nspname as schema,
       c.relname as relation,
       a.rolname as owner,
       c.relkind as type
  FROM pg_class c
  LEFT JOIN pg_tablespace t ON (t.oid = c.reltablespace)
  JOIN pg_authid a ON ( a.oid = c.relowner )
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
 WHERE relname LIKE '%$TBL%'
   AND relkind IN ('i', 'r')
   AND c.relname NOT LIKE 'pg_%'
   AND c.relname NOT LIKE 'sql_%'
 ORDER BY 1, 2;

_QUERY_

)

}

tspace_use
echo "${TSPACELIST}"

exit 0
