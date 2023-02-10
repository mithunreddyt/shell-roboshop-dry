#!/usr/bin/env bash
source common.sh
if [ -z "${root_mysql_password}" ];
  then
    echo "Variable root_mysql_password is missing"
    exit 1
fi
print_head "Disable Mysql Default Module"
dnf module disable mysql -y &>>${log}
status_check

print_head "Copy Mysql Repo file"
cp "${scriptLocation}"/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log}
status_check

print_head "Install Mysql server"
yum install mysql-community-server -y &>>${log}
status_check

print_head "Enable mysql"
systemctl enable mysqld &>>${log}
status_check

print_head "Start Mysql"
systemctl start mysqld &>>${log}
status_check

print_head "Reset Default Database password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${log}
if [ $? -eq 0 ];
  then
    echo "password already changed"
fi
status_check