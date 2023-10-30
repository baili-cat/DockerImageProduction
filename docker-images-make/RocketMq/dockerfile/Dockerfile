
ARG ROCKETMQ_RDOCKERTAG=latest

#FROM centos:7 as builder

ARG ARCH=amd64
#ENV DOWNLOAD_URL "https://github.com/danielqsj/kafka_exporter/releases/download/v1.2.0/kafka_exporter-1.2.0.linux-${ARCH}.tar.gz"
#RUN set -ex && \
#    curl -fSL "${DOWNLOAD_URL}" -o /exporter.tar.gz && \
 #   tar -zxf /exporter.tar.gz -C / && \
 #   mv /kafka_exporter-1.2.0.linux-amd64/kafka_exporter /

# Dockerfile: https://github.com/31z4/zookeeper-docker/blob/master/3.6.3/Dockerfile
# Exporter: Internal
# Metrics: :9141/metrics
FROM apache/rocketmq:${ROCKETMQ_RDOCKERTAG}
MAINTAINER baili@baili.com

#USER root
#COPY --from=builder /kafka_exporter  /bin/kafka_exporter

# Time zone
USER root
RUN set -ex && \
    yum install -y tzdata netcat vim && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

##重写applicationnodeExport命令
USER root
COPY docker-entrypoint-applicationNodeExport.sh /
RUN chmod +x /docker-entrypoint-applicationNodeExport.sh
ENTRYPOINT ["/docker-entrypoint-applicationNodeExport.sh"]
##CMD ["rocketmq-server"]
#CMD ["tail -f /dev/null"]