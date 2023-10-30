#!/bin/bash
set -e

start_exporter(){
    if [ -z "$MYSQLD_EXPORTER_PORT" ]; then
        MYSQLD_EXPORTER_PORT="9104"
        echo "[Exporter] - Use default port $MYSQLD_EXPORTER_PORT"
    fi

    if [ "$MYSQLD_EXPORTER_ENABLE" = 'true' ]; then
        until nc -z -w 2 localhost 3306 -o /dev/null; do
            echo "[Exporter] - Waiting for MySQLD..."
            sleep 1
        done
        echo "[Exporter] - Starting mysqld_exporter addr=:$MYSQLD_EXPORTER_PORT"
        mkdir -p "/var/log/mysql"
        #export DATA_SOURCE_NAME="root:${MYSQL_ROOT_PASSWORD}@(127.0.0.1:3306)/"
        export DATA_SOURCE_NAME="exporter:123456@(127.0.0.1:3306)/"
        nohup mysqld_exporter --web.listen-address=:$MYSQLD_EXPORTER_PORT > /var/log/mysql/mysqld_exporter.log 2>&1 < /dev/null &
    else
        echo "[Exporter] - Disable mysqld_exporter"
    fi
}
start_exporter &

exec /usr/local/bin/docker-entrypoint.sh "$@"