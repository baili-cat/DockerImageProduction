
ARG MYSQLDOCKERTAG=latest


FROM centos:7 as builder
ARG ARCH=amd64
#ENV DOWNLOAD_URL "https://github.com/prometheus/mysqld_exporter/releases/download/v0.12.1/mysqld_exporter-0.12.1.linux-${ARCH}.tar.gz"
#RUN set -ex && \
#    curl -fSL "${DOWNLOAD_URL}" -o /exporter.tar.gz && \
#    tar -zxf /exporter.tar.gz -C / && \
#    mv /mysqld_exporter-0.12.1.linux-${ARCH}/mysqld_exporter /


# Dockerfile: https://github.com/docker-library/mysql/blob/546838ab256ad36a9f6571e900deb7c4040cd383/8.0/Dockerfile.debian
# Exporter: https://github.com/prometheus/mysqld_exporter
# Metrics: :9104/metrics
# MySQL 8.0 发行说明: https://dev.mysql.com/doc/relnotes/mysql/8.0/en/
FROM mysql:${MYSQLDOCKERTAG}
MAINTAINER baili@perfma.com
ARG MYSQLEXPORTINITSQL=../initdb/exporter-init.sql

#COPY --from=builder /mysqld_exporter  /bin/mysqld_exporter

# Time zone
RUN /bin/sh -c set -eux; \
    microdnf install -y tzdata nc;\
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \


# 添加mysqld_exporter连接用户创建脚本
COPY ${MYSQLEXPORTINITSQL} /docker-entrypoint-initdb.d/

# 重写entrypoint入口命令
#COPY docker-entrypoint-wrapper.sh /
#RUN chmod +x /docker-entrypoint-wrapper.sh
#ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
#重写xseanodeExport命令
COPY docker-entrypoint-xseaNodeExport.sh /
RUN chmod +x /docker-entrypoint-xseaNodeExport.sh
ENTRYPOINT ["/docker-entrypoint-xseaNodeExport.sh"]
CMD ["mysqld"]
