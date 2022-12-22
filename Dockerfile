FROM mcr.microsoft.com/azure-sql-edge:1.0.6 AS sakila-base
ENV ACCEPT_EULA="Y"
ENV SA_PASSWORD="p_ssW0rd"
ENV MSSQL_SA_PASSWORD="p_ssW0rd"
ENV MSSQL_PID="Developer"

USER root

RUN mkdir -p /sakila
WORKDIR /sakila
COPY . /sakila
RUN chmod -R 777 /sakila

# Install sqlcmd, because it's not pre-installed.
# Install sqlcmd, because it's not pre-installed.
RUN ./install-sqlcmd.sh

USER mssql

EXPOSE 1433

# See: https://dev.to/mdemblani/docker-container-uncaught-kill-signal-10l6
COPY ./signal-listener.sh /sakila/run.sh

# Entrypoint overload to catch the ctrl+c and stop signals
ENTRYPOINT ["/bin/bash", "/sakila/run.sh"]
