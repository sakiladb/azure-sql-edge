#run the setup script to create the DB and the schema in the DB
#do this in a loop because the timing for when the SQL instance is ready is indeterminate

printf "starting sqlserver"

printf "onto data part sqlserver"

# cat all the files together to make our logic simpler
cat ./step_1.sql ./step_2.sql ./step_3.sql > ./db_init.sql

export SQLCMDPASSWORD="p_ssW0rd"

for i in {1..50};
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa  -i ./db_init.sql
    if [ $? -eq 0 ]
    then
        echo "db_init.sql completed"
        break
    else
        echo "DB is not ready yet..."
        sleep 2
    fi
done


printf "\n\n Huzzah! Data is imported from SQL files \n\n"


sqlcmd -S localhost -U SA -Q "BACKUP DATABASE [sakila] TO DISK = N'/sakila/sakila.bak' WITH NOFORMAT, NOINIT, NAME = 'sakila-full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"

printf "\n\n Huzzah! Data is dumped to /sakila/sakila.bak \n\n"

# Now kill the mssql process
sqlcmd -S localhost -U sa -Q 'SHUTDOWN WITH NOWAIT;'


printf "\n\n Huzzah! She do be dead!"
