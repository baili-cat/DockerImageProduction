#!/bin/bash
set -e

start_exporter(){
    if [ -z "$KAFKA_EXPORTER_PORT" ]; then
        KAFKA_EXPORTER_PORT="9308"
        echo "[Exporter] - Use default port $KAFKA_EXPORTER_PORT"
    fi

    if [ "$KAFKA_EXPORTER_ENABLE" = 'true' ]; then
        until nc -z -w 2 localhost 9092; do
            echo "[Exporter] - Waiting for Kafka..."
            sleep 1
        done
        echo "[Exporter] - Starting kafka_exporter addr=:$KAFKA_EXPORTER_PORT"
        mkdir -p "/var/log/kafka"
        nohup kafka_exporter --kafka.server=localhost:9092 --web.listen-address=:$KAFKA_EXPORTER_PORT > /var/log/kafka/kafka_exporter.log 2>&1 < /dev/null &
    else
        echo "[Exporter] - Disable kafka_exporter"
    fi
}
start_exporter &

# TODO 兼容bitnami kafka镜像
if [ "$BITNAMI_APP_NAME" = 'kafka' ]; then
    exec /opt/bitnami/scripts/kafka/entrypoint.sh "$@"
else
    exec "$@"
fi