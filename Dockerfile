####################  snapbuilder ####################
#FROM mcr.microsoft.com/azure-sql-edge:1.0.6 AS builder
FROM ubuntu:bionic AS sqlcmd_builder

RUN apt update -y && apt install -y sudo curl git gnupg2 software-properties-common
RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
RUN sudo add-apt-repository -y ppa:longsleep/golang-backports

RUN mkdir -p /go
RUN mkdir -p /opt/mssql-tools/bin
ENV GOPATH=/go
ENV PATH=$PATH:/usr/lib/go-1.19/bin:/go/bin:/opt/mssql-tools/bin

RUN apt update -y && apt install -y golang-1.19
RUN go install -v github.com/microsoft/go-sqlcmd/cmd/sqlcmd@latest

RUN /go/bin/sqlcmd --version




FROM mcr.microsoft.com/azure-sql-edge:1.0.6 AS sakila-base
ENV ACCEPT_EULA="Y"
ENV SA_PASSWORD="p_ssW0rd"
ENV MSSQL_SA_PASSWORD="p_ssW0rd"
#ENV ENV_MSSQL_AGENT_ENABLED="TRUE"
ENV MSSQL_PID="Developer"

USER root

RUN mkdir -p /sakila
WORKDIR /sakila

COPY . /sakila
# Grant permissions for the import-data script to be executable
#RUN chmod +x /sakila/restore-from-backup.sh
#RUN chmod +x /sakila/startit.sh

# Get the compiled sqlcmd binary from builder
RUN mkdir -p /opt/mssql-tools/bin
COPY --from=sqlcmd_builder /go/bin/sqlcmd /opt/mssql-tools/bin/sqlcmd
RUN chmod +x /opt/mssql-tools/bin/sqlcmd

RUN chmod -R 777 /sakila

ENV PATH="$PATH:/opt/mssql-tools/bin"

RUN sqlcmd --version

EXPOSE 1433

#COPY ./1-sql-server-sakila-schema.sql ./step_1.sql
#COPY ./2-sql-server-sakila-insert-data.sql ./step_2.sql
#COPY ./3-sql-server-sakila-user.sql ./step_3.sql




USER mssql

#USER mssql

CMD ["./entrypoint.sh"]

# Switch back to mssql user and run the entrypoint script

#RUN bash ./import-data.sh &

#RUN ./startit.sh
#
##RUN printf "\n\n Starting sqlservr \n\n"
##
##RUN /opt/mssql/bin/sqlservr
#
#RUN printf "\n\n prob exiting "


#CMD ["/opt/mssql/bin/sqlservr"]





#
#
#FROM mcr.microsoft.com/azure-sql-edge:1.0.6 AS sakila-final
#
#RUN echo "huzzah on the new job"
#
#ENV ACCEPT_EULA="Y"
#ENV SA_PASSWORD="p_ssW0rd"
#ENV MSSQL_SA_PASSWORD="p_ssW0rd"
##ENV ENV_MSSQL_AGENT_ENABLED="TRUE"
#ENV MSSQL_PID="Developer"
#
#USER root
#RUN mkdir -p /sakila
#WORKDIR /sakila
#
#COPY --from=sakila-base /sakila/sakila.bak /sakila/sakila.bak
#
## Get the compiled sqlcmd binary from builder
#RUN mkdir -p /opt/mssql-tools/bin
#COPY --from=sakila-base /opt/mssql-tools/bin/sqlcmd /opt/mssql-tools/bin/sqlcmd
#RUN chmod +x /opt/mssql-tools/bin/sqlcmd
#
#RUN chmod -R 777 /sakila
#
#ENV PATH="$PATH:/opt/mssql-tools/bin"
#
#RUN sqlcmd --version
#
#EXPOSE 1433
#
#USER mssql
#
#CMD ["/opt/mssql/bin/sqlservr"]
