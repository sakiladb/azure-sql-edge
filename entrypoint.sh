# start SQL Server, start the script to create the DB and import the data, start the app
/app/import-data.sh &

/opt/mssql/bin/sqlservr
