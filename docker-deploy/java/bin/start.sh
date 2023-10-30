#!/bin/bash
#某些情况会有路径的问题，后续优化
MOCK_HOME=`dirname $0`
JAVA_AGENT_HOME=$(find "$MOCK_HOME/../" -name "agent-bootstrap.jar")
JAVA_CONFIG=${MOCK_HOME}/../conf/application.properties
JAVA_JAR_PACKAGE=${MOCK_HOME}/../source
JAVA_LOGS_PATH=${MOCK_HOME}/../logs
if [ ! -z ${JAVA_AGENT_HOME} ]; then
    JAVA_AGENT="-javaagent:${JAVA_AGENT_HOME} -DBAILI_APP_CODE=${BAILI_APP_CODE} -Dbaili.agent.xcenter.server=${BAILI_AGENT_XCENTER_SERVER} -DBAILI_ENV_CODE=${BAILI_ENV_CODE}"
fi
JVM_OPT="-Xmx4096M -Xms1024M -XX:MaxMetaspaceSize=256M -XX:MetaspaceSize=128M -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=100 -XX:+ParallelRefProcEnabled -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/heapdump.hprof"
#DEBUG_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=5556,server=y,suspend=n"
nohup java $JVM_OPT $JAVA_OPT $JAVA_AGENT -jar ${JAVA_JAR_PACKAGE}/* --spring.config.location=${JAVA_CONFIG} > ${JAVA_LOGS_PATH}/mock.log &

echo $! > ${MOCK_HOME}/pid
echo "Start baili agent complete,PID["`cat ${MOCK_HOME}/pid`"]!"
tail -f /dev/null
