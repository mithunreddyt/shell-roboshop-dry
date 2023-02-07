#!/usr/bin/env bash

scriptLocation=$(pwd)
log=/tmp/roboshop.log

print_head() {
  echo -e "\e[31m$1\e[0m"
}