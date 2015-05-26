#!/bin/bash
# Shows comments for all or specified table

USER=""
PORT=""
TBL=""

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
fi

getver()
{
VER=$(psql $PORT -t $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_
)
}
getver

VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

QRY="SELECT DISTINCT ON (c.relname)
       n.nspname as schema,
       c.relname,
       a.rolname as owner,
       0 as col_seq,
       '' as column,
       d.description as comment
  FROM pg_class c
LEFT  JOIN pg_attribute col ON (col.attrelid = c.oid)
LEFT  JOIN pg_description d ON (d.objoid = col.attrelid AND d.objsubid = 0)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_authid a ON ( a.OID = c.relowner )
  WHERE n.nspname NOT LIKE 'information%'
  AND relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  AND relname LIKE '%$TBL%'
  AND relkind = 'r'
--  AND d.description IS NOT NULL
UNION
SELECT n.nspname as schema,
       c.relname,
       '' as owner,
       col.attnum as col_seq,
       col.attname as column,
       d.description
  FROM pg_class c
  JOIN pg_attribute col ON (col.attrelid = c.oid)
  LEFT JOIN pg_description d ON (d.objoid = col.attrelid AND d.objsubid = col.attnum)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_authid a ON ( a.OID = c.relowner )
WHERE n.nspname NOT LIKE 'information%'
  AND relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  AND relname LIKE '%$TBL%'
  AND relkind = 'r'
--  AND d.description IS NOT NULL
  AND col.attnum >= 0
ORDER BY 1, 2, 4;"

current_stats() {
STATLIST=$(psql $USER $PORT -q $DBNAME <<_QUERY_

${QRY}

_QUERY_

)

}

current_stats
echo "${STATLIST}"

exit 0
