FROM ubuntu:14.04.1

ENV VERSION 7.2.0
ENV DISTRO jboss
ENV SERVER jboss-as-7.2.0.Final
ENV LIB_DIR /camunda/modules
ENV SERVER_CONFIG /camunda/standalone/configuration/standalone.xml
ENV NEXUS https://app.camunda.com/nexus/content/groups/public/
ENV GITHUB https://raw.githubusercontent.com/camunda/camunda-bpm-platform/7.2.0

# install oracle java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/oracle-jdk.list && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com EEA14886 && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get update && \
    apt-get -y install --no-install-recommends oracle-java7-installer xmlstarlet && \
    apt-get clean && \
    rm -rf /var/cache/* /var/lib/apt/lists/*

# add camunda distro
ADD ${NEXUS}/org/camunda/bpm/${DISTRO}/camunda-bpm-${DISTRO}/${VERSION}/camunda-bpm-${DISTRO}-${VERSION}.tar.gz /tmp/camunda-bpm-platform.tar.gz

# unpack camunda distro
WORKDIR /camunda
RUN tar xzf /tmp/camunda-bpm-platform.tar.gz -C /camunda/ server/${SERVER} --strip 2

# add database driver for mysql and postgresql
ADD ${NEXUS}/mysql/mysql-connector-java/5.1.21/mysql-connector-java-5.1.21.jar ${LIB_DIR}/mysql/mysql-connector-java/main/
ADD ${GITHUB}/qa/jboss7-runtime/src/main/modules/mysql/mysql-connector-java/main/module.xml ${LIB_DIR}/mysql/mysql-connector-java/main/module.xml
ADD ${NEXUS}/org/postgresql/postgresql/9.3-1100-jdbc4/postgresql-9.3-1100-jdbc4.jar ${LIB_DIR}/org/postgresql/postgresql/main/
ADD ${GITHUB}/qa/jboss7-runtime/src/main/modules/org/postgresql/postgresql/main/module.xml ${LIB_DIR}/org/postgresql/postgresql/main/module.xml

# add standalone.xml with database drivers added
ADD etc/standalone.xml ${SERVER_CONFIG}

# add start script
ADD bin/configure-and-run.sh /usr/local/bin/configure-and-run.sh

EXPOSE 8080

CMD ["/usr/local/bin/configure-and-run.sh"]
