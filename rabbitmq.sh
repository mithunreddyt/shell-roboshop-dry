#!/usr/bin/env bash
source common.sh

if [ -z "${roboshop_rabbitmq_password}" ];
  then
    echo "Variable roboshop_rabbitmq_password is missing"
    exit 1
fi

print_head "Configuring Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log}
status_check

print_head "Configuring Erlang Repos"
yum install erlang -y &>>${log}
status_check

print_head "Configuring Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log}
status_check

print_head "Configuring Erlang Repos"
yum install rabbitmq-server -y &>>${log}
status_check

print_head "Configuring Erlang Repos"
systemctl enable rabbitmq-server &>>${log}
status_check

print_head "Configuring Erlang Repos"
systemctl start rabbitmq-server &>>${log}
status_check

print_head "Configuring Erlang Repos"
rabbitmqctl list_users | grep roboshop &>>{log}
if [ $? -ne 0 ];
  then
    rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${log}
fi
status_check

print_head "Configuring Erlang Repos"
rabbitmqctl set_user_tags roboshop administrator &>>${log}
status_check

print_head "Configuring Erlang Repos"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log}
status_check