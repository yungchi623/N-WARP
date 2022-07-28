#!/bin/sh

export  PATH=/bin:/sbin:/usr/bin:/usr/sbin
FILE_NAME=unknown_packet

ipset_cmd=/etc/4gamers/conf/ipset_cmd

serialNo=`fw_printenv -n SN`
modelName=`fw_printenv -n mmodel`
startDatetime=-d`date +%s`
BASEDIR=$(dirname "$0")

routerIP=`ifconfig eth0.2 | awk 'NR==2 {print $2}' | cut -d ':' -f2`
tcpdump -i eth0.2 -ntq not dst $routerIP and udp and not ip6 and not portrange 1-1000 and not port 1194 > $BASEDIR/catch_packets &

upid=$!
#echo $upid
sleep 1680
kill $upid
endDatetime=-d`date +%s`

cat $BASEDIR/catch_packets | cut -d '>' -f2 | cut -d '.' -f1-5 | awk '{print $1}' | cut -d':' -f1 | awk ' !x[$0]++' > $BASEDIR/catch_packetsNR
sed -i "/255.255.255.255/d" $BASEDIR/catch_packetsNR

#remove ip of game list
filename=$BASEDIR/catch_packetsNR
for packNR in `cat $filename`; do
        packNR_cut=`echo $packNR | cut -d '.' -f1-2`
        ipsubnet=`ipset list ipport | grep ${packNR_cut} | head -n1 | cut -d ',' -f1`
#        ipsubnet=`grep ${packNR_cut} ${ipset_cmd} | head -n1 | cut -d ',' -f1`
#        ipsubnet=$(cat ${ipsubnet} | awk '{print $NR}')
        echo $ipsubnet
        if [ `echo $ipsubnet | grep '/'` ];then
                if [ `/etc/4gamers/ipconver $packNR $ipsubnet | grep "T"` ]; then
                        sed -i "/${packNR}/d" $BASEDIR/catch_packetsNR
                fi
        fi
done

desPacketIP=`cat $BASEDIR/catch_packetsNR | xargs | sed 's/\s\+/_/g'`

number=`wc -l $BASEDIR/catch_packetsNR | cut -d ' ' -f1`
numberOfPackets=`expr $number - 1`
echo $desPacketIP
rm $BASEDIR/catch_packets

$BASEDIR/write_file.sh $FILE_NAME "serialNo","modelName","startDatetime","endDatetime","desPacketIP","numberOfPackets" $serialNo,$modelName,$startDatetime,$endDatetime,$desPacketIP,$numberOfPackets
