FROM ubuntu:22.04

#docker-composeから受け取った引数(proxyのアドレス)を環境変数にセット
#ARG http_tmp
#ARG https_tmp
#ENV http_proxy=$http_tmp
#ENV https_proxy=$https_tmp


#aptのTime Zone設定でハングアップしない様に予め指定及び設定する
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


#コンテナ内で使用するパッケージをインストール
RUN apt update -y && apt upgrade -y
RUN apt install -y nano tmux systemd init sed openssh-server


#chroot用のユーザー作成
RUN useradd -m user
RUN echo 'user:password' | chpasswd


#chroot関連の設定
RUN cp -p -r /bin /home/user/bin
RUN cp -p -r /lib /home/user/lib
RUN cp -p -r /lib64 /home/user/lib64
RUN mkdir /home/user/usr
RUN cp -p -r /usr/bin /home/user/usr/bin 
RUN cp -p -r /usr/lib /home/user/usr/lib
RUN cp -p -r /usr/lib64 /home/user/usr/lib64
RUN chown -R root:root /home/user
RUN chmod 755 /home/user
RUN mkdir /home/user/.ssh
RUN echo > /home/user/.ssh/authorized_keys
RUN chown -R user:user /home/user/.ssh
RUN chmod 700 /home/user/.ssh


#sshdの設定
RUN printf "Match User user\n\tChrootDirectory /home/user\n\tAllowTcpForwarding yes\n\tX11Forwarding no\n\tGatewayPorts yes" >> /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

#sshの有効化
RUN systemctl enable ssh
