#!/usr/bin/env bash
source common.sh

print_head "Downloading Node rpm"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>{log}
status_check

print_head "Installing Nodejs"
yum install nodejs -y &>{log}
status_check

print_head "Adding user"
useradd roboshop
if [ $? -eq 0 ];
  then
    echo -e "\e[31mUSEREXISTED\e[0m"
  else
    echo -e "\e[33mUSERCREATED\e[0m"
fi

print_head "creating app directory"
mkdir /app
status_check

print_head "Domloading content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
status_check

print_head "Switching directory and unzipping content"
cd /app
unzip /tmp/catalogue.zip
status_check

print_head "Installing Npm"
npm install
status_check

print_head "Creating catalogue service"
cp "${scriptLocation}"/files/catalogue.service /etc/systemd/system/catalogue.service
status_check

print_head "Deamon reload"
systemctl deamon-reload
status_check

print_head "Enable Catalogue"
systemctl enable catalogue
status_check

print_head "Start Catalogue"
systemctl start catalogue
status_check

mongo

print_head "Installing mongo shell"
yum install mongodb-org-shell -y
status_check

mongo --host mongodb-dev.mithundevops.online </app/schema/catalogue.js
