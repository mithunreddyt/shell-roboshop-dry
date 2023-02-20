#!/usr/bin/env bash

scriptLocation=$(pwd)
log=/tmp/roboshop.log

print_head() {
  echo -e "\e[1m$1\e[0m"
}

status_check() {
  if [ $? -eq 0 ];
    then
      echo -e "\e[1;32mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[0m"
      echo "Refer Log file for more information, LOG - ${log}"
  fi
}

app_preq() {
  print_head "Add Application user"
    id roboshop &>>${log}
    if [ $? -ne 0 ];
      then
        useradd roboshop &>>{log}
    fi
    status_check

  print_head "creating app directory"
  mkdir -p /app &>>${log}
  status_check

  print_head "Domloading content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  status_check

  print_head "Deleting old content"
  rm -rf /app/* &>>${log}
  status_check

  print_head "Switching directory and unzipping content"
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  status_check
}

systemd_setup() {
  print_head "Creating ${component} service file"
  cp "${scriptLocation}"/files/${component}.service /etc/systemd/system/${component}.service &>>${log}
  status_check

  print_head "Deamon reload"
  systemctl daemon-reload &>>${log}
  status_check

  print_head "Enable ${component} service"
  systemctl enable ${component} &>>${log}
  status_check

  print_head "Start ${component} service"
  systemctl start ${component} &>>${log}
  status_check
}

load_schema() {
  if [ ${schema_load} == "true" ];
    then
      if [ ${schema_type} == "mongo" ];
        then
          print_head "Configuring Mongo repo"
          cp ${scriptLocation}/files/mongodb.repo /etc/yum.repos.d/mongod.repo &>>{log}
          status_check

          print_head "Install Mongo Client"
          yum install mongod-org-shell -y &>>{log}
          status_check

          print_head "Load Schema"
          mongo --host mongodb-dev.mithundevops.online </app/schema/${component}.js &&>{log}
      fi

      if [ ${schema_type} == "mysql" ];
        then
          print_head "Install Mysql client"
          yum install mysql -y &>>${log}
          status_check

          print_head "Load Schema"
          mysql -h mysql-dev.mithundevops.online -uroot -p${root_mysql_password} < /app/schema/${component}.sql
          status_check
      fi
  fi
}

node_js() {
  print_head "Downloading Node Repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  status_check

  print_head "Installing Nodejs"
  yum install nodejs -y &>>${log}
  status_check

  app_preq

  print_head "Installing Npm"
  npm install &>>${log}
  status_check

  systemd_setup

  load_schema
}

maven(){

  print_head "Installing Maven"
  yum install maven -y &>>${log}
  status_check

  app_preq

  print_head "moving cleaning packaging"
  cd /app
  mvn clean package
  mv target/{component}-1.0.jar {component}.jar

  systemd_setup

  load_schema
}

python(){
  print_head "Installing python"
  yum install python36 gcc python3-devel -y &>>${log}
  status_check

  app_preq

  print_head "installing requirements"
  cd /app &>>${log}
  pip3.6 install -r requirements.txt &>>{log}
  status_check

  print_head "Update Passwords in Service File"
  sed -i -e "s/roboshop_rabbitmq_password/${roboshop_rabbitmq_password}/" ${script_location}/files/${component}.service  &>>${LOG}
  status_check

  systemd_setup
}

golang() {
   print_head "Installing golang"
   yum install golang -y &>>${log}
   status_check

   app_preq

  print_head "installing dependencies"
  cd /app &>>${log}
  go mod init dispatch &>>${log}
  go get &>>${log}
  go build &>>${log}
  status_check

  print_head "Update Passwords in Service File"
  sed -i -e "s/roboshop_amqp_password/${roboshop_amqp_password}/" ${script_location}/files/${component}.service  &>>${LOG}
  status_check
}
