#!/usr/bin/env bash
source common.sh

print_head "Downloading remi package"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log}

print_head "Enabling Redis package"
dnf module enable redis:remi-6.2 -y &>>${log}

print_head "Installing Redis package"
yum install redis -y &>>${log}

print_head "configuration Change"
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  /etc/redis/redis.conf &>>${log}

print_head "Enabling Redis"
systemctl enable redis &>>${log}

print_head "Starting Redis"
systemctl start redis &>>${log}