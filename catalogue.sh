#!/usr/bin/env bash

scriptLocation=$(pwd)
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

mkdir /app

curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

cd /app

unzip /tmp/catalogue.zip

cd /app

npm install

cp "${scriptLocation}"/files/catalogue.service /etc/systemd/system/catalogue.service

systemctl deamon-reload

systemctl enable catalogue
systemctl start catalogue

cp "${scriptLocation}"/files/mongo.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org-shell -y

mongo --host 172.31.9.18 </app/schema/catalogue.js
