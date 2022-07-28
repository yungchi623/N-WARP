#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=get_public_ip
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
publicip=$(curl --silent ifconfig.me)
BASEDIR=$(dirname "$0")

$BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","publicIp" $serial_no,$model_name,$publicip
