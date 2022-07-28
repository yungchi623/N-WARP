#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=connect_count
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
ip=`cat /etc/4gamers/conf/nodelist | awk '{print $3}'`

ping_status(){
    result="fail"
    for p in $ip; do
        /etc/4gamers/udpclient $p > /dev/null
        if [ $? -eq 0 ]
        then
            result="success"
            break
        fi
    done
    echo $result
}

ping_result=$(ping_status)
BASEDIR=$(dirname "$0")
$BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","connectStatus" $serial_no,$model_name,$ping_result
