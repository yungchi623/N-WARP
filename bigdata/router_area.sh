#!/bin/sh

serialNo=`fw_printenv -n SN`
modelName=`fw_printenv -n mmodel`
CountryId=`cat /etc/4gamers/conf/initconfig  | grep country | cut -d '=' -f2`
AdminDistId=`cat /etc/4gamers/conf/initconfig  |grep admin_dist | cut -d '=' -f2`
regionMapFile='/etc/4gamers/conf/region_map'

echo $serialNo
echo $modelName
echo $CountryId
echo $AdminDistId

Country=$(grep ^${CountryId}= ${regionMapFile}|awk -F= '{print $2}')

if [ "$AdminDistId" == "0" ]; then
    AdminDist=$(grep ^0= ${regionMapFile}|awk -F= '{print $2}')
else
    AdminDist=$(grep ${CountryId}.${AdminDistId}= ${regionMapFile}|awk -F= '{print $2}')
fi

res=$(/etc/4gamers/bigdata/write_file.sh router_area "serialNo","modelName","manualCountry","manualCity" $serialNo,$modelName,$Country,$AdminDist)
if [ "$res" == "200" ]; then
  touch /etc/4gamers/conf/region_responsed
fi
