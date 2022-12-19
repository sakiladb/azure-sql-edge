#run the setup script to create the DB and the schema in the DB
#do this in a loop because the timing for when the SQL instance is ready is indeterminate

printf "\n\n\n huzzah starting backup restore \n\n\n"

export SQLCMDPASSWORD="p_ssW0rd"

for i in {1..50};
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -Q "RESTORE DATABASE [sakila] FROM DISK=N'/sakila/sakila.bak'"

    if [ $? -eq 0 ]
    then
        echo "RESTORE backup completed"
        break
    else
        echo "DB is not ready yet..."
        sleep 2
    fi
done


echo "She do be done" > /sakila/huzzah.txt

#
#printf "\n\n Huzzah! Data is imported from SQL files \n\n"
#
#
#sqlcmd -S localhost -U SA -Q "BACKUP DATABASE [sakila] TO DISK = N'/sakila/sakila.bak' WITH NOFORMAT, NOINIT, NAME = 'sakila-full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"
#
#printf "\n\n Huzzah! Data is dumped to /sakila/sakila.bak \n\n"
#
## Now kill the mssql process
#sqlcmd -S localhost -U sa -Q 'SHUTDOWN WITH NOWAIT;'


printf "\n\n Huzzah! She do be done!"
