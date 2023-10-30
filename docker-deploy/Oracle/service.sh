#!/bin/bash

set -e

#进入当前命令目录
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

SERVICE_NAME=$(docker-compose config --services)
if [ -z "${SERVICE_NAME}" ]; then
    echo "ERROR: Cannot get container service name" 1>&2
    exit 1
fi

check_docker() {
	if ! docker --version &> /dev/null
	then
		echo "ERROR: Need to install docker(19.03.0+)" 1>&2
		exit 1
	fi

	# docker has been installed and check its version
	if [[ $(docker --version) =~ (([0-9]+)\.([0-9]+)([\.0-9]*)) ]]
	then
		docker_version=${BASH_REMATCH[1]}
		docker_version_part1=${BASH_REMATCH[2]}
		docker_version_part2=${BASH_REMATCH[3]}

		echo "INFO: docker version: $docker_version"
		# the version of docker does not meet the requirement
		if [ "$docker_version_part1" -lt 19 ] || { [ "$docker_version_part1" -eq 19 ] && [ "$docker_version_part2" -lt 3 ]; }
		then
			echo "ERROR: Need to upgrade docker package to 19.03.0+." 1>&2
			exit 1
		fi
	else
		echo "ERROR: Failed to parse docker version." 1>&2
		exit 1
	fi
}

check_dockercompose() {
	if ! docker-compose --version &> /dev/null
	then
		echo "ERROR: Need to install docker-compose(1.27.0+)" 1>&2
		exit 1
	fi

	# docker-compose has been installed, check its version
	if [[ $(docker-compose --version) =~ (([0-9]+)\.([0-9]+)([\.0-9]*)) ]]
	then
		docker_compose_version=${BASH_REMATCH[1]}
		docker_compose_version_part1=${BASH_REMATCH[2]}
		docker_compose_version_part2=${BASH_REMATCH[3]}

		echo "INFO: docker-compose version: $docker_compose_version"
		# the version of docker-compose does not meet the requirement
		if [ "$docker_compose_version_part1" -lt 1 ] || { [ "$docker_compose_version_part1" -eq 1 ] && [ "$docker_compose_version_part2" -lt 27 ]; }
		then
			echo "ERROR: Need to upgrade docker-compose package to 1.27.0+." 1>&2
			exit 1
		fi
	else
		echo "ERROR: Failed to parse docker-compose version." 1>&2
		exit 1
	fi
}

container_status(){
  containerId=$(docker-compose ps -q)
  if [ -n "${containerId}" ]; then
      #容器状态解读: https://blog.csdn.net/K_Actor/article/details/100513890
      #容器状态(created, restarting, running, removing, paused, exited, dead)
      status=$(docker inspect -f "{{.State.Status}}" "${containerId}")
  fi
  echo "${status}"
}

start(){
    echo "INFO: checking if docker is installed ..."
    check_docker

    echo "INFO: checking docker-compose is installed ..."
    check_dockercompose

    image_file=$(find "$DIR/image" -maxdepth 1 -type f -name "*.tar.gz")
    if [ -z "${image_file}" ]; then
        echo "ERROR: Can not find the image file under path \"$DIR/image\"" 1>&2
        exit 1
    fi

    echo "INFO: loading container image file \"$image_file\""
    docker load -i "$image_file"

    echo "INFO: starting container service \"${SERVICE_NAME}\" ..."
    docker-compose up --no-start
    docker-compose restart

    if [ "$(container_status)" == "running" ]; then
        echo -e "\nINFO: container service \"${SERVICE_NAME}\" start successfully"
    elif [ "$(container_status)" == "restarting" ]; then
        echo -e "\nERROR: container service \"${SERVICE_NAME}\" start failed" 1>&2
        docker-compose logs 1>&2
    else
        echo -e "\nERROR: container service \"${SERVICE_NAME}\" start failed" 1>&2
        docker-compose logs 1>&2
        exit 1
    fi
}

restart(){
    echo "INFO: restarting container service \"${SERVICE_NAME}\" ..."
    #如果docker-compose.yml配置变更，可以通过(docker-compose up --no-start)触发重建容器
    docker-compose up --no-start
    docker-compose restart

    if [ "$(container_status)" == "running" ]; then
        echo -e "\nINFO: container service \"${SERVICE_NAME}\" restart success"
    else
        echo -e "\nERROR: container service \"${SERVICE_NAME}\" restart failed" 1>&2
        docker-compose logs 1>&2
        exit 1
    fi
}

remove(){
    container_id=$(docker-compose ps -q)
    if [ -z "${container_id}" ]; then
        echo "WARN: container service \"${SERVICE_NAME}\" does not exist"
        exit 0
    fi
    image_name=$(docker inspect -f "{{.Config.Image}}" "${container_id}")

    echo "INFO: removing container service \"${SERVICE_NAME}\" ..."
    docker-compose down -v

    #镜像可能被其它容器在使用，所以无法删除
    if docker rmi "$image_name" &> /dev/null
    then
        echo "INFO: container image \"${image_name}\" remove success"
    else
        echo "WARN: container image \"${image_name}\" remove failed"
    fi
}

status(){
    # created, restarting, running, removing, paused, exited, dead
    status=$(container_status)
    if [ "$status" == "running" ]; then
        echo "running"
    #elif [ "$status" == "created" ] || [ "$status" == "restarting" ] || [ "$status" == "removing" ] || [ "$status" == "paused" ] || [ "$status" == "exited" ]; then
    else
        echo "stopped"
    fi
}

runcmd(){
    containerId=$(docker-compose ps -q)
    if [ -z "${containerId}" ]; then
        echo "ERROR: container service \"${SERVICE_NAME}\" does not exist" 1>&2
        exit 1
    fi

    echo "INFO: container service \"${SERVICE_NAME}\" exec command: \"$*\""
    docker exec -i ${containerId} $@
}

case $1 in
    start)
    start
    ;;

    restart)
    restart
    ;;

    remove)
    remove
    ;;

    status)
    status
    ;;

    runcmd)
    shift;
    # shellcheck disable=SC2119
    runcmd "$@"
    ;;

    *)
    echo $"Usage: $0 start|restart|remove|status|runcmd" 1>&2
    ;;
esac

exit 0