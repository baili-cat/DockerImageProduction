#!/bin/bash
#引入基础函数
source ../lib/base_function
cd $(dirname "$0")

#redis版本对应的列表
RABBITMQ_VERSION_ENUM=../conf/RABBITMQ_VERSION_ENUM.conf


#DOCKERFILE的相对路径
DOCKERFILEPATH=../dockerfile/
#默认使用bitnami下的文件
SYSTEMNAME=$2
if [ -z "$SYSTEMNAME" ]; then
  SYSTEMNAME="bitnami"
fi
if [ "$SYSTEMNAME" == "bitnami" ]; then
    DOCKERFILE="Dockerfile.bitnami"
fi

if [ "$SYSTEMNAME" == "rabbitmq" ]; then
    DOCKERFILE="Dockerfile"
fi


#docker镜像制作完成后存放路径
IMAGEPATH=../image/

#操作系统名称
#alpine,centos,ubuntu,internal,mysql默认使用centos
#SYSTEMNAME=$1
#if [ -z "$SYSTEMNAME" ]; then
#  SYSTEMNAME="centos"
#fi
#镜像名称-必须小写
IMAGENAME="rabbitmq"
#mysql版本，默认使用最新版本
VERSION=$1
if [ -z "$VERSION" ]; then
  VERSION="latest"
fi

#Oracel的mysql镜像版本
RABBITMQ_DOCKERTAG=`getValues_accordKey ${RABBITMQ_VERSION_ENUM} bitnami ${VERSION}`
#兼容mysql版本不存在的情况，版本不存在默认使用最新版本
if [ -z "$RABBITMQ_DOCKERTAG" ]; then
  VERSION="latest"
  RABBITMQ_DOCKERTAG="latest"
fi



#架构类型，默认amd64，可手动设置成arm64
ARCH="amd64"

#TODO 遗留后续如果有其他厂商的mysql需求可扩展
#if [ "$ARCH" == "amd64" ] && [ "$SYSTEMNAME" == "centos" ]; then
#    DOCKERFILE="Dockerfile.centos"
#fi


#使用基础构建脚本，构建镜像
sh ./base-build.sh "$IMAGENAME" "$VERSION" "$RABBITMQ_DOCKERTAG" "$DOCKERFILEPATH$DOCKERFILE" "$ARCH" "$IMAGEPATH"
