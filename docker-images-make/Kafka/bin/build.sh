#!/bin/bash
#引入基础函数
source ../lib/base_function
cd $(dirname "$0")

#redis版本对应的列表
KAFKA_VERSION_ENUM=../conf/KAFKA_VERSION_ENUM.conf


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

if [ "$SYSTEMNAME" == "wurstmeister" ]; then
    DOCKERFILE="Dockerfile.wurstmeister"
fi


#docker镜像制作完成后存放路径
IMAGEPATH=../image/

#操作系统名称
#alpine,centos,ubuntu,internal,mysql默认使用centos
#SYSTEMNAME=$1
#if [ -z "$SYSTEMNAME" ]; then
#  SYSTEMNAME="centos"
#fi
#镜像名称
IMAGENAME="centos_kafka"
#mysql版本，默认使用最新版本
VERSION=$1
if [ -z "$VERSION" ]; then
  VERSION="latest"
fi

#Oracel的mysql镜像版本
KAKFADOCKERTAG=`getValues_accordKey ${KAFKA_VERSION_ENUM} bitnami ${VERSION}`
#兼容mysql版本不存在的情况，版本不存在默认使用最新版本
if [ -z "$KAFKADOCKERTAG" ]; then
  VERSION="latest"
  KAFKADOCKERTAG="latest"
fi



#架构类型，默认amd64，可手动设置成arm64
ARCH="amd64"

#TODO 遗留后续如果有其他厂商的mysql需求可扩展
#if [ "$ARCH" == "amd64" ] && [ "$SYSTEMNAME" == "centos" ]; then
#    DOCKERFILE="Dockerfile.centos"
#fi


#使用基础构建脚本，构建镜像
sh ./base-build.sh "$IMAGENAME" "$VERSION" "$KAFKADOCKERTAG" "$DOCKERFILEPATH$DOCKERFILE" "$ARCH" "$IMAGEPATH"
