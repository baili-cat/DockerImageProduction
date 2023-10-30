#!/bin/bash
# Create Rabbitmq user
#需要docker compose 指定RABBITMQ_PID_FILE变量
#这里要后台执行，需要等rabbitmq-server启动后才能添加用户
( rabbitmqctl wait --timeout 60 $RABBITMQ_PID_FILE ; \
rabbitmqctl add_user $RABBITMQ_USERNAME $RABBITMQ_PASSWORD 2>/dev/null ; \
rabbitmqctl set_user_tags $RABBITMQ_USERNAME administrator ; \
rabbitmqctl set_permissions -p / $RABBITMQ_USERNAME  ".*" ".*" ".*" ; \
echo "*** User '$RABBITMQ_USERNAME' with password '$RABBITMQ_PASSWORD' completed. ***" ; \
echo "*** Log in the WebUI at port 15672 (example: http:/localhost:15672) ***") &
rabbitmq-plugins enable rabbitmq_management &
# $@ is used to pass arguments to the rabbitmq-server command.
# For example if you use it like this: docker run -d rabbitmq arg1 arg2,
# it will be as you run in the container rabbitmq-server arg1 arg2
rabbitmq-server $@