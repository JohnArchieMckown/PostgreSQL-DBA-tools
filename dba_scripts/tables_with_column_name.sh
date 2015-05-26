#!/bin/bash

# SHOWS ALL TABLES WITH A COLUMN NAME LIKE <ColumnName>

USER=""
PORT=""

usage() {
    echo "Usage: $0 -d <dbname> -c <colname> [-U <user> -p <port>]"
    exit 1
}

while getopts "d:c:p:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      p) PORT="-p $OPTARG"
	 ;;
      c) COLNAME="$OPTARG"
	 ;;
      U) USER="-U $OPTARG"
	 ;;
      u) usage
	 ;;
    [?]) usage
   esac;
done

echo "col=$COLNAME"
if [ "$DBNAME" = "" ]
  then
    DBNAME="enf"
fi

if [ "$COLNAME" = "" ]
  then
    usage
    exit 1
fi

psql -a $USER $PORT $DBNAME <<_CODE_

SELECt c.table_schema as schema,
       c.table_name as table,
       c.column_name as column,
       c.data_type as type,
       case when c.data_type LIKE '%char%'
	      then COALESCE(character_maximum_length::text, 'N/A')
	    when c.data_type LIKE '%numeric%'
	      then  '(' || c.numeric_precision::text || ', ' || c.numeric_scale::text || ')'
	    when c.data_type LIKE '%int%'
	      then  c.numeric_precision::text
	    else COALESCE(character_maximum_length::text, 'N/A')
       end as size
  FROM information_schema.columns c
 WHERE c.table_schema NOT LIKE 'pg_%'
   AND c.table_schema NOT LIKE 'information%'
   AND c.table_name NOT LIKE 'sql_%'
   AND c.column_name LIKE '%$COLNAME%'
   AND c.is_updatable = 'YES'
ORDER BY c.table_name, c.column_name;

_CODE_

exit 0
