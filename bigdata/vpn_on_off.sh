#!/bin/sh
#/etc/4gamers/vpn_on_off.sh [switch on/off] [device ip]
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

FILE_NAME=vpn_on_off
serial_no=$(fw_printenv -n SN)
model_name=$(fw_printenv -n mmodel)
BASEDIR=$(dirname "$0")

switchOnOff=$1
deviceIP=$2

mac=$(grep "^${deviceIP}\t" /etc/4gamers/conf/actived_device | awk {'print $2'})

publicIP=$(curl -s ifconfig.me)

vpnStatus=$(uci -q get nwarp.vpn.status)

$BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","userOnOff","vpnStatus","ip","macAddress","deviceIp" $serial_no,$model_name,$switchOnOff,$vpnStatus,$publicIP,$mac,$deviceIP
