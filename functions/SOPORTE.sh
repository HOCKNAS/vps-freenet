#!/bin/bash
#apache/ver
[[ ! -d /usr/local/lib ]] && mkdir /usr/local/lib
[[ ! -d /usr/local/lib/ubuntn ]] && mkdir /usr/local/lib/ubuntn
[[ ! -d /usr/local/lib/ubuntn/apache ]] && mkdir /usr/local/lib/ubuntn/apache
[[ ! -d /usr/local/lib/ubuntn/apache/ver ]] && mkdir /usr/local/lib/ubuntn/apache/ver
#lognull
[[ ! -d /usr/share ]] && mkdir /usr/share
[[ ! -d /usr/share/mediaptre ]] && mkdir /usr/share/mediaptre
[[ ! -d /usr/share/mediaptre/local ]] && mkdir /usr/share/mediaptre/local
[[ ! -d /usr/share/mediaptre/local/log ]] && mkdir /usr/share/mediaptre/local/log
[[ ! -d /usr/share/mediaptre/local/log/lognull ]] && mkdir /usr/share/mediaptre/local/log/lognull
#carpetas extras
[[ ! -d /etc/vps-freenet/vps-user ]] && mkdir /etc/vps-freenet/vps-user
[[ ! -d /usr/local/megat ]] && mkdir /usr/local/megat
#
[[ ! -d /usr/local/lib/rm ]] && mkdir /usr/local/lib/rm
[[ ! -d /usr/local/include ]] && mkdir /usr/local/include
[[ ! -d /usr/local/include/snaps ]] && mkdir /usr/local/include/snaps
[[ ! -d /usr/local/lib/sped ]] && mkdir /usr/local/lib/sped
[[ ! -d /usr/local/lib/sped/tools ]] && mkdir /usr/local/lib/sped/tools
[[ ! -d /usr/local/libreria ]] && mkdir /usr/local/libreria
#sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitTunnel no/PermitTunnel yes/g' /etc/ssh/sshd_config
service ssh restart &>/dev/null
wget -O /etc/vps-freenet/controlador/usercodes 'https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/usercodes.sh' --no-check-certificate
chmod 777 /etc/vps-freenet/controlador/usercodes
#Fix V2RAY
[[ ! -d /etc/vps-freenet/v2ray ]] && mkdir /etc/vps-freenet/v2ray
[[ ! -d /etc/vps-freenet/Slow ]] && mkdir /etc/vps-freenet/Slow
[[ ! -d /etc/vps-freenet/Slow/install ]] && mkdir /etc/vps-freenet/Slow/install
[[ ! -d /etc/vps-freenet/Slow/Key ]] && mkdir /etc/vps-freenet/Slow/Key
echo -e "\033[0;92m FICHEROS AGREGADOS"