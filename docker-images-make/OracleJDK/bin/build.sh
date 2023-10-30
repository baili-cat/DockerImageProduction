#!/bin/bash
#引入基础函数
source ../lib/base_function
cd $(dirname "$0")

#JRE版本对应的下载地址列表维护文件地址
JRE_URL_ENUM=../conf/JRE_URL_ENUM.conf
#DOCKERFILE的相对路径
#默认使用JDKCOMMON下的文件，构建jdk6时需要特殊处理，会使用JDK6目录下文件
DOCKERFILEPATH=../dockerfile/JDKCOMMON/

#docker镜像制作完成后存放路径
IMAGEPATH=../image/

#操作系统名称
#alpine,centos,ubuntu,internal
SYSTEMNAME=$1
if [ -z "$SYSTEMNAME" ]; then
  SYSTEMNAME="centos"
fi
#镜像名称
IMAGENAME=$SYSTEMNAME"-jre"
#jdk或jre版本，具体到小版本
VERSION=$2
if [ -z "$VERSION" ]; then
  VERSION="jre_8_333"
fi

#jdk或jre下载链接
URL=`getValues_accordKey ${JRE_URL_ENUM} jre ${VERSION}`
#dockerfile文件名,moren Dockerfile
#支持alpine、centos、ubuntu、internal操作系统基础镜像
#默认使用ubuntu,如有其他需求可指定其他参数
DOCKERFILE="Dockerfile.ubuntu"
#架构类型，默认amd64，可手动设置成arm64
ARCH="amd64"

if [ "${VERSION:4:1}" == "6" ]; then
  DOCKERFILEPATH=../dockerfile/JDK6/
fi

# 由于alpine不支持构建arm64 jdk镜像，所以使用ubuntu作为基础镜像替代
if [ "$ARCH" == "arm64" ]; then
    DOCKERFILE="Dockerfile.ubuntu"
fi

if [ "$ARCH" == "amd64" ] && [ "$SYSTEMNAME" == "centos" ]; then
    DOCKERFILE="Dockerfile.centos"
fi
if [ "$ARCH" == "amd64" ] && [ "$SYSTEMNAME" == "alpine" ]; then
    DOCKERFILE="Dockerfile.alpine"
fi

if [ "$ARCH" == "amd64" ] && [ "$SYSTEMNAME" == "ubuntu" ]; then
    DOCKERFILE="Dockerfile.ubuntu"
fi


#使用基础构建脚本，构建镜像
sh ./base-build.sh "$IMAGENAME" "$VERSION" "$URL" "$DOCKERFILEPATH$DOCKERFILE" "$ARCH" "$IMAGEPATH"
