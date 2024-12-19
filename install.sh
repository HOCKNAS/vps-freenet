clear

CTRL_C(){
  rm -rf install.sh
  exit
}

if [ "$(whoami)" != 'root' ]; then
  echo -e "\e[1;31mPARA PODER USAR EL INSTALADOR ES NECESARIO SER ROOT\nAUN NO SABES COMO INICAR COMO ROOT?\nDIJITA ESTE COMANDO EN TU TERMINAL ( sudo -i )\e[0m"
  rm *
  exit
fi

trap "CTRL_C" INT TERM EXIT

time_reboot(){
  REBOOT_TIMEOUT="$1"
  echo -e "     \e[1;97m\e[1;100mREINICIANDO VPS EN$1 SEGUNDOS\e[0m"
  while [ $REBOOT_TIMEOUT -gt 0 ]; do
    msg -ne "       -$REBOOT_TIMEOUT-\r"
    sleep 2
    : $((REBOOT_TIMEOUT--))
  done
  sudo reboot
}

v1=$(curl -sSL "https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/release") # 11X
echo "$v1" > /etc/script_version

msg (){
  v22=$(cat /etc/script_version)
  vesaoSCT="\033[1;37mVersion \033[1;32m$v22\033[1;31m]"
  BRAN='\033[1;37m' && ROJO='\e[91m' && VERMELHO='\e[91m' && VERDE='\e[92m' && AMARELO='\e[93m'
  AZUL='\e[94m' && MAGENTA='\e[95m' && MAG='\033[1;96m' && NEGRITO='\e[1m' && SEMCOR='\e[0m'

  case $1 in
    -ne)cor="${VERMELHO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nazu) cor="${ROJO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nverd)cor="${VERDE}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nama) cor="${AMARELO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -ama)cor="${AMARELO}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -verm)cor="${AMARELO}${NEGRITO}${VERMELHO}" && echo -e "${cor}${2}${SEMCOR}";;
    -azu)cor="${MAG}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -verd)cor="${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -bra)cor="${BRAN}" && echo -ne "${cor}${2}${SEMCOR}";;
    -tit)
      echo -e "\e[91m≪━━─━━─━─━─━─━─━━─━━─━─━─◈─━━─━─━─━─━━─━─━━─━─━━─━≫ \e[0m"
      echo -e "  \e[2;97m\e[3;93m❯❯❯❯❯❯ ꜱᴄʀɪᴩᴛ ᴍᴏᴅ ʟᴀᴄᴀꜱɪᴛᴀᴍx ❮❮❮❮❮❮\033[0m \033[1;31m[\033[1;32m$vesaoSCT"
      echo -e "\e[91m≪━━─━─━━━─━─━─━─━─━━─━─━─◈─━─━─━─━─━━━─━─━─━━━─━─━≫   \e[0m"
      echo -e "${SEMCOR}${cor}${SEMCOR}"
    ;;
    "-bar2"|"-bar")
      cor="${VERMELHO}————————————————————————————————————————————————————"
      echo -e "${SEMCOR}${cor}${SEMCOR}"
    ;;
  esac
}

fun_ip (){
  MIP2=$(wget -qO- ipv4.icanhazip.com)
  MIP=$(wget -qO- whatismyip.akamai.com)
  if [ $? -eq 0 ]; then
    IP="$MIP"
  else
    IP="$MIP2"
  fi
  echo "$IP" >/bin/IPca
}

os_system(){
  #code by rufu99
  SYSTEM_OS=$(cat -n /etc/issue |grep 1 |cut -d ' ' -f6,7,8 |sed 's/1//'|sed 's/      //')
  DISTRO_OS=$(echo "$SYSTEM_OS"|awk '{print $1}')

  case $DISTRO_OS in
    Debian)RELEASE_OS=$(echo $SYSTEM_OS|awk '{print $3}'|cut -d '.' -f1);;
    Ubuntu)RELEASE_OS=$(echo $SYSTEM_OS|awk '{print $2}'|cut -d '.' -f1,2);;
  esac

  link="https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/repositories_list/${RELEASE_OS}.list"
  case $RELEASE_OS in
    8|9|10|11|16.04|18.04|20.04|20.10|21.04|21.10|22.04)
      wget -O /etc/apt/sources.list ${link} &>/dev/null
    ;;
  esac
}

repo_install(){
  link="https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/repositories_list/$VERSION_ID.list"
  case $VERSION_ID in
    8*|9*|10*|11*|16.04*|18.04*|20.04*|20.10*|21.04*|21.10*|22.04*)
      [[ ! -e /etc/apt/sources.list.back ]] && cp /etc/apt/sources.list /etc/apt/sources.list.back
      wget -O /etc/apt/sources.list ${link} &>/dev/null
    ;;
  esac
}

stop_install(){
  msg -verm "     INSTALACION CANCELADA"
  exit
}

function printTitle {
    echo ""
    echo -e "\033[1;92m$1\033[1;91m"
    printf '%0.s-' $(seq 1 ${#1})
    echo ""
}

del(){
  for (( i = 0; i < $1; i++ )); do
    tput cuu1 && tput dl1
  done
}

rootvps(){
  msg -tit
  echo -e "\033[31m     OPTENIENDO ACCESO ROOT    "
  wget https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/bin/root &>/dev/null -O /usr/bin/rootlx &>/dev/null
  chmod 775 /usr/bin/rootlx &>/dev/null
  rootlx
  clear
  echo -e "\033[31m     ACCESO ROOT CON ÉXITO    "
  sleep 1
  rm -rf /usr/bin/rootlx
}

msg -bar
echo -e "\033[1;93m  YA TIENES ACCESO ROOT A TU VPS?\n  ESTO SOLO FUNCIONA PARA (AWS,GOOGLECLOUD,AZURE,ETC)\n  SI YA TIENES ACCESO A ROOT SOLO IGNORA ESTE MENSAJE\n  Y SIGUE CON LA INSTALACION NORMAL..."
msg -bar
read -p "Responde [ s | n ]: " -e -i n rootvps
[[ "$rootvps" = "s" || "$rootvps" = "S" ]] && rootvps
msg -bar

echo "\e[1;92m╭╮\e[93m╱╱╱\e[93m╭━━━╮\e[94m╭━━━╮\e[95m╭━━━╮\e[96m╭━━━╮\e[97m╭━━╮\e[93m╭━━━━╮\e[92m╭━━━╮\e[91m╭━╮╭━╮\e[93m╭━╮╭━╮\e[0m
\e[92m┃┃\e[93m╱╱╱\e[93m┃╭━╮┃\e[94m┃╭━╮┃\e[95m┃╭━╮┃\e[96m┃╭━╮┃\e[97m╰┫┣╯\e[93m┃╭╮╭╮┃\e[92m┃╭━╮┃\e[91m┃┃╰╯┃┃\e[93m╰╮╰╯╭╯\e[95m
┃┃\e[93m╱╱╱\e[94m┃┃\e[91m╱\e[96m┃┃┃┃\e[91m╱\e[97m╰╯┃┃\e[91m╱\e[93m┃┃┃╰━━╮\e[91m╱\e[94m┃┃\e[91m╱\e[93m╰╯┃\e[94 ┃╰╯┃┃\e[91m╱\e[97m┃┃\e[93m┃╭╮╭╮┃\e[91m╱\e[94m╰╮╭╯\e[91m╱\e[0m
\e[92m┃\e[93m┃\e[91m╱\e[93m╭╮┃\e[94m╰━╯┃\e[95m┃┃\e[91m╱\e[97m╭╮┃╰━╯┃\e[93m╰━━╮┃\e[91m╱\e[93m┃\e[91m┃\e[93m╱╱╱\e[96m┃┃\e[93m╱╱\e[913m┃╰━╯┃┃┃┃┃┃┃\e[91m╱\e[93m╭╯╰╮\e[91m╱\e[0m
\e[93m┃╰━╯┃\e[94m┃╭━╮┃\e[91m┃╰━╯┃\e[97m┃╭━╮┃\e[95m┃╰━╯┃\e[97m╭┫┣╮\e[93m╱╱\e[94m┃┃\e[93m╱╱\e[94m┃╭━╮┃\e[97m┃┃\e[94m┃┃\e[93m┃┃\e[97m╭╯╭╮╰╮\e[0m
\e[94m╰━━━╯\e[93m╰╯\e[91m╱╰╯\e[93m╰━━━╯\e[97m╰╯\e[91m╱\e[95m╰╯╰━━━╯\e[94m╰━━╯\e[93m╱╱\e[94m╰╯\e[93m╱╱\e[94m╰╯\e[91m╱\e[91m╰╯\e[93m╰╯\e[94m╰╯\e[95m╰╯\e[97m╰━╯\e[93m╰━╯\e[0m" >/bin/last12
clear

dependencias(){
  msg -tit
  msg -ama "               PREPARANDO INSTALACION"
  msg -bar2

  clear
  printTitle "Limpieza de caché local"
  apt-get clean
  clear
  printTitle "Actualizando paquetes"
  dpkg --configure -a &>/dev/null
  apt -f install -y >/dev/null 2>&1
  apt install sudo -y &>/dev/null
  clear
  os_system

  msg -tit
  echo "$DISTRO_OS $RELEASE_OS" >/tmp/distro
  echo -e "\e[1;31m       🖥SISTEMA: \e[33m$DISTRO_OS $RELEASE_OS   "
  echo -e "\e[1;31m       🖥IP: \e[33m$IP   "

  echo -e "  \033[41m    -- INSTALACION DE PAQUETES  --    \e[49m"
  msg -bar

  soft="sudo bsdmainutils zip unzip ufw curl python python3 python3-pip openssl screen cron iptables lsof nano at mlocate gawk figlet grep bc jq curl socat netcat net-tools cowsay lolcat figlet toilet pv perl apache2"

  for install in $soft; do
    leng="${#install}"
    puntos=$(( 21 - $leng))
    pts="."
    for (( a = 0; a < $puntos; a++ )); do
      pts+="."
    done
    msg -nazu "   INSTALANDO $install $(msg -ama "$pts")"
    if [[ $(dpkg --get-selections|grep -w "${install}"|head -1) ]] || sudo apt-get install ${install} -y &>/dev/null; then
      msg -verd " INSTALADO"
    else
      msg -verm2 " FALLA"
      sleep 2
      del 1
      if [[ $install = "python" ]]; then
        pts=$(echo ${pts:1})
        msg -nazu "   INSTALANDO python2 $(msg -ama "$pts")"
        if apt-get install python2 -y &>/dev/null ; then
          [[ ! -e /usr/bin/python ]] && ln -s /usr/bin/python2 /usr/bin/python
          msg -verd " INSTALADO"
        else
          msg -verm2 " FALLA"
        fi
        continue
      fi
      msg -ama " aplicando fix a $install"
      dpkg --configure -a &>/dev/null
      sleep 2
      del 1
      msg -nazu "   INSTALANDO $install $(msg -ama "$pts")"
      if sudo apt install $install -y &>/dev/null ; then
        msg -verd " INSTALADO"
      else
        msg -verm2 " FALLA"
      fi
    fi
  done
  sudo apt-get install apache2 -y &>/dev/null
  sudo apt install lolcat -y &>/dev/null
  sudo snap install lolcat -y &>/dev/null
  sudo apt install figlet -y &>/dev/null
  sudo snap install figlet -y &>/dev/null
  sudo apt install toilet -y &>/dev/null
  [[ $(dpkg --get-selections|grep -w "apache2"|head -1) ]] || apt-get install apache2 -y &>/dev/null
  sed -i "s;Listen 80;Listen 81;g" /etc/apache2/ports.conf > /dev/null 2>&1
  service apache2 restart > /dev/null 2>&1
  clear
}

install_start(){
  clear
  os_system
  msg -bar
  echo -e "\e[1;31m       🖥SISTEMA: \e[33m$DISTRO_OS $RELEASE_OS   "
  msg -bar
  repo_install
  apt update -y; apt upgrade -y
  [[ "$VERSION_ID" = '9' ]] && source <(curl -sL https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/nodejs/setup_10.x)
}

install_continue(){
  dependencias
  apt autoremove -y &>/dev/null
  [[ "$VERSION_ID" = '9' ]] && apt remove unscd -y &>/dev/null
}

clear
cd $HOME
rm $(pwd)/$0 &> /dev/null

SCPdir="/etc/vps-freenet"
SCPinstal="$HOME/install"
SCPidioma="${SCPdir}/idioma"
SCPusr="${SCPdir}/controlador"
SCPfrm="${SCPdir}/herramientas"
SCPinst="${SCPdir}/protocolos"

rm -rf /etc/localtime &>/dev/null
ln -s /usr/share/zoneinfo/America/Chihuahua /etc/localtime &>/dev/null
rm -rf /usr/local/lib/systemubu1 &> /dev/null

#COLORES Y BARRA
clear

fun_ipe () {
  MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'| grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|head -1)
  MIP2=$(wget -qO- ipv4.icanhazip.com)
  [[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
  echo "$IP" >/bin/IPca
}

function_verify () {
  [[ $(dpkg --get-selections|grep -w "curl"|head -1) ]] || apt-get install curl -y &>/dev/null
  permited=$(curl -sSL "https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/commons/control.txt")
  [[ $(echo $permited|grep "${IP}") = "" ]] && {
    clear
    msg -tit
    echo -e "\n\n\n\033[1;91m————————————————————————————————————————————————————\n      ¡ESTA KEY NO CONCUERDA CON EL INSTALADOR! \n      BOT: @vps_freenet_BOT \n————————————————————————————————————————————————————\n\n\n"
    [[ -d /etc/vps-freenet ]] && rm -rf /etc/vps-freenet
    exit 1
  } || {
    #INTALAR VERSION DE SCRIPT
    v1=$(curl -sSL "https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/release")
    echo "$v1" > /etc/script_version
  }
}

idioma () {
  clear
  clear
  msg -bar2
  echo -e "$(cat /bin/last12)"
  pv="$(echo es)"
  [[ ${#id} -gt 2 ]] && id="es" || id="$pv"
  byinst="true"
}

install_fim () {
  msg -ama "               Finalizando Instalacion" && msg -bar2
  #rm -rf /etc/vps-freenet/controlador/nombre.log &>/dev/null
  [[ $(find /etc/vps-freenet/controlador -name nombre.log|grep -w "nombre.log"|head -1) ]] || wget -O /etc/vps-freenet/controlador/nombre.log https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/commons/controlador/nombre.log &>/dev/null
  [[ $(find /etc/vps-freenet/controlador -name IDT.log|grep -w "IDT.log"|head -1) ]] || wget -O /etc/vps-freenet/controlador/IDT.log https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/commons/controlador/IDT.log &>/dev/null
  [[ $(find /etc/vps-freenet/controlador -name tiemlim.log|grep -w "tiemlim.log"|head -1) ]] || wget -O /etc/vps-freenet/controlador/tiemlim.log https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/commons/controlador/tiemlim.log &>/dev/null
  touch /usr/share/lognull &>/dev/null

  wget https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/SPR.sh &>/dev/null -O /usr/bin/SPR &>/dev/null
  chmod 775 /usr/bin/SPR &>/dev/null
 
  [[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]] && echo "nameserver   8.8.8.8" >> /etc/resolv.conf
  [[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]] && echo "nameserver   1.1.1.1" >> /etc/resolv.conf

  wget -O /usr/bin/SOPORTE https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/SOPORTE.sh &>/dev/null
  chmod 775 /usr/bin/SOPORTE &>/dev/null
  SOPORTE &>/dev/null
  echo "ACCESO ACTIVADO" >/usr/bin/SOPORTE

  wget -O /bin/rebootnb https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/rebootnb.sh &> /dev/null
  chmod +x /bin/rebootnb
  wget -O /bin/resetsshdrop https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/resetsshdrop.sh &> /dev/null
  chmod +x /bin/resetsshdrop

  wget -O /etc/script_version_new https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/release &>/dev/null
  wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/bin/ssh/sshd &>/dev/null
  chmod 777 /etc/ssh/sshd_config

  msg -bar2
  echo '#!/bin/sh -e' > /etc/rc.local
  sudo chmod +x /etc/rc.local
  echo "sudo rebootnb" >> /etc/rc.local
  echo "sudo resetsshdrop" >> /etc/rc.local
  echo "sleep 2s" >> /etc/rc.local
  echo "exit 0" >> /etc/rc.local
  /bin/cp /etc/skel/.bashrc ~/

  echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' >> /etc/profile
  echo 'clear' >> .bashrc
  echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' >> .bashrc
  echo 'echo ""' >> .bashrc
  echo 'fecha=$(date +"%d-%b-%y")'>> .bashrc
  echo 'hora=$(date +"%T")'>> .bashrc
  echo 'mn=$(cat /bin/last12)'>>.bashrc
  echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m" '>> .bashrc
  echo 'echo -e "${mn}"' >>.bashrc
  echo 'mess1="$(less /etc/vps-freenet/message.txt)" ' >> .bashrc
  echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m" '>> .bashrc
  echo 'echo -e "\t\033[1;91mRESELLER :\e[92m $mess1 "'>> .bashrc
  echo 'echo -e "\t\e[1;33mVERSION: \e[1;31m$(cat /etc/script_version_new)"'>> .bashrc
  echo 'echo -e "\e[1;97m  HORA: \e[1;91m$hora    \e[1;97mFECHA: \e[1;91m${fecha}\e[0m"'>> .bashrc
  echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m" '>> .bashrc
  echo 'echo -e "\t\033[1;100mPARA PODER ENTRAR AL MENÚ ESCRIBA:\e[0m\e[1;41m menu \e[0m"'>> .bashrc
  echo 'echo ""'>> .bashrc

  echo -e "         COMANDO PRINCIPAL PARA ENTRAR AL SCRIPT "
  echo -e "  \033[1;41m               sudo menu             \033[0;37m" && msg -bar2

  rm -rf /usr/bin/pytransform &> /dev/null
  rm -rf install.sh
  rm -rf lista-arq

  service ssh restart &>/dev/null
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/
  time_reboot "10"
}

ofus () {
  unset server
  server=$(echo ${txt_ofuscatw}|cut -d':' -f1)
  unset txtofus
  number=$(expr length $1)
  for((i=1; i<$number+1; i++)); do
    txt[$i]=$(echo "$1" | cut -b $i)
    case ${txt[$i]} in
      ".")txt[$i]="C";;
      "C")txt[$i]=".";;
      "3")txt[$i]="@";;
      "@")txt[$i]="3";;
      "5")txt[$i]="9";;
      "9")txt[$i]="5";;
      "6")txt[$i]="D";;
      "D")txt[$i]="6";;
      "J")txt[$i]="Z";;
      "Z")txt[$i]="J";;
    esac
    txtofus+="${txt[$i]}"
  done
  echo "$txtofus" | rev
}

verificar_arq () {
  [[ ! -d ${SCPdir} ]] && mkdir ${SCPdir}
  [[ ! -d ${SCPusr} ]] && mkdir ${SCPusr}
  [[ ! -d ${SCPfrm} ]] && mkdir ${SCPfrm}
  [[ ! -d ${SCPinst} ]] && mkdir ${SCPinst}
  [[ ! -d ${SCPdir}/tmp ]] && mkdir ${SCPdir}/tmp
  [[ ! -d ${SCPdir}/passw ]] && mkdir ${SCPdir}/passw

  case $1 in
    "menu"|"message.txt"|"ID")ARQ="${SCPdir}/";; #Menu
    "usercodes")ARQ="${SCPusr}/";; #Panel SSRR
    "C-SSR.sh"|"UDPcustom.sh")ARQ="${SCPinst}/";; #Panel SSR
    "openssh.sh")ARQ="${SCPinst}/";; #OpenVPN
    "squid.sh")ARQ="${SCPinst}/";; #Squid
    "dropbear.sh"|"proxy.sh"|"wireguard.sh")ARQ="${SCPinst}/";; #Instalacion
    "proxy.sh")ARQ="${SCPinst}/";; #Instalacion
    "openvpn.sh")ARQ="${SCPinst}/";; #Instalacion
    "ssl.sh"|"python.py")ARQ="${SCPinst}/";; #Instalacion
    "shadowsocks.sh")ARQ="${SCPinst}/";; #Instalacion
    "Shadowsocks-libev.sh")ARQ="${SCPinst}/";; #Instalacion
    "Shadowsocks-R.sh")ARQ="${SCPinst}/";; #Instalacion
    "v2ray.sh"|"slowdns.sh")ARQ="${SCPinst}/";; #Instalacion
    "budp.sh")ARQ="${SCPinst}/";; #Instalacion
    "name"|"adminkey")ARQ="${SCPdir}/tmp/";; #Instalacion
    "sockspy.sh"|"PDirect.py"|"PPub.py"|"PPriv.py"|"POpen.py"|"PGet.py")ARQ="${SCPinst}/";; #Instalacion
    *)ARQ="${SCPfrm}/";; #Herramientas
  esac

  mv -f ${SCPinstal}/$1 ${ARQ}/$1
  chmod +x ${ARQ}/$1
}

fun_ipe
source /etc/os-release; export PRETTY_NAME

install_start
install_continue

wget -O /usr/bin/trans https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/trans.sh &> /dev/null
wget -O /bin/Desbloqueo.sh https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/desbloqueo.sh &> /dev/null
chmod +x /bin/Desbloqueo.sh
wget -O /bin/monitor.sh https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/monitor/monitor.sh &> /dev/null
chmod +x /bin/monitor.sh
wget -O /var/www/html/estilos.css https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/monitor/estilos.css &> /dev/null
[[ -f "/usr/sbin/ufw" ]] && ufw allow 443/tcp &>/dev/null; ufw allow 80/tcp &>/dev/null; ufw allow 3128/tcp &>/dev/null; ufw allow 8799/tcp &>/dev/null; ufw allow 8080/tcp &>/dev/null; ufw allow 81/tcp &>/dev/null

[[ $1 = "" ]] && idioma || {
  [[ ${#1} -gt 2 ]] && idioma || id="$1"
}

error_fun () {
  echo ""
  [[ $1 = "" ]] && idioma || {
    [[ ${#1} -gt 2 ]] && idioma || id="$1"
  }
  echo "¡KEY invalido!" >/etc/keyno
  msg -bar2 && msg -verm "ERROR DE GENERADOR | ARCHIVOS INCOMPLETOS\n     KEY USADA" && msg -bar2
  echo -ne "\033[1;97m DESEAS INTENTAR CON OTRA KEY  \033[1;31m[\033[1;93m S \033[1;31m|\033[1;93m N \033[1;31m]\033[1;97m: \033[1;93m" && read ingresar_key
  service apache2 restart >/dev/null 2>&1
  [[ "$ingresar_key" = "s" || "$ingresar_key" = "S" ]] && ingresar_key
  clear && clear
  msg -bar
  echo -e "\033[1;97m          == INSTALACION CANCELADA =="
  msg -bar
  rm -rf lista-arq
  exit 1
}

invalid_key () {
  echo ""
  [[ $1 = "" ]] && idioma || {
    [[ ${#1} -gt 2 ]] && idioma || id="$1"
  }
  echo "¡KEY invalido!" >/etc/keyno
  msg -bar2 && msg -verm "  Code Invalido -- #¡Key Invalida#! " && msg -bar2
  echo -ne "\033[1;97m DESEAS INTENTAR CON OTRA KEY  \033[1;31m[\033[1;93m S \033[1;31m|\033[1;93m N \033[1;31m]\033[1;97m: \033[1;93m" && read ingresar_key
  service apache2 restart >/dev/null 2>&1
  [[ "$ingresar_key" = "s" || "$ingresar_key" = "S" ]] && ingresar_key
  clear && clear
  msg -bar
  echo -e "\033[1;97m          == INSTALACION CANCELADA =="
  msg -bar
  exit 1
}

ingresar_key(){
  /bin/cp /etc/skel/.bashrc ~/
  service apache2 restart >/dev/null 2>&1
  [[ -d /etc/keyno ]] && rm -rf /etc/keyno &>/dev/null
  echo "by @vps-freenet 2024" >/etc/keyno
  unset Key
  while [[ ! $Key ]]; do
    msg -bar2 && msg -ne "\033[1;93m          >>> INGRESE SU KEY ABAJO <<<\n   \033[1;37m" && read Key
    [[ -z "$Key" ]] && Key="NoExiste"
    tput cuu1 && tput dl1
  done
  msg -ne "    # Verificando Key # : "
  cd $HOME
  IPT=$(cat /bin/IPca)
  # wget -O $HOME/lista-arq $(ofus "$Key")/$IPT &>/dev/null && echo -e "\033[1;32m Ofus Correcto" || {
  #   echo -e "\033[1;91m ¡Ofus Incorrecto!"
  #   #invalid_key
  # }
  sleep 5 && echo -e "\033[1;32m Ofus Correcto"
  IP=$(ofus "$Key" | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}') && echo "$IP" > /usr/bin/venip
  sleep 1s
  #function_verify
  updatedb &>/dev/null
  echo -e "wireguard.sh\nadminkey\nname\nID\nslowdns.sh\nADMbot.sh\nC-SSR.sh\nPDirect.py\nPGet.py\nPOpen.py\nPPriv.py\nPPub.py\nfai2ban.sh\nmenu\nmessage.txt\nopenvpn.sh\nports.sh\nspeed.py\nsquid.sh\nsquidpass.sh\npython.py" > "lista-arq"
  if [[ -e $HOME/lista-arq ]] && [[ ! $(cat /etc/keyno|grep "¡KEY invalido!") ]]; then
    msg -bar2
    msg -verd "    Archivos Copiados: \e[97m[\e[91mby @vps_freenet_bot\e[97m]"
    REQUEST=$(ofus "$Key"|cut -d'/' -f2)
    [[ ! -d ${SCPinstal} ]] && mkdir ${SCPinstal}
    pontos="¡"
    stopping="Descargando Archivos"
    [ -d /etc/vps-freenet ] && rm -rf /etc/vps-freenet && cp -r ./raw_install /etc/vps-freenet
    for arqx in $(cat $HOME/lista-arq); do
      msg -verm "${stopping}${pontos}"
      # echo ${IP}:81/${REQUEST}/${arqx}
      sleep $(shuf -i 1-3 -n 1)
      # wget --no-check-certificate -O ${SCPinstal}/${arqx} ${IP}:81/${REQUEST}/${arqx} &>/dev/null && verificar_arq "${arqx}" || {
      #   error_fun
      # }
      tput cuu1 && tput dl1
      pontos+="¡"
    done

    wget -qO- ipv4.icanhazip.com >/etc/vps-freenet/IP.log
    userid="${SCPdir}/ID"
    TOKEN="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
    URL="https://api.telegram.org/bot$TOKEN/sendMessage"

    while read user; do
      if [[ $(cat ${userid}|grep "1247997000") = "" ]]; then
        MSG="👇❮= 𝙉𝙊𝙏𝙄-𝙆𝙀𝙔 =❯👇   
 ◄══════◄••◩••►══════►
 Version: $(cat /etc/script_version) INSTALADO✓
 ◄══════◄••◩••►══════►
 AdminBot: $(cat ${SCPdir}/tmp/adminkey)
 Cliente: $(cat ${SCPdir}/tmp/name)
 🆔: $user
 SLOGAN: $(cat ${SCPdir}/message.txt)
 ◄══════◄••◩••►══════►
 IP: $(cat ${SCPdir}/IP.log)
 SYSTEMA: $(cat /tmp/distro)
 ◄══════◄••◩••►══════►
 KEY: $Key 👈 Usada
 ◄══════◄••◩••►══════►
 By @vps-freenet
 ◄══════◄••◩••►══════►
 Porque de tal manera amó Dios al mundo,
que ha dado a su Hijo unigénito,
para que todo aquel que en él cree, 
no se pierda, mas tenga vida eterna.(juan 3;16)
◄══════◄••◩••►══════►
 Por tanto, no te avergüences de dar testimonio 
de nuestro Señor, ni de mí, preso suyo,
sino participa de las aflicciones por el evangelio 
según el poder de Dios,(2 timoteo 1;8)

»Todo aquel que me reconozca en público
 aquí en la tierra también lo reconoceré 
delante de mi Padre en el cielo;
»pero al que me niegue aquí en la tierra 
también yo lo negaré delante 
de mi Padre en el cielo.(Mateo 10:32-33)
(𝐉𝐄𝐒𝐔𝐂𝐑𝐈𝐒𝐓𝐎 𝐓𝐄 𝐀𝐌𝐀)
"
        curl -s --max-time 10 -d "chat_id=${user}&disable_web_page_preview=1&text=$MSG" $URL &>/dev/null
        curl -s --max-time 10 -d "chat_id=1247997082&disable_web_page_preview=1&text=$MSG" $URL &>/dev/null
      else
        MSG="👇❮= 𝙉𝙊𝙏𝙄-𝙆𝙀𝙔 =❯👇   
 ◄══════◄••◩••►══════►
 Version: $(cat /etc/script_version) INSTALADO✓
 ◄══════◄••◩••►══════►
 AdminBot: $(cat ${SCPdir}/tmp/adminkey)
 Cliente: $(cat ${SCPdir}/tmp/name)
 🆔: $user
 SLOGAN: $(cat ${SCPdir}/message.txt)
 ◄══════◄••◩••►══════►
 IP: $(cat ${SCPdir}/IP.log)
 SYSTEMA: $(cat /tmp/distro)
 ◄══════◄••◩••►══════►
 KEY: $Key 👈 Usada
 ◄══════◄••◩••►══════►
 By @vps-freenet
 ◄══════◄••◩••►══════►
 "
        curl -s --max-time 10 -d "chat_id=${user}&disable_web_page_preview=1&text=$MSG" $URL &>/dev/null
      fi
    done <<< "$(cat ${userid}|cut -d' ' -f1)"

    rm ${SCPdir}/IP.log &>/dev/null
    rm /tmp/distro &>/dev/null
    [[ ! -d ${SCPdir}/tmp ]] && mkdir ${SCPdir}/tmp

    wget -O ${SCPdir}/tmp/verifi https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/key/verifi.sh &>/dev/null
    wget -O ${SCPdir}/tmp/monitor https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/key/monitor.sh &>/dev/null
    wget -O ${SCPdir}/tmp/autodes https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/key/autodes.sh &>/dev/null
    wget -O ${SCPdir}/tmp/style https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/key/style.txt &>/dev/null
    chmod 777 ${SCPdir}/tmp/*

    wget -O /etc/vps-freenet/protocolos/chekuser.sh https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/check/user.sh &>/dev/null
    chmod 777 /etc/vps-freenet/protocolos/chekuser.sh
    wget -O /etc/vps-freenet/protocolos/chekuser.py https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/check/user.py &>/dev/null
    chmod 777 /etc/vps-freenet/protocolos/chekuser.py

    msg -bar2
    [[ -e $HOME/lista-arq ]] && rm -rf $HOME/lista-arq
    cat /etc/bash.bashrc|grep -v '[[ $UID != 0 ]] && TMOUT=15 && export TMOUT' > /etc/bash.bashrc.2
    echo -e '[[ $UID != 0 ]] && TMOUT=15 && export TMOUT' >> /etc/bash.bashrc.2
    mv -f /etc/bash.bashrc.2 /etc/bash.bashrc

    rm -rf /usr/bin/menu
    rm -rf /usr/bin/freenet
    ln -s /etc/vps-freenet/menu /usr/bin/menu
    ln -s /etc/vps-freenet/menu /usr/bin/freenet
    #update-locale LANG=en_US.UTF-8 LANGUAGE=en
    echo "$Key" > ${SCPdir}/key.txt
    [[ -d ${SCPinstal} ]] && rm -rf ${SCPinstal}
    [[ ${#id} -gt 2 ]] && echo "es" > ${SCPidioma} || echo "${id}" > ${SCPidioma}
    msg -bar2
    [[ ${byinst} = "true" ]] && install_fim
  # else
  #   invalid_key
  fi
}

ingresar_key
