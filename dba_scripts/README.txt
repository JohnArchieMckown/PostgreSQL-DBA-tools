These scripts should work on all versions of PostgreSQL up to 9.4
Most have options to specify host and port.
./<script> -h shows all options

cache_hit_ratio.sh -> Shows the cache hit ration for all databases 
cancel_all_queries.sh -> Terminates all queries in progress
check_postgresql_log.sh -> greps the postgres log file for ERROR, WARNING and ref's to pg_hba. You will probably need to edit and adjust the directory path  and suffix for your cluster.
columns_of_type_x -> Shows all tables and columns with specific character type
connect_count.sh -> Shows connection count for each database
current_locks.sh -> Shows status for all current locks
current_queries.sh -> Shows information on all current queries, will loop continuously unless -x option is specified. -s option specifies sleeptime, default is 5 secs. -i will ignore <IDLE> queries
database_sizes.sh -> shows size of all databases 
filename_tables.sh -> shows physical directory, filename, owner & size for all tables in specified database

flip_database_connect.sh -> Flips state of datallowconn for database

get_trans_min_cnt.sh -> shows transaction count per minute for cluster
groups_users.sh -> shows all groups & members in cluster and if group or user is a superuser
index_bloat.sh -> shows index ration to table size for all indexes of all or specified table in database.
index_comments.sh -> shows comments on all or specified index for database

logins_block.sh -> prevents all non-superusers from future logins. MUST be run as user postgres
logins_allow.sh -> re-allows login access to all normal users. MUST be run as user postgres

pg_backup.sh -> generic backup script for postgres database. You will need to edit and adjust for your needs.
pg_runtime.sh -> shows startup and continuous runtime for the cluster
pg_stat_all_indexes.sh -> shows stats and status of all indexes or just for specified table
pg_stat_all_tables.sh -> shows stats for all or specified table
pg_vacuum_time.sh -> Shows total time to vacuum a database
remove_ctrl.sh -> removes control characters from a script. Useful if script was created on a windows PC and then copied to Linux
role_members.sh -> Shows roles and all members
slony_status.sh -> shows status and lag time of slony cluster. Should be run on master node.
table_column_stats.sh -> shows stats for all columns of specified table
table_comments.sh -> shows comments for all or specified table
table_dependents.sh -> shows foreign key constraints for all or specified table
table_in_functions.sh -> shows all functions that reference specified table
table_in_trogger.sh -> shows all triggerss that reference specified table
tables_and_owners.sh -> shows owners and permits on all tables
tables-filenames.sh -> shows physical directory, filename, owner & size for all tables in specified database
table_sizes.sh -> shows tuple count and size for all or specified table
tablespace_use.sh -> shows tablespace used by all or specified table/index
tables_with_column_name.sh -> shows all tables that have a column name LIKE specified column name
tables_with_FKS.sh -> shows all tables taht have a foreign key constraint 
tables_with_no_public_grants.sh -> shows tables that have no public grants (restricted table)
triggers_and_constraints.sh -> shows all triggers and called functions for all or specified table
user_table_access_detail.sh -> shows table access for specified user
user_table_access.sh -> shows permit and position in permit for specified user


