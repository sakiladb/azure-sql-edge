#!/usr/bin/env bash
# This script is executed as a background process by entrypoint.sh.
# It attempts to load/restore the backup in /sakila/sakila.bak into the DB.
# The server can take a while to start, so we execute the sqlcmd in
# a loop.

export SQLCMDPASSWORD="p_ssW0rd"

for i in {1..50};
do
    sqlcmd -S localhost -U SA -Q "RESTORE DATABASE [sakila] FROM DISK=N'/sakila/sakila.bak'"

    if [ $? -eq 0 ]
    then
        echo "RESTORE backup completed"
        break
    else
        echo "DB is not ready yet..."
        sleep 2
    fi
done
