#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

SERIAL_NO=$(fw_printenv -n SN)
ROUTER_DIR=$SERIAL_NO/
SOR_PATH=/etc/$SERIAL_NO
TMP_PATH=$SOR_PATH/.tmp

WOTAN_SERVER=$(grep ^wotan_server /etc/4gamers/conf/publishServer|awk -F= {'print $2'})

json_data(){
    par_str=$1
    var_str=$2

    par_index=0

    for line in `awk -v v=${par_str} 'BEGIN {
     n=split(v,a,",")
     for (i=1;i<=n;i++) {
     print a[i]
     }
    }'`; do
      eval par_$par_index=$line
      par_index=`expr $par_index + 1`
    done

    var_index=0

    for line in `awk -v v=${var_str} 'BEGIN {
     n=split(v,a,",")
     for (i=1;i<=n;i++) {
     print a[i]
     }
    }'`; do
      eval var_$var_index=$line
      var_index=`expr $var_index + 1`
    done

    if [ $var_index != $par_index ];then
        #echo "number of par and var no match."
        return 1
    fi

    count=`expr $var_index - 1`
    count_index=0
    fw=$(cat /etc/openwrt_release |grep DISTRIB_RELEASE |awk -F\' '{print $2}')
    login_name=$(uci -q get nwarp.member.userID)
    echo "{"
    #echo "'timeStamp':'$(date +"%Y-%m-%d %H:%M:%S")',"
    echo "'timeStamp':$(date +%s),"
    echo "'modelFW':'"$fw"',"

    [[ -z "$login_name" ]] && echo "'username':'N/A'," || echo "'username':'"$login_name"',"

    while [ $count_index -le $count ]
    do
    par_get_value="par_"$count_index

    eval echo "\'\$$par_get_value\':"

    var_get_value="var_"$count_index
        if [ -n "$(eval echo \$$var_get_value| sed -n "/^[0-9]\+$/p")" ];then            #判斷一般數字
            eval echo \$$var_get_value
        elif eval echo \$$var_get_value|grep "\." >/dev/null 2>&1;then                   #判斷一般浮點數
        {
            eval check=\$$var_get_value
            #check_array=(${check//./ })
            #len=${#check_array[@]}
            check_index=0

            for line in `awk -v v=${check} 'BEGIN {
            n=split(v,a,".")
            for (i=1;i<=n;i++) {
            print a[i]
            }
                }'`; do
            eval check_$check_index=$line
            check_index=`expr $check_index + 1`
            done

            is_float=true
            final_string=""
            carr_index=0

            while [ $carr_index -lt $check_index ]
            #for carr in "${check_array[@]}"
            do
                carr_get_value="check_"$carr_index
                if eval echo \$$carr_get_value|grep "^\-" >/dev/null 2>&1;then                    #切割負號浮點數
                {
                    eval par_value=\$$carr_get_value
                    par_value_index=0
                    for line in `awk -v v=${par_value} 'BEGIN {
                    n=split(v,a,"-")
                    for (i=1;i<=n;i++) {
                    print a[i]
                    }
                    }'`; do
                    eval par_value_$par_value_index=$line
                    par_value_index=`expr $par_value_index + 1`
                    done
                    #par_value_string=(${par_value//-/ })
                    eval final_string=$par_value_0
                }
                elif eval echo \$$carr_get_value|grep "^\+" >/dev/null 2>&1;then                   #切割正號浮點數
                {
                    #par_value=$carr
                    #par_value_string=(${par_value//+/ })
                    #final_string=$par_value_string
                    eval par_value=\$$carr_get_value
                    par_value_index=0
                    for line in `awk -v v=${par_value} 'BEGIN {
                    n=split(v,a,"+")
                    for (i=1;i<=n;i++) {
                    print a[i]
                    }
                    }'`; do
                    eval par_value_$par_value_index=$line
                    par_value_index=`expr $par_value_index + 1`
                    done
                    eval final_string=$par_value_0
                }
                else
                {
                    eval final_string=\$$carr_get_value
                    #final_string=$carr
                }
                fi
                carr_index=`expr $carr_index + 1`
                if [ -n "$(echo $final_string| sed -n "/^[0-9]\+$/p")" ];then 
                    continue
                fi
                is_float=false
            done
            if [ "$is_float" = true ];then                   #是否為+d.+d
            {
               if [ $check_index -eq 2 ]; then
                  eval echo \$$var_get_value
               else
                  eval echo  "\'\$$var_get_value\'"
               fi
            }
            else
               eval echo  "\'\$$var_get_value\'"
            fi
        }
        elif eval echo \$$var_get_value|grep "^\-d" >/dev/null 2>&1;then
        {
            eval par_value=\$$var_get_value
            par_value_index=0
            for line in `awk -v v=${par_value} 'BEGIN {
            n=split(v,a,"-d")
            for (i=1;i<=n;i++) {
            print a[i]
            }
            }'`; do
            eval par_value_$par_value_index=$line
            par_value_index=`expr $par_value_index + 1`
            done

            if [ -n "$(echo ${par_value_0}| sed -n "/^[0-9]\+$/p")" ];then    #判斷DATETIME
                #date_str=$(date -d @${par_value_0} "+%F %T")
                eval echo ${par_value_0}
            else
                eval echo  "\'\$$var_get_value\'"
            fi
        }
        elif eval echo \$$var_get_value|grep "^\-" >/dev/null 2>&1;then
        {
            eval par_value=\$$var_get_value
            par_value_index=0
            for line in `awk -v v=${par_value} 'BEGIN {
            n=split(v,a,"-")
            for (i=1;i<=n;i++) {
            print a[i]
            }
            }'`; do
            eval par_value_$par_value_index=$line
            par_value_index=`expr $par_value_index + 1`
            done

            if [ -n "$(echo ${par_value_0}| sed -n "/^[0-9]\+$/p")" ];then    #判斷負號數字
                eval echo \$$var_get_value
            else
                eval echo  "\'\$$var_get_value\'"
            fi
        }
        elif eval echo \$$var_get_value|grep "^\+" >/dev/null 2>&1;then
        {
            eval par_value=\$$var_get_value
            par_value_index=0
            for line in `awk -v v=${par_value} 'BEGIN {
            n=split(v,a,"+")
            for (i=1;i<=n;i++) {
            print a[i]
            }
            }'`; do
            eval par_value_$par_value_index=$line
            par_value_index=`expr $par_value_index + 1`
            done

            if [ -n "$(echo ${par_value_0}| sed -n "/^[0-9]\+$/p")" ];then    #判斷負號數字
                eval echo \$$var_get_value
            else
                eval echo  "\'\$$var_get_value\'"
            fi
        }
        else
            eval echo  "\'\$$var_get_value\'"
        fi

        if [ $count_index -lt $count ];then
            echo ","
        fi
      count_index=`expr $count_index + 1`
    done
    echo "}"
}

read_file(){
    cat $1 | while read LINE
    do
        echo $LINE
    done
}

write_data(){
    json_str=$(json_data $2 $3)
    if [ -z "$json_str" ]; then
        return 1
    fi
    WRITE_NAME="$1.json"

    if [ ! -e $SOR_PATH ];then
        mkdir $SOR_PATH
    fi

    if [ ! -e $TMP_PATH ];then
        mkdir $TMP_PATH
    fi

    FILE=$SOR_PATH/$WRITE_NAME
    FILE_TMP=$TMP_PATH/"$1.txt"
    #輸出檔案

    if [ -f $FILE_TMP ]
    then
        echo ","$json_str >> $FILE_TMP
    else
        echo $json_str >> $FILE_TMP
    fi
        json_str=$(read_file $FILE_TMP)
        json_str="{'"$1"':["$json_str"]}"
        printf '%s' "${json_str}" | python -c "import json,sys; json.encoder.FLOAT_REPR = lambda o: format(o, '.2f')
print json.dumps(eval(sys.stdin.read()), sort_keys=True, indent=4, separators=(',', ': '))" > $FILE
}

get_token()
{
    time=$(date -u +%Y%m%d%H%M)
    SecretSalt='rlwotan-20190419'
    suffix=$(echo -n "$time$SecretSalt" | openssl dgst -sha256 -binary | xxd -p -c 32 | tr 'a-f' 'A-F' )
    token="$time-$suffix"

    echo $token
}

insert_db()
{
    wotan_token=$(get_token)
    json_str=$(json_data $2 $3)
    if [ -z "$json_str" ]; then
        echo 1
        return 1
    fi

    post_json=$(echo ${json_str} | python -c "import json,sys; json.encoder.FLOAT_REPR = lambda o: format(o, '.2f')
print json.dumps(eval(sys.stdin.read()), sort_keys=True, indent=4, separators=(',', ': '))")

    case "$1" in
        first_launch_time) curl_path="${WOTAN_SERVER}/big-data/api/first-launch-time"
            ;;
        connect_count) curl_path="${WOTAN_SERVER}/big-data/api/connect-count"
            ;;
        unknown_packet) curl_path="${WOTAN_SERVER}/big-data/api/unknown-packet"
            ;;
        play_datetime) curl_path="${WOTAN_SERVER}/big-data/api/play-datetime"
            ;;
        router_area) curl_path="${WOTAN_SERVER}/big-data/api/router-area"
            ;;
        detect_cpu) curl_path="${WOTAN_SERVER}/big-data/api/detect-cpu"
            ;;
        device_type_of_lan) curl_path="${WOTAN_SERVER}/big-data/api/device-type-of-lan"
            ;;
        latency_router_and_server) curl_path="${WOTAN_SERVER}/big-data/api/latency-router-and-server"
            ;;
        dashboard_stay) curl_path="${WOTAN_SERVER}/big-data/api/dashboard-stay"
            ;;
        game_report) curl_path="${WOTAN_SERVER}/big-data/api/game-report"
            ;;
        lan_count) curl_path="${WOTAN_SERVER}/big-data/api/lan-count"
            ;;
        reboot_time) curl_path="${WOTAN_SERVER}/big-data/api/reboot-time"
            ;;
        vpn_on_off) curl_path="${WOTAN_SERVER}/big-data/api/vpn-on-off"
            ;;
        get_public_ip) curl_path="${WOTAN_SERVER}/big-data/api/get-public-ip"
            ;;
        *) echo 1 return 1
    esac

  #curl -XPOST \
    curl_rtn=$(curl -XPOST -s -w "%{http_code}" -o /dev/null \
       -H 'accept: application/json' \
       -H 'content-type: application/json' \
       -H "X-WOTAN-BIG-DATA-TOKEN: $wotan_token" \
       -d "$post_json" \
       "$curl_path")
    echo $curl_rtn
}

#ARG_ARRAY=($@)
#write_data "${ARG_ARRAY[@]}"
#echo "${#ARG_ARRAY[@]}"

#write_data $1 $2 $3
    rtn=$(insert_db $1 $2 $3)
    echo $rtn
