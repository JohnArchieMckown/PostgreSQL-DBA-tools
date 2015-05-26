#!/bin/bash

#Shows commnets on all or selected index

USER=""
PORT=""

usage() {
    echo "Usage: $0 -d <dbname> [-i <index> -U <user> -p <port>]"
    exit 1
}

while getopts "d:i:p:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      i) IDX=$OPTARG
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

QRY="SELECT quote_ident(n.nspname) as schema,
       quote_ident(c.relname),
       d.description as comment
       FROM pg_class c
      LEFT JOIN pg_description d ON (d.objoid = c.oid)
      JOIN pg_namespace n ON (n.oid = c.relnamespace)
     WHERE n.nspname NOT LIKE 'information%'
       AND relname NOT LIKE 'pg_%'
       AND relname NOT LIKE 'information%'
       AND relname NOT LIKE 'sql_%'
       AND relname LIKE '%$IDX%'
       AND relkind = 'i'
       AND d.description IS NOT NULL
     ORDER BY 2;"

current_stats() {
STATLIST=$(psql $PORT -q $USER $DBNAME <<_QUERY_

${QRY}

_QUERY_

)

}

current_stats
echo "${STATLIST}"

exit 0
