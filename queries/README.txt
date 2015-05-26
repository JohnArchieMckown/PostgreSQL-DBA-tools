These are generic SQL queries. In some cases you need to replace variable holders -> <VARIABLE>
with the actual value you need.

ALL_COLUMNS.sql -> Lists all tables, their columns and data type
ALL_CONSTRAINTS.sql -> lists all tables and their associated constraints
ALL_TABLES.sql -> lists all tables
bad_idx.sql -> lists all indexes flagged as invalid
blocked_transaction.sql -> shows all blocked queries and transaction causing block
cache_hit_ratio.sql -> shows cache hit ratio for all databases
cancel_all_queries.sql -> cancels all tranactions for specified <user_name>
check_fks.sql -> shows fk status for all tables > 9mb in size or greater than 1000 writes
column_name_type_difference.sql -> shows all tables and columns that have same column name but different data type
columns_of_type_x.sql -> shows all tables that have columns of type <TYPE>
connection_counts.sql -> shows connection totals and totals for users, database and user/database
current_locks.sql -> shows current_locks
current_queries_blocked.sql -> shows blocked transactions and blocking query
current_queries.sql -> shows all current_queries
database_info.sql -> shows information from pg_database
database_sizes.sql -> shows size of all databases and percentage of total size
distinct_data_types.sql -> shows all data types in use in cluster
enum_maint.sql -> generic query to show all enums and commented delete / add code
enums.sql -> generic query to show all enums
filenames_and_tables.sql -> shows physical filenames for all tables
gen_create_indexes.sql -> generates sql statements to recreate all indexes
gen_drop_indexes.sql -> generates sql statements to drop all indexes
gen_get_seq_max.sql -> generates sql to get the max value of all sequences
gen_revoke_all.sql -> generates sql to revoke all priviliges from all tables for user <some_user>
gen_table_compare_counts.sql -> generates sql to compare reltuples to actual row count for all tables
get_slony_schemas.sql -> shows all slony schemas
get_trans_min_cnt.sql -> shows trandaction count per minute in cluster
groups_users.sql -> shows all groups and assigned users
inactive_tables.sql -> shows all tables that have 0 fetch's & 0 read's
index_bloat.sql -> shows size of index vs. table
index_bloat2.sql > a more specific version of index bloat WHERE realbloat > 50 and wastedbytes > 50000000  (adjust to your requirements)
index_comments.sql -> shows comments for all indexes
index_sizes.sql -> show the size of all indexes
index_tablespaces.sql -> shows the tablespace indexes are using
make_alter_index_spc.sql -> generates sql to alter all indexes in public to <new_table_space>
make_alter_table_spc.sql -> generates sql to alter all tables in public to <new_table_space>
most_active_tables.sql -> sorts and lists all tables in descending order by tuples read
parent_and_children.sql -> lists all tables and associated children
pg_runtime.sql -> lists start and run time for cluster
pg_stat_all_indexes.sql -> lists stats and status for all indexes
pg_stat_all_tables.sql -> lists stats and vacuum info for all tables
remove_ctrl.sh -> removes control characters from queries (used if query written in windows)
role_members.sql -> lists all roles and their members
rules.sql -> lists all tables and associated rules
sequence_cols.sql -> lists all tables with sequence columns
show_dead_tuples.sql -> shows table stats and status of dead tuples
table_access.sql -> lists all tables and their acl
table_columns.sql -> lists all columns for specified <table>
table_comments.sql -> lists comments for all tables and columns
table_constraints.sql -> lists all constraints for all tables
table_dependents.sql -> lists all tables, children and related constraint name
table_grants.sql -> lists all tables and their grants
table_in_function.sql -> list all functions that reference <TABLE/COLUMN>
table_in_schema.sql -> lists all tables in <schema_name>
table_in_trigger.sql -> lists all triggers that reference <table>
table_row_counts.sql -> lists all tables with greater than 0 rows
tables_and_comments.sql -> lists only tables and columns with comments
tables_and_filenames.sql -> lists all tables and physical filenames
tables_and_owners.sql -> lists all tables, owners and permits
tables_and_pkey.sql -> lists all tables and primary key name
table_sizes.sql -> lists all tables, owner, physical filename, tuples, size, total size, size in bytes, total_size in bytes and tablespace
table_stats.sql -> lists all tables and indexes, last vacuum, inserted, updated and deleted count
tables_with_column_name.sql -> lists all tables with column name LIKE <COLUMN_NAME>
tables_with_FKs.sql -> lists all tables that have foreign keys and FK name
tables_with_large_index_size.sql -> lists all tables where index size > table size
tables_with_no_FK.sql -> lists all tables that have no foreign key
tables_with_no_pkey.sql -> lists all tables with no primary key
tables_with_no_public_grants.sql -> lists all tables that have no public grants (Only owner has access)
table_triggers.sql -> lists all tables with triggers, trigger name, trigger type and tgenabled value
tcp_settings.sql -> lists the current tcp settings
triggers_and_constraints.sql -> lists tables, their triggers and function called by the trigger
useless_indexes.sql -> lists tables and associated indexes scanned < 200 times and are not unique indexes
useless_indexes2.sql -> lists tables and associated indexes scanned < 200 times and are not unique indexes or primary keys
users.sql -> lists all users/groups and if they are superuser or not
user_table_access_detail.sql -> lists all table privileges for user <CKUSER>
user_table_access.sql -> lists all tables, acl and position in acl for user <USERNAME>
wasted_index_space.sql -> shows space wasted by unused indexes

