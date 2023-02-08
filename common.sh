#!/usr/bin/env bash

scriptLocation=$(pwd)
log=/tmp/roboshop.log

print_head() {
  echo -e "\e[31m$1\e[0m"
}

status_check() {
  if [ $? -eq 0 ];
    then
      echo -e "\e[33mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[0m"
  fi
}