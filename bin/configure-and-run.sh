#!/bin/bash

DB_DRIVER=${DB_DRIVER:-h2}
DB_URL=${DB_URL:-jdbc:h2:./camunda-h2-dbs/process-engine;DB_CLOSE_DELAY=-1;MVCC=TRUE;DB_CLOSE_ON_EXIT=FALSE}
DB_USERNAME=${DB_USERNAME:-sa}
DB_PASSWORD=${DB_PASSWORD:-sa}

XML_CONFIG="/_:server/_:profile/d:subsystem/d:datasources/d:datasource[@jndi-name='java:jboss/datasources/ProcessEngine']"
XML_DRIVER="${XML_CONFIG}/d:driver"
XML_URL="${XML_CONFIG}/d:connection-url"
XML_USERNAME="${XML_CONFIG}/d:security/d:user-name"
XML_PASSWORD="${XML_CONFIG}/d:security/d:password"

XML_ED="xmlstarlet ed -S -L -N d="urn:jboss:domain:datasources:1.1" -u"

${XML_ED} "${XML_DRIVER}" -v "${DB_DRIVER}" ${SERVER_CONFIG}
${XML_ED} "${XML_URL}" -v "${DB_URL}" ${SERVER_CONFIG}
${XML_ED} "${XML_USERNAME}" -v "${DB_USERNAME}" ${SERVER_CONFIG}
${XML_ED} "${XML_PASSWORD}" -v "${DB_PASSWORD}" ${SERVER_CONFIG}

exec /camunda/bin/standalone.sh
