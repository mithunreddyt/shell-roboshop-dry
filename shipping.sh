#!/usr/bin/env bash

source common.sh

if [ -z "${root_mysql_password}" ];
  then
    echo "Variable root_mysql_password is missing"
    exit
fi

component=shipping
schema_laod=true
schema_type=mysql
maven