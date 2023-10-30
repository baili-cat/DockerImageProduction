#!/bin/bash
set -e

start_exporter(){
    if [ -z "$MYSQLD_EXPORTER_PORT" ]; then
        MYSQLD_EXPORTER_PORT="9104"
        echo "[Exporter] - Use default port $MYSQLD_EXPORTER_PORT"
    fi

    if [ "$MYSQLD_EXPORTER_ENABLE" = 'true' ]; then
        cd $NODE_EXPORTER_PATH/bin/;
        nohup sh run.sh -Dbaili_xcenter_server=$BAILI_XCENTER_SERVER -Dbaili_xcenter_orgCode=$BAILI_XCENTER_ORGCODE -Dbaili_application_server=$BAILI_APPLICATION_SERVER -Dbaili_collector_server=$BAILI_COLLECTOR_SERVER > /var/log/mysqld_applicationNodeExporter.log 2>&1 < /dev/null &
    else
        echo "[Exporter] - Disable mysqld_exporter"
    fi
}
start_exporter &

exec /usr/local/bin/docker-entrypoint.sh "$@"