BACKFILE=pgbackup.`date +%C%y%m%d%H%M`
pg_dump  -f /home/pgsql/backup/$BACKFILE -F c postgres

