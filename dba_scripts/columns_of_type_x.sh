#!/bin/bash
# Shows tables and columns that are of type specified

PORT=""
USER=""
COLTYPE="?"

usage() {
    echo "Usage: $0 -d <dbname> -t <coltype> [-h <host> -U <user> -p <port>]"
    exit 1
}

while getopts "d:t:h:p:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
	 ;;
      h) HOST="-h $OPTARG"
	 ;;
      p) PORT="-p $OPTARG"
	 ;;
      t) COLTYPE="$OPTARG"
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
    DBNAME="postgres"
fi

choose_qry ()
{

if [ "$COLTYPE" = "?" ]
  then
     echo "Usage: $0 -d <dbname> -t <coltype> [-h <host> -U <user> -p <port>]"
     echo
     echo "Available Data Types"
     QRY="SELECT DISTINCT (c.data_type)
      FROM information_schema.columns c
      ORDER BY c.data_type;"
else
     QRY="SELECT quote_ident(c.table_schema) as schema,
	   quote_ident(c.table_name) as table,
	   quote_ident(c.column_name) as column,
	   c.data_type as type,
	   case when c.data_type LIKE '%char%'
		    then COALESCE(character_maximum_length::text, 'N/A')
		    when c.data_type LIKE '%numeric%'
		    then '(' || c.numeric_precision::text || ', ' || c.numeric_scale::text || ')'
		    when c.data_type LIKE '%int%'
		    then c.numeric_precision::text
		    else COALESCE(character_maximum_length::text, 'N/A')
	   end as size
      FROM information_schema.columns c
     WHERE c.table_schema NOT LIKE 'pg_%'
       AND c.table_schema NOT LIKE 'information%'
       AND c.table_name NOT LIKE 'sql_%'
       AND c.data_type LIKE '%$COLTYPE%'
       AND c.is_updatable = 'YES'
    ORDER BY 1, 2, 3;"
fi

psql $HOST $USER $PORT $DBNAME <<_CODE_

${QRY}

_CODE_

}

choose_qry
