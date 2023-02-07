#!/usr/bin/env bash
source common.sh


print_head "Installing Nginx"
yum install nginx -y &> "${Log}"

print_head "Enabling Nginx"
systemctl enable nginx &> "${Log}"

print_head "Start Nginx"
systemctl start nginx &> "${Log}"

print_head "Cleaning Nginx old content"
rm -rf /usr/share/nginx/html/* &> "${Log}"

print_head "Downloading frontend project"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &> "${Log}"

print_head "Extracting the frontend code to Nginx/html where the code gets served"
cd /usr/share/nginx/html &> "${Log}"
unzip /tmp/frontend.zip &> "${Log}"

print_head "Creating roboshop configuration"
cp "${scriptLocation}"/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &> "${Log}"

print_head "Restarting Nginx"
systemctl restart nginx &> "${Log}"