#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin

SERIAL_NO=$(fw_printenv -n SN)
ROUTER_DIR=$SERIAL_NO/
SOR_PATH=/etc/$SERIAL_NO
TMP_PATH=$SOR_PATH/.tmp

tar_data(){
#打包檔案檔案名稱SERIAL_NO_yyyyMMdd.tar.gz
    TAR_FILENAME=${SERIAL_NO}"_$(date +'%Y%m%d').tar.gz"
    if [ ! -e $SOR_PATH ];then
        exit 1
    fi
    cd $SOR_PATH
    rm $TMP_PATH/*
    rmdir $TMP_PATH
    tar -zcvf $TAR_FILENAME .
    export TAR_FILE=${SOR_PATH}/${TAR_FILENAME}
}

commit_data(){
    DES_DIR=/n-warp-sftp/router/N-WarpData/                             #N-WarpData目的地路徑
    FILE_DIR=${DES_DIR}${ROUTER_DIR}                                    #N-WarpData目的地路徑/各自Router資料夾
    BASEDIR=$(dirname "$0")
    RSA_KEY=$BASEDIR/id_rsa                                             #RSA KEY檔案位置

    sftp -i $RSA_KEY -o StrictHostKeyChecking=no router@sftp.n-warp.com << EOF
    mkdir $FILE_DIR

    put $TAR_FILE $FILE_DIR
    exit
EOF
    rm $SOR_PATH/*
    rm -rf $TMP_PATH
}

tar_data
commit_data
