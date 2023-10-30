ARG NEO4JDOCKERTAG=latest
# Dockerfile: https://github.com/neo4j/docker-neo4j-publish/blob/73963d86ca01456c695b7258d2fa1873cc4041bc/4.2.1/community/Dockerfile
# Exporter: Internal
# Metrics: :2004/metrics
# 社区版本不支持集群部署、监控采集
#FROM neo4j:${NEO4JDOCKERTAG}
FROM neo4j:${NEO4JDOCKERTAG}
MAINTAINER baili@baili.com


ENV NEO4J_ACCEPT_LICENSE_AGREEMENT=yes

# Time zone
RUN set -ex && \
    apt-get install -y tzdata && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
