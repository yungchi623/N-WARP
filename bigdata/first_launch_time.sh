#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=first_launch_time
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
boot_datetime='-d'$(date +%s)
BASEDIR=$(dirname "$0")
$BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","bootDatetime" $serial_no,$model_name,$boot_datetime
