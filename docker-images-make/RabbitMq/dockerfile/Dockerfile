
ARG RABBITMQ_RDOCKERTAG=latest

FROM centos:7 as builder

ARG ARCH=amd64
#ENV DOWNLOAD_URL "https://github.com/danielqsj/kafka_exporter/releases/download/v1.2.0/kafka_exporter-1.2.0.linux-${ARCH}.tar.gz"
#RUN set -ex && \
#    curl -fSL "${DOWNLOAD_URL}" -o /exporter.tar.gz && \
 #   tar -zxf /exporter.tar.gz -C / && \
 #   mv /kafka_exporter-1.2.0.linux-amd64/kafka_exporter /

# Dockerfile: https://github.com/31z4/zookeeper-docker/blob/master/3.6.3/Dockerfile
# Exporter: Internal
# Metrics: :9141/metrics
FROM rabbitmq:${RABBITMQ_RDOCKERTAG}
MAINTAINER baili@baili.com

USER root
#COPY --from=builder /kafka_exporter  /bin/kafka_exporter

# Time zone
USER root
RUN set -ex && \
    mkdir -p /var/lib/apt/lists/partial && \
    install_packages tzdata netcat vim && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN set -ex && \
    mkdir -p /rabbitmq/rabbitmq-logs /var/log/rabbitmq && \
    chmod g+rwX /rabbitmq/rabbitmq-logs /var/log/rabbitmq


#重写applicationnodeExport命令
USER root
COPY docker-entrypoint-applicationNodeExport.sh /
COPY init.sh /

RUN set -ex && \
    chmod +x /init.sh && \
    chmod +x /docker-entrypoint-applicationNodeExport.sh
#ENTRYPOINT ["/docker-entrypoint-applicationNodeExport.sh"]
CMD ["/init.sh"]
#CMD ["rabbitmq-server"]