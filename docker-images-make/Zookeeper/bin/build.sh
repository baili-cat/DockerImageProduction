#!/bin/bash
#引入基础函数
source ../lib/base_function
cd $(dirname "$0")

#redis版本对应的列表
ZOOKEEPER_VERSION_ENUM=../conf/ZOOKEEPER_VERSION_ENUM.conf

#DOCKERFILE的相对路径
#默认使用Oracle下的文件
DOCKERFILEPATH=../dockerfile/common/

#docker镜像制作完成后存放路径
IMAGEPATH=../image/

#操作系统名称
#alpine,centos,ubuntu,internal,mysql默认使用centos
#SYSTEMNAME=$1
#if [ -z "$SYSTEMNAME" ]; then
#  SYSTEMNAME="centos"
#fi
#镜像名称
IMAGENAME="centos_zookeeper"
#mysql版本，默认使用最新版本
VERSION=$1
if [ -z "$VERSION" ]; then
  VERSION="latest"
fi

#Oracel的mysql镜像版本
ZOOKEEPERDOCKERTAG=`getValues_accordKey ${ZOOKEEPER_VERSION_ENUM} zookeeper ${VERSION}`
#兼容mysql版本不存在的情况，版本不存在默认使用最新版本
if [ -z "$ZOOKEEPERDOCKERTAG" ]; then
  VERSION="latest"
  ZOOKEEPERDOCKERTAG="latest"
fi
#dockerfile文件名,moren Dockerfile
#支持alpine、centos、ubuntu、internal操作系统基础镜像
#默认使用ubuntu,如有其他需求可指定其他参数
DOCKERFILE="Dockerfile"
#架构类型，默认amd64，可手动设置成arm64
ARCH="amd64"

#TODO 遗留后续如果有其他厂商的mysql需求可扩展
#if [ "$ARCH" == "amd64" ] && [ "$SYSTEMNAME" == "centos" ]; then
#    DOCKERFILE="Dockerfile.centos"
#fi


#使用基础构建脚本，构建镜像
sh ./base-build.sh "$IMAGENAME" "$VERSION" "$ZOOKEEPERDOCKERTAG" "$DOCKERFILEPATH$DOCKERFILE" "$ARCH" "$IMAGEPATH"
