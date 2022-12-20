# sakiladb/azure-sql-edge

Microsoft [Azure SQL Edge](https://hub.docker.com/_/microsoft-azure-sql-edge) docker
image preloaded with the [Sakila](https://dev.mysql.com/doc/sakila/en/) example
database (by way of [jooq](https://www.jooq.org/sakila)). This DB should behave
largely like [Microsoft SQL Server](https://github.com/sakiladb/azure-sql-edge).
See on [Docker Hub](https://hub.docker.com/r/sakiladb/azure-sql-edge).

By default these are created:
- database: `sakila`
- username / password: `sakila` / `p_ssW0rd`


```shell
docker run -p 1433:1433 -d sakiladb/azure-sql-edge:latest
```

Note that it may take some time for the container to boot up. Eventually the container's
docker logs will show:

```
sakiladb/azure-sql-edge has successfully initialized.
```

If you have [sqlcmd](https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility) installed
locally, verify that all is well:

```shell script
$ export SQLCMDPASSWORD="p_ssW0rd"
$ sqlcmd -S localhost -U sakila -d sakila -Q 'select * from actor'
 actor_id | first_name |  last_name   |     last_update
----------+------------+--------------+---------------------
        1 | PENELOPE   | GUINESS      | 2006-02-15 04:34:33
        2 | NICK       | WAHLBERG     | 2006-02-15 04:34:33
        3 | ED         | CHASE        | 2006-02-15 04:34:33
        4 | JENNIFER   | DAVIS        | 2006-02-15 04:34:33
        5 | JOHNNY     | LOLLOBRIGIDA | 2006-02-15 04:34:33
```

## CI

To release a new version, open a PR against `master`; merge the PR; tag `master`, e.g. `v1.0.6`;
then the GitHub [workflow](.github/workflows/docker-publish.yml) will do the rest, including
publishing the image to Docker Hub.

Note that the image release version tracks the Azure SQL Edge release version. That is
to say, if Azure SQL Edge `v7.0.0` is released, then we should publish
a new image `sakiladb/azure-sql-edge:7.0.0`.

## Regenerate sakila.bak

When the container starts, it loads data from `sakila.bak`. However, the
canonical DB is from the concatenation of the three numbered SQL files
([1-sql-server-sakila-schema.sql](./1-sql-server-sakila-schema.sql), etc.).  If
for some reason that `sakila.bak` file needs to be regenerated, use
[restore-from-bak.sh](./restore-from-bak.sh), and then commit the updated
`sakila.bak` to version control.

> The [sql-server-sakila-delete-data.sql](./sql-server-sakila-delete-data.sql) and
[sql-server-sakila-drop-objects.sql](./sql-server-sakila-drop-objects.sql) files are
provided for completeness, but are not actually used by this image.
