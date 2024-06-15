#! /bin/bash

############################################
################# 各変数定義 ################
############################################

#service関連ファイルの配置定義
SERVICEDIR="/etc/systemd/system"

#serviceファイル名
SERVICEFILE="ssh-tunnel-main.service"



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



############################################
############### メインルーチン ##############
############################################

#関連サービスの停止
systemctl stop $SERVICEFILE

#関連サービスの削除
systemctl disable $SERVICEFILE 

#関連ファイルの削除
rm $SERVICEDIR/$SERVICEFILE

#デーモンの再読み込み
systemctl daemon-reload
systemctl reset-failed