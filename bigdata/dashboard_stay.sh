#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=dashboard_stay
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
BASEDIR=$(dirname "$0")

$BASEDIR/write_file.sh $FILE_NAME  "serialNo","modelName","isStart" $serial_no,$model_name,$1
