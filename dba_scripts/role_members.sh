#!/bin/bash
#Shows roles and members

PORT=""
USER="-U postgres"
DBNAME="postgres"

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

getver()
{
VER=$(psql -t $PORT $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_
)
}

getver
VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

show_members() {
MEMBERS=$(psql -q $PORT $USER $DBNAME <<_QUERY_

SELECT a.rolname as role,
       u.rolname as member,
       CASE
	 WHEN m.admin_option THEN
	 'YES'
	 ELSE
	  'no'
       END as admin
FROM pg_auth_members m
JOIN pg_authid a ON (a.oid = m.roleid)
JOIN pg_authid u ON (u.oid = m.member)
ORDER BY 1, 2

_QUERY_

)

}

show_members
echo "${MEMBERS}"

exit 0
