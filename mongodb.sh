#!/usr/bin/env bash

source common.sh

print_head "Copy MongoDB Repo File"
cp ${scriptLocation}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>{log}
status_check

print_head "Installing mongod"
yum install mongodb-org -y &>>${log}
status_check

print_head "Updating Mongodb Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>${log}
status_check

print_head "Enabling mongod"
systemctl enable mongod &>>${log}
status_check

print_head "Restarting Mongod"
systemctl restart mongod &>>${log}
status_check