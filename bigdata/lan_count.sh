#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=lan_count
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
BASEDIR=$(dirname "$0")

port=$(swconfig dev switch0 show|grep "link: port:[1-4] link:up"| cut -d ':' -f3 |cut -d ' ' -f1)
lan_count=0
port_number='N/A'

for p in $port; do
    lan_count=$(( $lan_count + 1 ))
done

if [ $lan_count != 0 ];then
   port_number=$(echo $port | sed -e "s/ /_/g")
fi

$BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","lanCount","portNumber" $serial_no,$model_name,$lan_count,$port_number


