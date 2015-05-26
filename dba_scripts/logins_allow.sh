#!/bin/bash

DBNAME="postgres"
USER="-U postgres"
PORT="-p 5432"

usage() {
    echo "Usage: $0 [-d <dbname> -h <host> -U <user> -p <port> u]"
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


allow_logins()
{

CNT=$(psql $HOST $PORT $USER $DBNAME <<_QUERY_

UPDATE pg_authid au
   SET rolcanlogin = TRUE
  FROM pg_lockout lo
 WHERE au.rolname = lo.rolname;

_QUERY_

)

}

current_user()
{

CUSER=$(psql -t $HOST $PORT $USER $DBNAME <<_QUERY_

SELECT TRIM(BOTH FROM current_user);

_QUERY_

)

}



###############################################################
#			  MAIN				      #
###############################################################

current_user

if [ $CUSER != "postgres" ]
  then
    echo "You must be postgres to execute this script."
    echo "Aborting."
    exit 1
fi

allow_logins

echo "Users allowed to login = $CNT"

exit 0

