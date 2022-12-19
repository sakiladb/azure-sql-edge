#!/bin/bash

/opt/mssql/bin/sqlservr &

./import-data.sh

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
