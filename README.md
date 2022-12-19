# sakiladb/azure-sql-edge

Microsoft [Azure SQL Edge](https://hub.docker.com/_/microsoft-azure-sql-edge) docker
image preloaded with the [Sakila](https://dev.mysql.com/doc/sakila/en/) example
database (by way of [jooq](https://www.jooq.org/sakila)). This DB should behave
largely like [Microsoft SQL Server](https://github.com/sakiladb/azure-sql-edge).
See on [Docker Hub](https://hub.docker.com/r/sakiladb/azure-sql-edge).

By default these are created:
- database: `sakila`
- username / password: `sakila` / `p_ssW0rd`


```shell script
docker run -p 1433:1433 -d sakiladb/azure-sql-edge:latest
```

Or use a specific version of SQL Server: see all available image tags
on [Docker Hub](https://hub.docker.com/r/sakiladb/azure-sql-edge/tags). For example:

```shell script
docker run -p 1433:1433 -d sakiladb/azure-sql-edge:1.0.6
```

Note that it may take some time for the container to boot up. Eventually the container's
docker logs will show:

```
sakiladb/azure-sql-edge has successfully initialized.
```

Note that even after this message is logged, it may take another few moments for
it to become available (due to a final server restart etc).

If you have [sqlcmd](https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility) installed
locally, verify that all is well:

```shell script
$ sqlcmd -S localhost -U sakila -P p_ssW0rd -d sakila -Q 'select * from actor'
 actor_id | first_name |  last_name   |     last_update
----------+------------+--------------+---------------------
        1 | PENELOPE   | GUINESS      | 2006-02-15 04:34:33
        2 | NICK       | WAHLBERG     | 2006-02-15 04:34:33
        3 | ED         | CHASE        | 2006-02-15 04:34:33
        4 | JENNIFER   | DAVIS        | 2006-02-15 04:34:33
        5 | JOHNNY     | LOLLOBRIGIDA | 2006-02-15 04:34:33
```

# How to build/release the image

To build the image:

```shell
$ docker build . -t sakiladb/azure-sql-edge:latest

# Then test the image via:
$ docker run sakiladb/azure-sql-edge:lastest

$ docker push 
```
