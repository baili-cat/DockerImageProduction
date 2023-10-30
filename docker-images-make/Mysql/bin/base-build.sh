#!/bin/bash

set -e
#镜像名称
NAME=$1
#Mysql版本，具体到小版本
VERSION=$2
#Mysql基础镜像版本
MYSQLDOCKERTAG=$3
#dockerfile文件名
DOCKERFILE=$4
#架构类型，默认amd64，可手动设置成arm64
ARCH=$5

#镜像制作完成后存放目录
IMAGEPATH=$6

#
MYSQLEXPORTINITSQL=$7

if [ -z "$NAME" ]; then
    echo "ERROR: 'NAME' is not set" 1>&2
    exit 1
fi
if [ -z "$VERSION" ]; then
    echo "ERROR: 'VERSION' is not set" 1>&2
    exit 1
fi

if [ -z "$MYSQLDOCKERTAG" ]; then
    echo "ERROR: 'URL' is not set" 1>&2
    exit 1
fi

if [ -z "$DOCKERFILE" ]; then
    DOCKERFILE="Dockerfile"
fi
if [ -z "$ARCH" ]; then
    ARCH="amd64"
fi


REPO="docker.baili-inc.com/baili-test/$NAME:$VERSION"
echo "build image($ARCH) $REPO"
docker buildx build -t $REPO --platform=linux/$ARCH -o type=docker --build-arg ARCH=$ARCH --build-arg MYSQLDOCKERTAG=$MYSQLDOCKERTAG --build-arg MYSQLEXPORTINITSQL=$MYSQLEXPORTINITSQL -f $DOCKERFILE .

echo "export image($ARCH) $REPO"
#打包镜像到当前目录
docker save $REPO | gzip > ${IMAGEPATH}${NAME}-${VERSION}-${ARCH}.tar.gz
