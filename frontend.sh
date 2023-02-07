#!/usr/bin/env bash
source common.sh

scriptLocation=$(pwd)
log=$(log)

print_head "Installing Nginx"
yum install nginx -y &> "${log}"

print_head "Enabling Nginx"
systemctl enable nginx &> "${log}"

print_head "Start Nginx"
systemctl start nginx &> "${log}"

print_head "Cleaning Nginx old content"
rm -rf /usr/share/nginx/html/* &> "${log}"

print_head "Downloading frontend project"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &> "${log}"

print_head "Extracting the frontend code to Nginx/html where the code gets served"
cd /usr/share/nginx/html &> "${log}"
unzip /tmp/frontend.zip &> "${log}"

print_head "Creating roboshop configuration"
cp "${scriptLocation}"/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &> "${log}"

print_head "Restarting Nginx"
systemctl restart nginx &> "${log}"