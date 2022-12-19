# We start the restore script as a background process (it will
# wait until the server is available).
./restore-from-bak.sh &

# This is the main process
/opt/mssql/bin/sqlservr
