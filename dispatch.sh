#!/usr/bin/env bash

source common.sh

component=dispatch
schema_load=false

if [ -z "${roboshop_amqp_password}" ]; then
  echo "Variable roboshop_amqp_password is missing"
  exit 1
fi

golang