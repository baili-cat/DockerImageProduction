#!/bin/sh
set -e

start_exporter(){
    if [ -z "$REDIS_EXPORTER_PORT" ]; then
        REDIS_EXPORTER_PORT="9121"
        echo "[Exporter] - Use default port $REDIS_EXPORTER_PORT"
    fi

    if [ "$REDIS_EXPORTER_ENABLE" = 'true' ]; then
        until nc -z -w 2 localhost 6379; do
            echo "[Exporter] - Waiting for Redis..."
            sleep 1
        done
        echo "[Exporter] - Starting redis_exporter addr=:$REDIS_EXPORTER_PORT"
        mkdir -p "/var/log/redis"
        nohup redis_exporter --web.listen-address=:$REDIS_EXPORTER_PORT > /var/log/redis/redis_exporter.log 2>&1 < /dev/null &
    else
        echo "[Exporter] - Disable redis_exporter"
    fi
}
start_exporter &

exec /usr/local/bin/docker-entrypoint.sh "$@"