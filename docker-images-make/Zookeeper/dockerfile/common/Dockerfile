
ARG ZOOKEEPERDOCKERTAG=latest

# Dockerfile: https://github.com/31z4/zookeeper-docker/blob/master/3.6.3/Dockerfile
# Exporter: Internal
# Metrics: :9141/metrics
FROM zookeeper:${ZOOKEEPERDOCKERTAG}
MAINTAINER baili@baili.com

# Time zone
RUN set -ex && \
    apt-get update && \
    apt-get install -y tzdata netcat && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 重写entrypoint入口命令
COPY docker-entrypoint-wrapper.sh /
RUN chmod +x /docker-entrypoint-wrapper.sh
ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["zkServer.sh", "start-foreground"]