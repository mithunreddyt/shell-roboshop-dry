#!/usr/bin/env bash

scriptLocation=$(pwd)
log=/tmp/roboshop.log

print_head() {
  echo -e "\e[31m$1\e[0m"
}

status_check() {
  if [ $? -eq 0 ];
    then
      echo -e "\e[32mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[0m"
  fi
}

mongo() {
  print_head "Creating mongo repo files"
  cp ${scriptLocation}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>{log}
  status_check

  print_head "Installing mongo Shell"
  yum install mongodb-org-shell -y &>>${log}
  status_check

  print_head "Downloading Schema"
  mongo --host mongodb-dev.mithundevops.online </app/schema/${component}.js &>>${log}
}

Node_js() {
  print_head "Downloading Node rpm"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  status_check

  print_head "Installing Nodejs"
  yum install nodejs -y &>>${log}
  status_check

  print_head "Adding user"
  useradd roboshop &>>${log}
  id roboshop &>>${log}
  status_check

  print_head "creating app directory"
  mkdir /app
  if [ $? -eq 0 ];
    then
      rm -rf
  fi
  status_check

  print_head "Domloading content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  status_check

  print_head "Switching directory and unzipping content"
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  status_check

  print_head "Installing Npm"
  npm install &>>${log}
  status_check

  print_head "Creating catalogue service"
  cp "${scriptLocation}"/files/${component}.service /etc/systemd/system/${component}.service &>>${log}
  status_check

  print_head "Deamon reload"
  systemctl daemon-reload &>>${log}
  status_check

  print_head "Enable Catalogue"
  systemctl enable ${component} &>>${log}
  status_check

  print_head "Start Catalogue"
  systemctl start ${component} &>>${log}
  status_check

}
