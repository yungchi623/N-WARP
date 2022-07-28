#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=detect_cpu
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
BASEDIR=$(dirname "$0")

irq=$(top -n 1 | grep 'CPU' | awk 'NR==1 {print $12}' | sed 's/%//g')
sirq=$(top -n 1 | grep 'CPU' | awk 'NR==1 {print $14}' | sed 's/%//g')
usr=$(top -n 1 | grep 'CPU' | awk 'NR==1 {print $2}' | sed 's/%//g')

cpu_percent=`expr $irq + $sirq + $usr`

#echo "${irq} + ${sirq} + ${usr} = ${cpu_percent}"

if [ $cpu_percent -ge 50 ];then
   $BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","cpuUsagePercent" $serial_no,$model_name,$cpu_percent
fi
