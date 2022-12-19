#!/usr/bin/env bash
# This script can be used to regenerate the sakila.bak backup file
# from the SQL scripts. This only needs to be done if the SQL needs
# to change for some reason (which shouldn't happen).
#
# This script requires that sqlcmd is already installed.

set -e
#set -x

export SQLCMDPASSWORD="p_ssW0rd"
container_name="azure-sql-edge-$(echo $RANDOM | md5sum | head -c 8)"
echo "Using container named: ${container_name}"

cat ./1-sql-server-sakila-schema.sql ./2-sql-server-sakila-insert-data.sql ./3-sql-server-sakila-user.sql > ./init-db-full.sql

docker run -d --cap-add SYS_PTRACE -v $(pwd):/sakila \
  -e 'ACCEPT_EULA=1' -e 'MSSQL_SA_PASSWORD=p_ssW0rd' -e 'MSSQL_PID=Developer' \
  -p 1433:1433 --name "$container_name" mcr.microsoft.com/azure-sql-edge

sleep 5

printf "\n\nBuilding Sakila DB via SQL scripts....\n\n"
printf "This could take several minutes, and you may see errors that are to be ignored.\n\n";

set +e

for i in {1..50};
do
  sqlcmd -S localhost -U sa -i ./init-db-full.sql
  if [ $? -eq 0 ]; then
    printf "\n\nSakila DB imported\n\n"
    break
  else
    printf "."
    sleep 2
  fi
done

set -e

printf "\n\nBuilding backup in container...\n"

sqlcmd -S localhost -U sa -Q "BACKUP DATABASE [sakila] TO DISK = N'/sakila/sakila.bak' WITH NOFORMAT, NOINIT, NAME = 'sakila-full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"

echo "Copying backup from container to $(pwd)/sakila.bak"

docker cp "$container_name":/sakila/sakila.bak ./sakila.bak

echo "Stopping container: $container_name"
docker rm -f "$container_name"

printf "\n\nSuccess!\n"


#run the setup script to create the DB and the schema in the DB
#do this in a loop because the timing for when the SQL instance is ready is indeterminate

#exit 0
#
#docker rm -f "$container_name"
#
#printf "starting sqlserver"
#
#printf "onto data part sqlserver"
#
## cat all the files together to make our logic simpler
#cat ./step_1.sql ./step_2.sql ./step_3.sql >./db_init.sql
#
#export SQLCMDPASSWORD="p_ssW0rd"
#
#for i in {1..50}; do
#  sqlcmd -S localhost -U sa -i ./db_init.sql
#  if [ $? -eq 0 ]; then
#    echo "db_init.sql completed"
#    break
#  else
#    echo "DB is not ready yet..."
#    sleep 2
#  fi
#done
#
#printf "\n\n Huzzah! Data is imported from SQL files \n\n"
#
#sqlcmd -S localhost -U SA -Q "BACKUP DATABASE [sakila] TO DISK = N'/sakila/sakila.bak' WITH NOFORMAT, NOINIT, NAME = 'sakila-full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"
#
#printf "\n\n Huzzah! Data is dumped to /sakila/sakila.bak \n\n"
#
## Now kill the mssql process
#sqlcmd -S localhost -U sa -Q 'SHUTDOWN WITH NOWAIT;'
#
#printf "\n\n Huzzah! She do be dead!"
