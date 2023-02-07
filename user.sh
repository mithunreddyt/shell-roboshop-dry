#!/usr/bin/env bash

scriptLocation=$(pwd)
curl -sL httpsL//rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

mkdir /app

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

cd /app

unzip /tmp/user.zip

cd /app

npm install

cp "${scriptLocation}"/files/user.service /etc/systemd/system/user.service

systemctl daemon-reload

systemctl enable user

systemctl start user

cp "${scriptLocation}"/files/mongo.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org-shell -y

mongo --host 172.31.9.18 </app/schema/user.js