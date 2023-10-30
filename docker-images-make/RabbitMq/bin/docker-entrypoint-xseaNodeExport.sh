#!/bin/bash
set -e

start_exporter(){
    if [ -z "$EXPORTER_PORT" ]; then
        EXPORTER_PORT="9308"
        echo "[Exporter] - Use default port $EXPORTER_PORT"
    fi

    if [ "$EXPORTER_ENABLE" = 'true' ]; then
        cd $NODE_EXPORTER_PATH/bin/;
        nohup sh run.sh -Dbaili_xcenter_server=$BAILI_XCENTER_SERVER -Dbaili_xcenter_orgCode=$BAILI_XCENTER_ORGCODE -Dbaili_application_server=$BAILI_APPLICATION_SERVER -Dbaili_collector_server=$BAILI_COLLECTOR_SERVER > /var/log/kafka_applicationNodeExporter.log 2>&1 < /dev/null &
    else
        echo "[Exporter] - Disable rabbitmq_exporter"
    fi
}
start_exporter &
#exec /usr/local/bin/docker-entrypoint.sh "$@"