#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin
FILE_NAME=game_report
BASEDIR=$(dirname "$0")

modelFW=`cat /etc/os-release | grep 'VERSION=' | cut -d '=' -f2 | sed s/\"//g`
modelName=`fw_printenv -n mmodel`
reportDate=-d`date +%s`
serialNo=`fw_printenv -n SN`
playDate_ori=`cat /etc/4gamers/conf/game_report | grep 'playDate' | cut -d '=' -f2`
playDate=-d`date -d "$playDate_ori" +"%s"`
timeStart_ori=`cat /etc/4gamers/conf/game_report | grep 'timeStart' | cut -d '=' -f2`
timeStart=-d`date -d "$playDate_ori $timeStart_ori" +"%s"`
timeEnd_ori=`cat /etc/4gamers/conf/game_report | grep 'timeEnd' | cut -d '=' -f2`
timeEnd=-d`date -d "$playDate_ori $timeEnd_ori" +"%s"`
gameName=`cat /etc/4gamers/conf/game_report | grep 'gameName' | cut -d '=' -f2`
gameServer=`cat /etc/4gamers/conf/game_report | grep 'gameServer' | cut -d '=' -f2`
[ -z "$gameServer" ] && gameServer="N/A"

echo $modelFW
echo $modelName
echo $playDate
echo $timeStart
echo $timeEnd
echo $gameName
echo $gameServer

$BASEDIR/write_file.sh $FILE_NAME "serialNo","modelFW","modelName","playDate","timeStart","timeEnd","gameName","gameServer" $serialNo,$modelFW,$modelName,$playDate,$timeStart,$timeEnd,$gameName,$gameServer
