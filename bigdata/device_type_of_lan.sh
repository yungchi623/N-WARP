#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=device_type_of_lan
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
BASEDIR=$(dirname "$0")

cat /etc/4gamers/conf/devInfo | while read LINE
do
    device_type=$(echo $LINE | cut -d ';' -f5 | sed -e "s/ //g")
    dhcp_ip=$(echo $LINE | cut -d ';' -f2)
    dhcp_req=$(echo $LINE | cut -d ';' -f6 | sed -e "s/,/_/g")
    $BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","deviceType","dhcpIp","dhcpRequest" $serial_no,$model_name,$device_type,$dhcp_ip,$dhcp_req
done


