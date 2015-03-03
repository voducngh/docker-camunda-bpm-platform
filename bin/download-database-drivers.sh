#!/bin/sh

set -e

POM="$(wget -O- $1)"
MYSQL_DIR=${LIB_DIR}/mysql/mysql-connector-java/main/
MYSQL_VERSION=$(echo $POM | xmlstarlet sel -t -v //_:version.mysql)
POSTGRESQL_DIR=${LIB_DIR}/org/postgresql/postgresql/main/
POSTGRESQL_VERSION=$(echo $POM | xmlstarlet sel -t -v //_:version.postgre)

GITHUB="https://raw.githubusercontent.com/camunda/camunda-bpm-platform/${VERSION}"

mkdir -p $MYSQL_DIR
wget -P $MYSQL_DIR ${NEXUS}/mysql/mysql-connector-java/${MYSQL_VERSION}/mysql-connector-java-${MYSQL_VERSION}.jar
wget -P $MYSQL_DIR ${GITHUB}/qa/wildfly-runtime/src/main/modules/mysql/mysql-connector-java/main/module.xml

mkdir -p $POSTGRESQL_DIR
wget -P $POSTGRESQL_DIR ${NEXUS}/org/postgresql/postgresql/${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.jar
wget -P $POSTGRESQL_DIR ${GITHUB}/qa/wildfly-runtime/src/main/modules/org/postgresql/postgresql/main/module.xml
