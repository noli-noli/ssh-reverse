#! /bin/bash

############################################
################# 各変数定義 ################
############################################

#service関連ファイルの配置定義
SERVICEDIR="/etc/systemd/system"

#serviceファイル名
SERVICEFILE="ssh-tunnel.service"




############################################
############### 前処理ルーチン ##############
############################################

#実行ユーザーの確認
if [ "$(id -u)" -ne 0 ]; then
    echo "[Check:NG] Please run as root"
    exit 1
else
    echo "[Check:OK] Run as root"
fi

#ディレクトリとファイルの存在チェック
if [ ! -e ./$SERVICEFILE ]; then
    echo "[Check:NG] Not found ($SERVICEFILE)"
    exit 1
elif [ ! -e $SERVICEDIR ]; then
    echo "[Check:NG] Not found ($SERVICEDIR)"
    exit 1
else
    echo "[Check:OK] Found all files"
fi



############################################
########### サービスファイルの配置 ###########
############################################

#サービスファイル関連の配置
cp ./$SERVICEFILE $SERVICEDIR



############################################
########### サービスファイルの実行 ###########
############################################

systemctl daemon-reload

#サービスの自動起動
systemctl enable $SERVICEFILE

#各サービスの有効化
systemctl start $SERVICEFILE

exit 0
