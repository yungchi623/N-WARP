#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=reboot_time
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
BASEDIR=$(dirname "$0")

if [[ $1 -eq 0 ]] || [[ $1 -eq 1 ]] ;then
        $BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","isOpen" $serial_no,$model_name,$1
else
        echo "wrong value!"
fi


