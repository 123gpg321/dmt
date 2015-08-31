#!/bin/bash

#Remember to give execute permission to our script before running it:
#chmod +x /path/to/dmt.sh
#to run do 'sudo ./dmt.sh'

touch /home/gpg/dmt/latest_db_migration_number.csv
sudo chown mysql:mysql /home/gpg/dmt/latest_db_migration_number.csv

#DB check in migrations table for latest migration number
echo Getting latest migration number..
mysql -u root -p sakila < get_latest_migration.sql > latest_db_migration_number.csv

DB_MIG_NUM="$(echo `sed 's/[^0-9]//g' latest_db_migration_number.csv` | sed 's/ /,/g')"

#Run only new migrations

for filename in /home/gpg/dmt/migrations/*.sql; do
filename_db_num="$(echo "$filename" |grep -o '[0-9]*')"
if [ $filename_db_num -gt $DB_MIG_NUM ]
then
echo Running migration script..
mysql -u root -p sakila < $filename
echo Migration $filename_db_num has been applied successfully.
x=$(($filename_db_num))
fi
done

#Generate and run sql to update migrations table

sql_insert="INSERT INTO sakila.migrations (number)
VALUES ("$x");"
echo "$sql_insert" > "/home/gpg/dmt/latest_succ_migration.sql"

echo Updating migrations table..
mysql -u root -p sakila < "/home/gpg/dmt/latest_succ_migration.sql"

echo Migrations table updated.





