
ARG REDISDOCKERTAG=latest


FROM centos:7 as builder
ARG ARCH=amd64
#ENV DOWNLOAD_URL "https://github.com/oliver006/redis_exporter/releases/download/v1.20.0/redis_exporter-v1.20.0.linux-${ARCH}.tar.gz"
#RUN set -ex && \
#    curl -fSL "${DOWNLOAD_URL}" -o /exporter.tar.gz && \
#    tar -zxf /exporter.tar.gz -C / && \
#    mv /redis_exporter-v1.20.0.linux-${ARCH}/redis_exporter /


# Dockerfile: https://github.com/docker-library/mysql/blob/546838ab256ad36a9f6571e900deb7c4040cd383/8.0/Dockerfile.debian
# Exporter: https://github.com/prometheus/mysqld_exporter
# Metrics: :9104/metrics
# MySQL 8.0 发行说明: https://dev.mysql.com/doc/relnotes/mysql/8.0/en/
FROM redis:${REDISDOCKERTAG}
MAINTAINER baili@baili.com

#COPY --from=builder --chown=redis:redis /redis_exporter  /bin/redis_exporter

# Time zone
RUN set -ex && \
    apk add tzdata netcat-openbsd && \
    rm -rf /var/cache/apk/* && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

## 重写entrypoint入口命令
#COPY docker-entrypoint-wrapper.sh /
#RUN chmod +x /docker-entrypoint-wrapper.sh
#ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
#重写applicationnodeExport命令
COPY docker-entrypoint-applicationNodeExport.sh /
RUN chmod +x /docker-entrypoint-applicationNodeExport.sh
CMD ["sh /docker-entrypoint-applicationNodeExport.sh"]
CMD ["redis-server"]
