#!/bin/bash

# if arguments > 0, set count option

if [ $# -eq 0 ]
  then
    cntflg='-c'
else
    cntflg=''
fi

set $(date '+%m%d')
MMDD=$1

#set $(date)
## if day number less than 10, prefix a '0'
#if [ $3 -le 9 ]
#  then
#    DD=0${3}
#  else
#    DD=${3}
#fi

set $(date +%m)
MM=${1}
logdir=/var/log/postgresql/

echo "Current error log is: ${logdir}postgresql.${MMDD}"
echo
echo -n "ERROR: "
grep ${cntflg} -i ERROR   ${logdir}postgresql.${MMDD}
echo -n "WARNING: "
grep ${cntflg} -i WARNING ${logdir}postgresql.${MMDD}
echo -n "pg_hba: "
grep ${cntflg} -i pg_hba  ${logdir}postgresql.${MMDD}
