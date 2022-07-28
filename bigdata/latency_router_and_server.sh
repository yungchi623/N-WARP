#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=latency_router_and_server
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
ip=`cat /etc/4gamers/conf/nodelist | awk '{print $3}'`
BASEDIR=$(dirname "$0")

for p in $ip; do
    latency_time=$(/etc/4gamers/udpclient $p)
    if [ "$latency_time" == "N/A" ];then
        latency_time=-1
    fi
    area=`cat /etc/4gamers/conf/nodelist |grep $p| awk '{print $1}'`
    $BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","latencyTime","area" $serial_no,$model_name,$latency_time,$area
done

    latency_time=$(ping -c 1 168.95.1.1 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
    if [ "$latency_time" == "N/A" ];then
        latency_time=-1
    fi
    area="hinet-dns"
    $BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","latencyTime","area" $serial_no,$model_name,$latency_time,$area
