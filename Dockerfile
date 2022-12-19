####################  snapbuilder ####################
#FROM mcr.microsoft.com/azure-sql-edge:1.0.6 AS builder
#FROM ubuntu:bionic AS sqlcmd_builder
#
#RUN apt update -y \
#RUN apt install -y sudo curl git gnupg2 software-properties-common
#RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
##RUN #curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
#RUN add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list)"
#
#RUN apt-get update -y
#RUN apt-get install -y sqlcmd
#RUN sudo add-apt-repository -y ppa:longsleep/golang-backports
#
#RUN mkdir -p /go
#RUN mkdir -p /opt/mssql-tools/bin
#ENV GOPATH=/go
#ENV PATH=$PATH:/usr/lib/go-1.19/bin:/go/bin:/opt/mssql-tools/bin
#
#RUN apt update -y && apt install -y golang-1.19
#RUN go install -v github.com/microsoft/go-sqlcmd/cmd/sqlcmd@latest
#
#RUN /go/bin/sqlcmd --version




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

RUN apt update -y
RUN apt install -y sudo curl git gnupg2 software-properties-common
RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#RUN #curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
RUN add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list)"

RUN apt-get update -y
RUN apt-get install -y sqlcmd
#RUN #sqlcmd --version

## Get the compiled sqlcmd binary from builder
#RUN mkdir -p /opt/mssql-tools/bin
##COPY --from=sqlcmd_builder /go/bin/sqlcmd /opt/mssql-tools/bin/sqlcmd
##COPY --from=sqlcmd_builder /go/bin/sqlcmd /opt/mssql-tools/bin/sqlcmd
##COPY --from=sqlcmd_builder /go/bin/sqlcmd /opt/mssql-tools/bin/sqlcmd
#RUN chmod +x /opt/mssql-tools/bin/sqlcmd

RUN chmod -R 777 /sakila

EXPOSE 1433

USER mssql

CMD ["./entrypoint.sh"]
