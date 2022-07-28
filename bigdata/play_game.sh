#!/bin/sh
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
FILE_NAME=play_datetime
BASEDIR=$(dirname "$0")

ip=$1
mac=$2
i=${mac//:/}
path=/etc/4gamers/tracefiles
PFile=${path}/play_game_data_${i}

serialNo=$(fw_printenv -n SN)
modelName=$(fw_printenv -n mmodel)

startDatetime=-d$(jq .sdate ${PFile})
endDatetime=-d$(jq .edate ${PFile})
gameId=$(jq .gameId ${PFile})
dhcpIp=${ip}
gameDeviceType=$(cat /etc/4gamers/conf/devInfo | grep ${dhcpIp} | cut -d ';' -f5 | sed s/[[:space:]]//g)
region=$(jq .region ${PFile})
region=${region//\"/}
inTraffic=$(jq .inTraffic ${PFile})
inTraffic=${inTraffic//\"/}
[ "${inTraffic}" == null ] && inTraffic=0
outTraffic=$(jq .outTraffic ${PFile})
outTraffic=${outTraffic//\"/}
[ "${outTraffic}" == null ] && outTraffic=0

straffic=$(jq .straffic ${PFile})
etraffic=$(jq .etraffic ${PFile})
tcTraffic=$((${etraffic}-${straffic}))

traceIp=$(jq .traceIp ${PFile})
traceIp=${traceIp//\"/}
avgVPing=$(jq .avgVPing ${PFile})
avgDPing=$(jq .avgDPing ${PFile})
denominator=$(jq .denominator ${PFile})
maxIspPing=$(jq .maxIspPing ${PFile})
minIspPing=$(jq .minIspPing ${PFile})
avgIspPing=$(jq .avgIspPing ${PFile})
maxDPing=$(jq .maxDPing ${PFile})
minDPing=$(jq .minDPing ${PFile})
medianDPing=$(jq .medianDPing ${PFile})
maxVPing=$(jq .maxVPing ${PFile})
minVPing=$(jq .minVPing ${PFile})
medianVPing=$(jq .medianVPing ${PFile})
VSpike=$(jq .VSpike ${PFile})
DSpike=$(jq .DSpike ${PFile})
avgVJitter=$(jq .avgVJitter ${PFile})
avgDJitter=$(jq .avgDJitter ${PFile})
perAvg=$(jq .avgOptima ${PFile})
perMax=$(jq .maxOptima ${PFile})
perMin=$(jq .minOptima ${PFile})
perMedian=$(jq .medianOptima ${PFile})
VLoss=$(jq .VLoss ${PFile})
DLoss=$(jq .DLoss ${PFile})
withVpn=$(jq .hasVPN ${PFile})

dnsip=$(uci -q get openvpn.sample_client.remote|awk '{print $1}')
dnsLoss=$(awk '$1>50{c++} END{print c+0}' /tmp/gamePeriodPing.${ip})

download=$(awk -F", " '{print $1/1000}' /tmp/DL_UL.${ip}|sort -n)
mindownload=$(echo $download|awk '{print $1}')
maxdownload=$(echo $download|awk '{print $NF}')
mediandownload=$(echo "$download" | awk 'NF{a[NR]=$1;c++}END {print (c%2==0)?(a[int(c/2)+1]+a[int(c/2)])/2:a[int(c/2)+1]}')

upload=$(awk -F", " '{print $2/1000}' /tmp/DL_UL.${ip}|sort -n)
minupload=$(echo $upload|awk '{print $1}')
maxupload=$(echo $upload|awk '{print $NF}')
medianupload=$(echo "$upload" | awk 'NF{a[NR]=$1;c++}END {print (c%2==0)?(a[int(c/2)+1]+a[int(c/2)])/2:a[int(c/2)+1]}')

if [ $(echo $inTraffic | grep 'K') ]; then
	inTraffic=$(echo $inTraffic | awk '{printf ("%d\n",$1*1024)}')
fi
if [ $(echo $outTraffic | grep 'K') ]; then
	outTraffic=$(echo $outTraffic | awk '{printf ("%d\n",$1*1024)}')
fi
if [ $(echo $inTraffic | grep 'M') ]; then
	inTraffic=$(echo $inTraffic | awk '{printf ("%d\n",$1*1024*1024)}')
fi
if [ $(echo $outTraffic | grep 'M') ]; then
	outTraffic=$(echo $outTraffic | awk '{printf ("%d\n",$1*1024*1024)}')
fi
if [ $(echo $inTraffic | grep 'G') ]; then
	inTraffic=$(echo $inTraffic | awk '{printf ("%d\n",$1*1024*1024*1024)}')
fi
if [ $(echo $outTraffic | grep 'G') ]; then
	outTraffic=$(echo $outTraffic | awk '{printf ("%d\n",$1*1024*1024*1024)}')
fi

echo "$serialNo / $modelName / $gameDeviceType / $dhcpIp"
echo "$startDatetime / $endDatetime / $gameId / $traceIp / $withVpn"
echo "----------------"
echo "ISP : $maxIspPing / $minIspPing / $avgIspPing"
echo "VPing : $maxVPing / $minVPing / $medianVPing"
echo "VJitter / VLoss : $avgVJitter / $VLoss"
echo "DPing : $maxDPing / $minDPing / $medianDPing"
echo "DJitter / DLoss : $avgDJitter / $DLoss"
echo "Optima : $perMax / $perMin / $perAvg / $perMedian"

dnsip=$(uci -q get openvpn.sample_client.remote)
dnsip=$(echo $dnsip|awk '{print $1}')
dnsloss=$(awk '$1>50{c++} END{print c+0}' /tmp/gamePeriodPing.${ip})

download=$(awk -F", " '{print $1/1000}' /tmp/DL_UL.${ip}|sort -n)
mindownload=$(echo $download|awk '{print $1}')
maxdownload=$(echo $download|awk '{print $NF}')
mediandownload=$(echo "$download" | awk 'NF{a[NR]=$1;c++}END {print (c%2==0)?(a[int(c/2)+1]+a[int(c/2)])/2:a[int(c/2)+1]}')

upload=$(awk -F", " '{print $2/1000}' /tmp/DL_UL.${ip}|sort -n)
minupload=$(echo $upload|awk '{print $1}')
maxupload=$(echo $upload|awk '{print $NF}')
medianupload=$(echo "$upload" | awk 'NF{a[NR]=$1;c++}END {print (c%2==0)?(a[int(c/2)+1]+a[int(c/2)])/2:a[int(c/2)+1]}')


echo ${serialNo},${modelName},${startDatetime},${endDatetime},${gameId},${gameDeviceType},${dhcpIp},${region},${inTraffic},${outTraffic},${tcTraffic},${traceIp},${avgVPing},${avgDPing},${denominator},${maxIspPing},${minIspPing},${avgIspPing},${maxDPing},${minDPing},${medianDPing},${maxVPing},${minVPing},${medianVPing},${perAvg},${perMax},${perMin},${perMedian},${VLoss},${DLoss},${withVpn},${dnsip},${dnsLoss},${mindownload},${mediandownload},${maxdownload},${minupload},${medianupload},${maxupload},${VSpike},${DSpike},${avgVJitter},${avgDJitter}

$BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","startDatetime","endDatetime","gameId","gameDeviceType","dhcpIp","region","inTraffic","outTraffic","tcTraffic","traceIp","avgVPing","avgDPing","denominator","maxIspPing","minIspPing","avgIspPing","maxDPing","minDPing","medianDPing","maxVPing","minVPing","medianVPing","perAvg","perMax","perMin","perMedian","vloss","dloss","withVpn","dnsIp","dnsLoss","minDownload","medianDownload","maxDownload","minUpload","medianUpload","maxUpload","vspike","dspike","avgvjitter","avgdjitter" ${serialNo},${modelName},${startDatetime},${endDatetime},${gameId},${gameDeviceType},${dhcpIp},${region},${inTraffic},${outTraffic},${tcTraffic},${traceIp},${avgVPing},${avgDPing},${denominator},${maxIspPing},${minIspPing},${avgIspPing},${maxDPing},${minDPing},${medianDPing},${maxVPing},${minVPing},${medianVPing},${perAvg},${perMax},${perMin},${perMedian},${VLoss},${DLoss},${withVpn},${dnsip},${dnsLoss},${mindownload},${mediandownload},${maxdownload},${minupload},${medianupload},${maxupload},${VSpike},${DSpike},${avgVJitter},${avgDJitter}
