#!/bin/bash
#------<<Script-Free v8.4g>>
clear
clear
SPR &
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1 >/dev/null 2>&1
_hora=$(printf '%(%D-%H:%M:%S)T')
#COLORES
red=$(tput setaf 1)
gren=$(tput setaf 2)
yellow=$(tput setaf 3)
SCPdir="/etc/vps-freenet" && [[ ! -d ${SCPdir} ]] && exit 1
SCPusr="${SCPdir}/controlador"
SCPfrm="${SCPdir}/herramientas"
SCPinst="${SCPdir}/protocolos"
SCPidioma="${SCPdir}/idioma"
#PROCESSADOR
_core=$(printf '%-1s' "$(grep -c cpu[0-9] /proc/stat)")
_usop=$(top -bn1 | sed -rn '3s/[^0-9]* ([0-9\.]+) .*/\1/p;4s/.*, ([0-9]+) .*/\1/p' | tr '\n' ' ')

#SISTEMA-USO DA CPU-MEMORIA RAM
ram1=$(free -h | grep -i mem | awk {'print $2'})
ram2=$(free -h | grep -i mem | awk {'print $4'})
ram3=$(free -h | grep -i mem | awk {'print $3'})

_ram=$(printf ' %-9s' "$(free -h | grep -i mem | awk {'print $2'})")
_usor=$(printf '%-8s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")
dirapache="/usr/local/lib/ubuntn/apache/ver" && [[ ! -d ${dirapache} ]] && exit
if [[ -e /etc/bash.bashrc-bakup ]]; then
   AutoRun="\033[1;32m[ON]"
elif [[ -e /etc/bash.bashrc ]]; then
   AutoRun="\033[1;31m[OFF]"
fi
# Funcoes Globais
msg() {
   #ACTULIZADOR
   [[ ! -e /etc/script_version ]] && echo 1 >/etc/script_version
   v11=$(cat /etc/script_version_new)
   v22=$(cat /etc/script_version)
   [[ $v11 = $v22 ]] && vesaoSCT="\033[1;37mVersion\033[1;32m $v22  \033[1;31m]" || vesaoSCT="\033[1;31m($v22)\033[1;97m→\033[1;32m($v11)\033[1;31m  ]"
   local colors="/etc/vps-freenet/colors"
   if [[ ! -e $colors ]]; then
      COLOR[0]='\033[1;37m' #BRAN='\033[1;37m'
      COLOR[1]='\e[31m'     #VERMELHO='\e[31m'
      COLOR[2]='\e[32m'     #VERDE='\e[32m'
      COLOR[3]='\e[33m'     #AMARELO='\e[33m'
      COLOR[4]='\e[34m'     #AZUL='\e[34m'
      COLOR[5]='\e[91m'     #MAGENTA='\e[35m'
      COLOR[6]='\033[1;97m' #MAG='\033[1;36m'
   else
      local COL=0
      for number in $(cat $colors); do
         case $number in
         1) COLOR[$COL]='\033[1;37m' ;;
         2) COLOR[$COL]='\e[31m' ;;
         3) COLOR[$COL]='\e[32m' ;;
         4) COLOR[$COL]='\e[33m' ;;
         5) COLOR[$COL]='\e[34m' ;;
         6) COLOR[$COL]='\e[35m' ;;
         7) COLOR[$COL]='\033[1;36m' ;;
         esac
         let COL++
      done
   fi
   NEGRITO='\e[1m'
   SEMCOR='\e[0m'
   case $1 in
   -ne) cor="${COLOR[1]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}" ;;
   -ama) cor="${COLOR[3]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
   -verm) cor="${COLOR[3]}${NEGRITO}[!] ${COLOR[1]}" && echo -e "${cor}${2}${SEMCOR}" ;;
   -verm2) cor="${COLOR[1]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
   -azu) cor="${COLOR[6]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
   -verd) cor="${COLOR[2]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
   -bra) cor="${COLOR[0]}${SEMCOR}" && echo -e "${cor}${2}${SEMCOR}" ;;
   "-bar2" | "-bar") cor="${COLOR[1]}————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}" ;;
   -tit) echo -e "\e[97m \033[1;41m| #-#-► 🐲 SCRIPT ◄-#-# | \033[1;49m\033[1;49m \033[1;31m[ \033[1;32m $vesaoSCT " && echo -e "${SEMCOR}${cor}${SEMCOR}" ;;
   esac
}
canbio_color() {
   clear
   msg -bar2
   msg -tit
   msg -ama "     CONTROLADOR DE COLORES DEL SCRIP"
   msg -bar2
   msg -ama "$(fun_trans "Selecione 7 cores"): "
   echo -e '\033[1;37m [1] ###\033[0m'
   echo -e '\e[31m [2] ###\033[0m'
   echo -e '\e[32m [3] ###\033[0m'
   echo -e '\e[33m [4] ###\033[0m'
   echo -e '\e[34m [5] ###\033[0m'
   echo -e '\e[35m [6] ###\033[0m'
   echo -e '\033[1;36m [7] ###\033[0m'
   msg -bar2
   for number in $(echo {1..7}); do
      msg -ne "$(fun_trans "Digite un Color") [$number]: " && read corselect
      [[ $corselect != @([1-7]) ]] && corselect=1
      cores+="$corselect "
      corselect=0
   done
   echo "$cores" >/etc/vps-freenet/colors
   msg -bar2
}
fun_trans() {
   local texto
   local retorno
   declare -A texto
   SCPidioma="${SCPdir}/idioma"
   [[ ! -e ${SCPidioma} ]] && touch ${SCPidioma}
   local LINGUAGE=$(cat ${SCPidioma})
   [[ -z $LINGUAGE ]] && LINGUAGE=es
   [[ $LINGUAGE = "es" ]] && echo "$@" && return
   [[ ! -e /usr/bin/trans ]] && wget -O /usr/bin/trans https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/functions/trans.sh &>/dev/null
   [[ ! -e /etc/vps-freenet/texto-es ]] && touch /etc/vps-freenet/texto-es
   source /etc/vps-freenet/texto-es
   if [[ -z "$(echo ${texto[$@]})" ]]; then
      #ENGINES=(aspell google deepl bing spell hunspell apertium yandex)
      #NUM="$(($RANDOM%${#ENGINES[@]}))"
      retorno="$(source trans -e bing -b es:${LINGUAGE} "$@" | sed -e 's/[^a-z0-9 -]//ig' 2>/dev/null)"
      echo "texto[$@]='$retorno'" >>/etc/vps-freenet/texto-es
      echo "$retorno"
   else
      echo "${texto[$@]}"
   fi
}
function_verify() {

   v1=$(curl -sSL "https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/release")
   echo "$v1" >/etc/script_version
}
atualiza_fun() {
   
   clear && clear 
   echo -e "e\[1;97m       SEGURO DE ACTULIZAR VPS-MX"
   read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
   rm -rf install.sh
   apt update
   apt upgrade -y
   wget https://raw.githubusercontent.com/HOCKNAS/vps-freenet/master/commons/install.sh
   chmod 777 install.sh
   ./install.sh
   function_verify
   echo -e "${cor[2]}               ACTULIZACION COMPLETA "
   echo -e "         COMANDO PRINCIPAL PARA ENTRAR AL PANEL "
   echo -e "  \033[1;41m               sudo freenet o menu             \033[0;37m" && msg -bar2

   exit 1
}
funcao_idioma() {
   tput cuu1 && tput dl1
   msg -bar2
   declare -A idioma=([1]="en English" [2]="fr Franch" [3]="de German" [4]="it Italian" [5]="pl Polish" [6]="pt Portuguese" [7]="es Spanish" [8]="tr Turkish")
   for ((i = 1; i <= 12; i++)); do
      valor1="$(echo ${idioma[$i]} | cut -d' ' -f2)"
      [[ -z $valor1 ]] && break
      valor1="\033[1;32m[$i] > \033[1;33m$valor1"
      while [[ ${#valor1} -lt 37 ]]; do
         valor1=$valor1" "
      done
      echo -ne "$valor1"
      let i++
      valor2="$(echo ${idioma[$i]} | cut -d' ' -f2)"
      [[ -z $valor2 ]] && {
         echo -e " "
         break
      }
      valor2="\033[1;32m[$i] > \033[1;33m$valor2"
      while [[ ${#valor2} -lt 37 ]]; do
         valor2=$valor2" "
      done
      echo -ne "$valor2"
      let i++
      valor3="$(echo ${idioma[$i]} | cut -d' ' -f2)"
      [[ -z $valor3 ]] && {
         echo -e " "
         break
      }
      valor3="\033[1;32m[$i] > \033[1;33m$valor3"
      while [[ ${#valor3} -lt 37 ]]; do
         valor3=$valor3" "
      done
      echo -e "$valor3"
   done
   msg -bar2
   unset selection
   while [[ ${selection} != @([1-8]) ]]; do
      echo -ne "\033[1;37m$(fun_trans "  ► Selecione una Opcion"): " && read selection
      tput cuu1 && tput dl1
   done
   [[ -e /etc/vps-freenet/texto-es ]] && rm /etc/vps-freenet/texto-es
   echo "$(echo ${idioma[$selection]} | cut -d' ' -f1)" >${SCPidioma}
}
mine_port() {
   clear
   clear
   msg -bar
   msg -tit
   echo -e "\033[1;93m      INFORMACION DEL SISTEMA Y PUERTOS ACTIVOS"
   msg -bar2
   echo -e "\033[1;31m PROCESADOR: \033[1;37mNUCLEOS: \033[1;32m$_core         \033[1;37mUSO DE CPU: \033[1;32m$_usop"
   echo -e "\033[1;31m LA MEMORIA RAM SE ENCUENTRA AL: \033[1;32m$_usor"
   echo -e "\033[1;31m DETALLE RAM: \033[1;37mTOTAL: \033[1;32m$ram1  \033[1;37mUSADO: \033[1;32m$ram3  \033[1;37mLIBRE: \033[1;32m$ram2"
   msg -ne " SO: " && echo -ne "\033[1;37m$(os_system)  "
   msg -ne " IP: " && echo -e "\033[1;37m$(meu_ip)"
   msg -bar2
   local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
   local NOREPEAT
   local reQ
   local Port
   while read port; do
      reQ=$(echo ${port} | awk '{print $1}')
      Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
      [[ $(echo -e $NOREPEAT | grep -w "$Port") ]] && continue
      NOREPEAT+="$Port\n"
      case ${reQ} in
      squid | squid3)
         [[ -z $SQD ]] && local SQD="\033[1;31m SQUID: \033[1;32m"
         SQD+="$Port "
         ;;
      apache | apache2)
         [[ -z $APC ]] && local APC="\033[1;31m APACHE: \033[1;32m"
         APC+="$Port "
         ;;
      ssh | sshd)
         [[ -z $SSH ]] && local SSH="\033[1;31m SSH: \033[1;32m"
         SSH+="$Port "
         ;;
      dropbear)
         [[ -z $DPB ]] && local DPB="\033[1;31m DROPBEAR: \033[1;32m"
         DPB+="$Port "
         ;;
      ssserver | ss-server)
         [[ -z $SSV ]] && local SSV="\033[1;31m SHADOWSOCKS: \033[1;32m"
         SSV+="$Port "
         ;;
      openvpn)
         [[ -z $OVPN ]] && local OVPN="\033[1;31m OPENVPN-TCP: \033[1;32m"
         OVPN+="$Port "
         ;;
      stunnel4 | stunnel)
         [[ -z $SSL ]] && local SSL="\033[1;31m SSL: \033[1;32m"
         SSL+="$Port "
         ;;
      python | python3)
         [[ -z $PY3 ]] && local PY3="\033[1;31m SOCKS/PYTHON: \033[1;32m"
         PY3+="$Port "
         ;;
      v2ray)
         [[ -z $V2R ]] && local V2R="\033[1;31m V2RAY: \033[1;32m"
         V2R+="$Port "
         ;;
      badvpn-ud)
         [[ -z $BAD ]] && local BAD="\033[1;31m BADVPN: \033[1;32m"
         BAD+="$Port "
         ;;
      esac
   done <<<"${portasVAR}"
   #UDP
   local portasVAR=$(lsof -V -i -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND")
   local NOREPEAT
   local reQ
   local Port
   while read port; do
      reQ=$(echo ${port} | awk '{print $1}')
      Port=$(echo ${port} | awk '{print $9}' | awk -F ":" '{print $2}')
      [[ $(echo -e $NOREPEAT | grep -w "$Port") ]] && continue
      NOREPEAT+="$Port\n"
      case ${reQ} in
      openvpn)
         [[ -z $OVPN ]] && local OVPN="\033[0;36m OPENVPN-UDP: \033[1;32m"
         OVPN+="$Port "
         ;;
      esac
   done <<<"${portasVAR}"
   [[ ! -z $SSH ]] && echo -e $SSH
   [[ ! -z $SSL ]] && echo -e $SSL
   [[ ! -z $DPB ]] && echo -e $DPB
   [[ ! -z $SQD ]] && echo -e $SQD
   [[ ! -z $PY3 ]] && echo -e $PY3
   [[ ! -z $SSV ]] && echo -e $SSV
   [[ ! -z $V2R ]] && echo -e $V2R
   [[ ! -z $APC ]] && echo -e $APC
   [[ ! -z $OVPN ]] && echo -e $OVPN
   [[ ! -z $BAD ]] && echo -e $BAD
   msg -bar2

}
ofus() {
   unset txtofus
   number=$(expr length $1)
   for ((i = 1; i < $number + 1; i++)); do
      txt[$i]=$(echo "$1" | cut -b $i)
      case ${txt[$i]} in
      ".") txt[$i]="v" ;;
      "v") txt[$i]="." ;;
      "1") txt[$i]="@" ;;
      "@") txt[$i]="1" ;;
      "2") txt[$i]="?" ;;
      "?") txt[$i]="2" ;;
      "4") txt[$i]="p" ;;
      "p") txt[$i]="4" ;;
      "-") txt[$i]="K" ;;
      "K") txt[$i]="-" ;;
      esac
      txtofus+="${txt[$i]}"
   done
   echo "$txtofus" | rev
}
limpar_caches() {
   (
      VE="\033[1;33m" && MA="\033[1;31m" && DE="\033[1;32m"
      while [[ ! -e /tmp/abc ]]; do
         A+="#"
         echo -e "${VE}[${MA}${A}${VE}]" >&2
         sleep 0.3s
         tput cuu1 && tput dl1
      done
      echo -e "${VE}[${MA}${A}${VE}] - ${DE}[100%]" >&2
      rm /tmp/abc
   ) &
   echo 3 >/proc/sys/vm/drop_caches &>/dev/null
   sleep 1s
   sysctl -w vm.drop_caches=3 &>/dev/null
   apt-get autoclean -y &>/dev/null
   sleep 1s
   apt-get clean -y &>/dev/null
   rm /tmp/* &>/dev/null
   touch /tmp/abc
   sleep 0.5s
   msg -bar
   msg -ama "$(fun_trans "PROCESO CONCLUIDO")"
   msg -bar
}
fun_autorun() {
   if [[ -e /etc/bash.bashrc-bakup ]]; then
      mv -f /etc/bash.bashrc-bakup /etc/bash.bashrc
      cat /etc/bash.bashrc | grep -v "/etc/vps-freenet/menu" >/tmp/bash
      mv -f /tmp/bash /etc/bash.bashrc
      msg -ama "$(fun_trans "REMOVIDO CON EXITO")"
      msg -bar
   elif [[ -e /etc/bash.bashrc ]]; then
      cat /etc/bash.bashrc | grep -v /bin/menu >/etc/bash.bashrc.2
      echo '/etc/vps-freenet/menu' >>/etc/bash.bashrc.2
      cp /etc/bash.bashrc /etc/bash.bashrc-bakup
      mv -f /etc/bash.bashrc.2 /etc/bash.bashrc
      msg -ama "$(fun_trans "AUTO INICIALIZAR AGREGADO")"
      msg -bar
   fi
}
fun_bar() {
   comando="$1"
   _=$(
      $comando >/dev/null 2>&1
   ) &
   >/dev/null
   pid=$!
   while [[ -d /proc/$pid ]]; do
      echo -ne " \033[1;33m["
      for ((i = 0; i < 10; i++)); do
         echo -ne "\033[1;31m##"
         sleep 0.2
      done
      echo -ne "\033[1;33m]"
      sleep 1s
      echo
      tput cuu1
      tput dl1
   done
   echo -e " \033[1;33m[\033[1;31m####################\033[1;33m] - \033[1;32m100%\033[0m"
   sleep 1s
}
meu_ip() {
   if [[ -e /etc/vps-freenet/MyIPVPS ]]; then
      echo "$(cat /etc/vps-freenet/MyIPVPS)"
   else
      MEU_IP=$(wget -qO- ifconfig.me)
      echo "$MEU_IP" >/etc/vps-freenet/MyIPVPS
   fi
}
fun_ip() {
   if [[ -e /etc/vps-freenet/MyIPVPS ]]; then
      IP="$(cat /etc/vps-freenet/MyIPVPS)"
   else
      MEU_IP=$(wget -qO- ifconfig.me)
      echo "$MEU_IP" >/etc/vps-freenet/MyIPVPS
   fi
}
fun_eth() {
   eth=$(ifconfig | grep -v inet6 | grep -v lo | grep -v 127.0.0.1 | grep "encap:Ethernet" | awk '{print $1}')
   [[ $eth != "" ]] && {
      msg -bar
      msg -ama " $(fun_trans "Aplicar el sistema para mejorar los paquetes SSH?")"
      msg -ama " $(fun_trans "Opciones para usuarios avanzados")"
      msg -bar
      read -p " [S/N]: " -e -i n sshsn
      [[ "$sshsn" = @(s|S|y|Y) ]] && {
         echo -e "${cor[1]} $(fun_trans "Correccion de problemas de paquetes en SSH ...")"
         echo -e " $(fun_trans "¿Cual es la tasa RX?")"
         echo -ne "[ 1 - 999999999 ]: "
         read rx
         [[ "$rx" = "" ]] && rx="999999999"
         echo -e " $(fun_trans "¿Cual es la tasa TX?")"
         echo -ne "[ 1 - 999999999 ]: "
         read tx
         [[ "$tx" = "" ]] && tx="999999999"
         apt-get install ethtool -y >/dev/null 2>&1
         ethtool -G $eth rx $rx tx $tx >/dev/null 2>&1
      }
      msg -bar
   }
}
os_system() {
   system=$(echo $(cat -n /etc/issue | grep 1 | cut -d' ' -f6,7,8 | sed 's/1//' | sed 's/      //'))
   echo $system | awk '{print $1, $2}'
}
remove_script() {
   clear
   clear
   msg -bar
   msg -tit
   msg -ama "          ¿ DESEA DESINSTALAR SCRIPT ?"
   msg -bar
   echo -e " Esto borrara todos los archivos del scrip VPS_MX"
   msg -bar
   while [[ ${yesno} != @(s|S|y|Y|n|N) ]]; do
      read -p " [S/N]: " yesno
      tput cuu1 && tput dl1
   done
   if [[ ${yesno} = @(s|S|y|Y) ]]; then
      rm -rf ${SCPdir} &>/dev/null
      rm -rf ${SCPusr} &>/dev/null
      rm -rf ${SCPinst} &>/dev/null
      [[ -e /bin/freenet ]] && rm /bin/freenet
      [[ -e /usr/bin/freenet ]] && rm /usr/bin/freenet
      [[ -e /bin/menu ]] && rm /bin/menu
      [[ -e /usr/bin/menu ]] && rm /usr/bin/menu
      cd $HOME
   fi
   sudo apt-get --purge remove squid -y >/dev/null 2>&1
   sudo apt-get --purge remove stunnel4 -y >/dev/null 2>&1
   sudo apt-get --purge remove dropbear -y >/dev/null 2>&1
}
systen_info() {
   clear
   clear
   msg -bar
   msg -tit
   msg -ama "$(fun_trans "                DETALLES DEL SISTEMA")"
   null="\033[1;31m"
   msg -bar
   if [ ! /proc/cpuinfo ]; then
      msg -verm "$(fun_trans "Sistema No Soportado")" && msg -bar
      return 1
   fi
   if [ ! /etc/issue.net ]; then
      msg -verm "$(fun_trans "Sistema No Soportado")" && msg -bar
      return 1
   fi
   if [ ! /proc/meminfo ]; then
      msg -verm "$(fun_trans "Sistema No Soportado")" && msg -bar
      return 1
   fi
   totalram=$(free | grep Mem | awk '{print $2}')
   usedram=$(free | grep Mem | awk '{print $3}')
   freeram=$(free | grep Mem | awk '{print $4}')
   swapram=$(cat /proc/meminfo | grep SwapTotal | awk '{print $2}')
   system=$(cat /etc/issue.net)
   clock=$(lscpu | grep "CPU MHz" | awk '{print $3}')
   based=$(cat /etc/*release | grep ID_LIKE | awk -F "=" '{print $2}')
   processor=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F ":" '{print $2}')
   cpus=$(cat /proc/cpuinfo | grep processor | wc -l)
   [[ "$system" ]] && msg -ama "$(fun_trans "Sistema"): ${null}$system" || msg -ama "$(fun_trans "Sistema"): ${null}???"
   [[ "$based" ]] && msg -ama "$(fun_trans "Base"): ${null}$based" || msg -ama "$(fun_trans "Base"): ${null}???"
   [[ "$processor" ]] && msg -ama "$(fun_trans "Procesador"): ${null}$processor x$cpus" || msg -ama "$(fun_trans "Procesador"): ${null}???"
   [[ "$clock" ]] && msg -ama "$(fun_trans "Frecuencia de Operacion"): ${null}$clock MHz" || msg -ama "$(fun_trans "Frecuencia de Operacion"): ${null}???"
   msg -ama "$(fun_trans "Uso del Procesador"): ${null}$(ps aux | awk 'BEGIN { sum = 0 }  { sum += sprintf("%f",$3) }; END { printf " " "%.2f" "%%", sum}')"
   msg -ama "$(fun_trans "Memoria Virtual Total"): ${null}$(($totalram / 1024))"
   msg -ama "$(fun_trans "Memoria Virtual En Uso"): ${null}$(($usedram / 1024))"
   msg -ama "$(fun_trans "Memoria Virtual Libre"): ${null}$(($freeram / 1024))"
   msg -ama "$(fun_trans "Memoria Virtual Swap"): ${null}$(($swapram / 1024))MB"
   msg -ama "$(fun_trans "Tempo Online"): ${null}$(uptime)"
   msg -ama "$(fun_trans "Nombre De La Maquina"): ${null}$(hostname)"
   msg -ama "$(fun_trans "IP De La  Maquina"): ${null}$(ip addr | grep inet | grep -v inet6 | grep -v "host lo" | awk '{print $2}' | awk -F "/" '{print $1}')"
   msg -ama "$(fun_trans "Version de Kernel"): ${null}$(uname -r)"
   msg -ama "$(fun_trans "Arquitectura"): ${null}$(uname -m)"
   msg -bar
   return 0
}
float_data() {
   valuest=$(ps ax | grep /etc/shadowsocks-r | grep -v grep)
   [[ $valuest != "" ]] && valuest="\033[1;32m[ON]" || valuest="\033[1;31m[OFF]"
   ofc="\033[0m${gren}(#OFICIAL)"
   dev="\033[0m${yellow}(#BETA)"
   dev2="\033[0m${red}(#PREMIUM)"
   case $1 in
   "ADMbot-VEN.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "=>>") " && msg -azu "BOT-USA1 VENTAS $dev2" ;;

   "openssh.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "OPENSSH $(pid_inst sshd)" ;;

   "squid.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "SQUID ---------------------------- $(pid_inst squid)" ;;
   "dropbear.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "DROPBEAR ------------------------- $(pid_inst dropbear)" ;;
   "openvpn.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "OPENVPN -------------------------- $(pid_inst openvpn)" ;;
   "ssl.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "SSL ------------------------------ $(pid_inst stunnel4)" ;;
   "shadowsocks.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "SHADOWSOCKS-NORMAL --------------- $(pid_inst ssserver)" ;;
   "Shadowsocks-libev.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "SHADOWSOCKS-LIBEV ---------------- $(pid_inst ss-server)" ;;
   "Shadowsocks-R.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "SHADOWSOCKS-R -------------------- ${valuest}" ;;
   "sockspy.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "SOCKS PYTHON --------------------- $(pid_inst python)" ;;
   "v2ray.sh") echo -ne "$(msg -verd "[$2]") $(msg -verm2 "==>>") " && msg -azu "V2RAY ---------------------------- $(pid_inst v2ray)" ;;
   "budp.sh") echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "BADVPN-(UDP:7300) ---------------- $(pid_inst badvpn)" ;;

   "python.py") return 1 ;;
   "paysnd.sh") return 1 ;;
   "ultrahost") return 1 ;;
   "speed.py") return 1 ;;
   "speedtest_v1") return 1 ;;
   "apacheon.sh") return 1 ;;
   "ports.sh") return 1 ;;
   "dns-netflix.sh") return 1 ;;
   "tcp.sh") return 1 ;;
   "gestor.sh") return 1 ;;
   "squidpass.sh") return 1 ;;
   "fai2ban.sh") return 1 ;;
   "blockBT.sh") return 1 ;;
   "utils.sh") return 1 ;;
   "ADMbot.sh") return 1 ;;
   "C-SSR.sh") return 1 ;;
   "Crear-Demo.sh") return 1 ;;
   "pwd.pwd") return 1 ;;
   "PDirect.py") return 1 ;;
   "PGet.py") return 1 ;;
   "POpen.py") return 1 ;;
   "PPriv.py") return 1 ;;
   "PPub.py") return 1 ;;
   "SSH20.log") return 1 ;;
   *) echo -ne "$(msg -verd " [$2]") $(msg -verm2 "==>>") " && msg -azu "${1^^} \033[1;33m No Hay Una Descripcion !" ;;
   esac
}
ferramentas_fun() {
   clear
   clear
   tput cuu1 && tput dl1
   msg -bar2
   msg -tit
   msg -ama "                 MENU DE HERRAMIENTAS"
   msg -bar2
   local Numb=1
   for arqs in $(ls ${SCPfrm}); do
      float_data "$arqs" "$Numb" && {
         script[$Numb]="$arqs"
         let Numb++
      }
   done
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "ADMINISTAR MEDIENTE BOT DE TELEGAM  $ofc"
   script[$Numb]="ADMbot.sh"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "NOTIFICACIONES NOTY-BOT             $ofc"
   script[$Numb]="NotyBOT.py"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "COMPARTIR ARCHIVO ONLINE            $ofc"
   script[$Numb]="apacheon.sh"
   echo -e "\033[1;93m-----------------------SEGURIDAD---------------------"
   #PROTECION
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "FIREWALL PARA VPS VPS•MX            $ofc"
   script[$Numb]="blockBT.sh"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "FAIL2BAN PROTECION                  $ofc"
   script[$Numb]="fai2ban.sh"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "AUTENTIFICAR PROXY SQUID            $ofc"
   script[$Numb]="squidpass.sh"
   echo -e "\033[1;93m--------------------AJUSTES INTERNOS-----------------"
   #AJUSTES INTERNOS
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "TCP ACELERACION (BBR/PLUS)          $dev"
   script[$Numb]="tcp.sh"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "AGREGAR DNS NETFLIX By @USA1_BOT    $ofc"
   script[$Numb]="dns-netflix.sh"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "ADMINISTRAR PUERTOS ACTIVOS         $ofc"
   script[$Numb]="ports.sh"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "Pass Root/Add root/Horario/etc..   $ofc"
   script[$Numb]="gestor.sh"
   #OPTIMIZADORES
   echo -e "\033[1;93m---------------------OPTIMIZADORES-------------------"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "Limpiar/Cache/Ram/Librerias/etc..  $ofc"
   script[$Numb]="utils.sh"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "DETALLES DE SISTEMA                $ofc"
   script[$Numb]="systeminf"
   #EXTRAS
   echo -e "\033[1;93m-------------------------EXTRAS----------------------"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "PAYLOAD FUERZA BRUTA               $ofc"
   script[$Numb]="paysnd.sh"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "SCANNER DE SUBDOMINIO              $ofc"
   script[$Numb]="ultrahost"
   let Numb++
   echo -ne "$(msg -verd "[$Numb]") $(msg -verm2 ">") " && msg -azu "PRUEBA DE VELOCIDAD                $ofc"
   script[$Numb]="speed.py"
   echo -ne "$(msg -bar2)\n$(msg -verd "[0]") $(msg -verm2 ">") " && msg -bra "\e[97m\033[1;41m VOLVER \033[1;37m"
   script[0]="voltar"
   msg -bar2
   selection=$(selection_fun $Numb)
   [[ -e "${SCPfrm}/${script[$selection]}" ]] && {
      ${SCPfrm}/${script[$selection]}
   } || {
      case ${script[$selection]} in
      #"agregar")agregar_ferramenta;;
      #"remove")remove_ferramenta;;
      "limpar") limpar_caches ;;
      "systeminf") systen_info ;;
      *) return 0 ;;
      esac
   }
}
# Menu Instalaciones
pid_inst() {
   [[ $1 = "" ]] && echo -e "\033[1;31m[OFF]" && return 0
   unset portas
   portas_var=$(lsof -V -i -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND")
   i=0
   while read port; do
      var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
      [[ "$(echo -e ${portas[@]} | grep "$var1 $var2")" ]] || {
         portas[$i]="$var1 $var2\n"
         let i++
      }
   done <<<"$portas_var"
   [[ $(echo "${portas[@]}" | grep "$1") ]] && echo -e "\033[1;32m[ON]" || echo -e "\033[1;31m[OFF]"
}
menu_inst() {
   clear
   clear
   msg -bar
   msg -tit
   export -f fun_eth
   export -f fun_bar
   menuTXT="  \e[97m\033[1;41m VOLVER \033[1;37m"
   msg -ama "                  MENU DE PROTOCOLOS "
   msg -bar
   local Numb=1
   for arqs in $(ls ${SCPinst}); do
      float_data "$arqs" "$Numb" && {
         script[$Numb]="$arqs"
         let Numb++
      }
   done
   msg -bar
   echo -ne "$(msg -verd " [0]") $(msg -verm2 "==>>") " && msg -bra "$menuTXT"
   msg -bar
   script[0]="voltar"
   selection=999
   selection=$(selection_fun $Numb)
   [[ -e "${SCPinst}/${script[$selection]}" ]] && {
      ${SCPinst}/${script[$selection]}
   } || return 0
}
# MENU FLUTUANTE
menu_func() {
   local options=${#@}
   local array
   for ((num = 1; num <= $options; num++)); do
      echo -ne "  $(msg -verd "[$num]") $(msg -verm2 "=>>") "
      array=(${!num})
      case ${array[0]} in
      "-vd") msg -verd "\033[1;33m[!]\033[1;32m $(fun_trans "${array[@]:1}")" | sed ':a;N;$!ba;s/\n/ /g' ;;
      "-vm") msg -verm2 "\033[1;33m[!]\033[1;31m $(fun_trans "${array[@]:1}")" | sed ':a;N;$!ba;s/\n/ /g' ;;
      "-fi") msg -azu "$(fun_trans "${array[@]:2}") ${array[1]}" | sed ':a;N;$!ba;s/\n/ /g' ;;
      *) msg -azu "$(fun_trans "${array[@]}")" | sed ':a;N;$!ba;s/\n/ /g' ;;
      esac
   done
}
# SISTEMA DE SELECAO
selection_fun() {
   local selection="null"
   local range
   for ((i = 0; i <= $1; i++)); do range[$i]="$i "; done
   while [[ ! $(echo ${range[*]} | grep -w "$selection") ]]; do
      echo -ne "\033[1;37m$(fun_trans " ► Selecione una Opcion"): " >&2
      read selection
      tput cuu1 >&2 && tput dl1 >&2
   done
   echo $selection
}
export -f msg
export -f selection_fun
export -f fun_trans
export -f menu_func
export -f meu_ip
export -f fun_ip
clear
msg -bar
msg -tit
# echo -e "\033[1;31m[\033[1;32m $vesaoSCT\033[1;97m"
# msg -bar
title=$(echo -e "\033[1;96m$(cat ${SCPdir}/message.txt)")
printf "%*s\n" $((($(echo -e "$title" | wc -c) + 55) / 2)) "$title"
msg -bar
echo -e "     \033[1;37mIP: \033[1;93m$(meu_ip)     \033[1;37mS.O: \033[1;96m$(os_system)"

# echo -e "\033[1;37m  % CPU: \033[1;32m$_usop   \033[1;37mS.O: \033[1;96m$(os_system) \033[1;37m  % RAM: \033[1;32m$_usor"

monservi_fun() {
   clear
   clear
   monssh() {
      sed -i "57d" /bin/monitor.sh
      sed -i '57i EstadoServicio ssh' /bin/monitor.sh
   }
   mondropbear() {
      sed -i "59d" /bin/monitor.sh
      sed -i '59i EstadoServicio dropbear' /bin/monitor.sh
   }
   monssl() {
      sed -i "61d" /bin/monitor.sh
      sed -i '61i EstadoServicio stunnel4' /bin/monitor.sh
   }
   monsquid() {
      sed -i "63d" /bin/monitor.sh
      sed -i '63i [[ $(EstadoServicio squid) ]] && EstadoServicio squid3' /bin/monitor.sh
   }
   monapache() {
      sed -i "65d" /bin/monitor.sh
      sed -i '65i EstadoServicio apache2' /bin/monitor.sh
   }
   monv2ray() {
      sed -i "55d" /bin/monitor.sh
      sed -i '55i EstadoServicio v2ray' /bin/monitor.sh
   }
   msg -bar
   msg -tit
   echo -e "\033[1;32m          MONITOR DE SERVICIONS PRINCIPALES"

   PIDVRF3="$(ps aux | grep "${SCPdir}/menu monitorservi" | grep -v grep | awk '{print $2}')"

   PIDVRF5="$(ps aux | grep "${SCPdir}/menu moni2" | grep -v grep | awk '{print $2}')"

   if [[ -z $PIDVRF3 ]]; then
      sed -i '5a\screen -dmS very3 /etc/vps-freenet/menu monitorservi' /bin/resetsshdrop
      msg -bar
      echo -e "\033[1;34m          ¿Monitorear Protocolo SSH/SSHD?"
      msg -bar
      read -p "                    [ s | n ]: " monssh
      sed -i "57d" /bin/monitor.sh
      sed -i '57i #EstadoServicio ssh' /bin/monitor.sh
      [[ "$monssh" = "s" || "$monssh" = "S" ]] && monssh
      msg -bar
      echo -e "\033[1;34m          ¿Monitorear Protocolo DROPBEAR?"
      msg -bar
      read -p "                    [ s | n ]: " mondropbear
      sed -i "59d" /bin/monitor.sh
      sed -i '59i #EstadoServicio dropbear' /bin/monitor.sh
      [[ "$mondropbear" = "s" || "$mondropbear" = "S" ]] && mondropbear
      msg -bar
      echo -e "\033[1;34m            ¿Monitorear Protocolo SSL?"
      msg -bar
      read -p "                    [ s | n ]: " monssl
      sed -i "61d" /bin/monitor.sh
      sed -i '61i #EstadoServicio stunnel4' /bin/monitor.sh
      [[ "$monssl" = "s" || "$monssl" = "S" ]] && monssl
      msg -bar
      echo -e "\033[1;34m            ¿Monitorear Protocolo SQUID?"
      msg -bar
      read -p "                    [ s | n ]: " monsquid
      sed -i "63d" /bin/monitor.sh
      sed -i '63i #[[ $(EstadoServicio squid) ]] && EstadoServicio squid3' /bin/monitor.sh
      [[ "$monsquid" = "s" || "$monsquid" = "S" ]] && monsquid
      msg -bar
      echo -e "\033[1;34m            ¿Monitorear Protocolo APACHE?"
      msg -bar
      read -p "                    [ s | n ]: " monapache
      sed -i "65d" /bin/monitor.sh
      sed -i '65i #EstadoServicio apache2' /bin/monitor.sh
      [[ "$monapache" = "s" || "$monapache" = "S" ]] && monapache
      msg -bar
      echo -e "\033[1;34m            ¿Monitorear Protocolo V2RAY?"
      msg -bar
      read -p "                    [ s | n ]: " monv2ray
      sed -i "55d" /bin/monitor.sh
      sed -i '55i #EstadoServicio v2ray' /bin/monitor.sh
      [[ "$monv2ray" = "s" || "$monv2ray" = "S" ]] && monv2ray

      #echo "screen -dmS very3 /etc/vps-freenet/menu monitorservi" >> /bin/resetsshdrop
      cd ${SCPdir}
      screen -dmS very3 ${SCPdir}/menu monitorservi
      screen -dmS monis2 ${SCPdir}/menu moni2
   else

      for pid in $(echo $PIDVRF3); do
         kill -9 $pid &>/dev/null
         sed -i "6d" /bin/resetsshdrop
      done

      for pid in $(echo $PIDVRF5); do
         kill -9 $pid &>/dev/null
      done

   fi
   msg -bar
   echo -e "             Puedes Monitorear desde:\n       \033[1;32m http://$(meu_ip):81/monitor.html"
   msg -bar
   [[ -z ${VERY3} ]] && monitorservi="\033[1;32m ACTIVADO " || monitorservi="\033[1;31m DESACTIVADO "
   echo -e "            $monitorservi  --  CON EXITO"
   msg -bar

}
monitor_auto() {
   while true; do
      monitor.sh 2>/dev/null
      sleep 120s
   done
}
if [[ "$1" = "monitorservi" ]]; then
   monitor_auto
   exit
fi
pid_kill() {
   [[ -z $1 ]] && refurn 1
   pids="$@"
   for pid in $(echo $pids); do
      kill -9 $pid &>/dev/null
   done
}
monitorport_fun() {
   while true; do
      pidproxy3=$(ps x | grep "PDirect.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy3 ]] && pid_kill $pidproxy3
      pidpyssl=$(ps x | grep "python.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidpyssl ]] && pid_kill $pidpyssl
      sleep 6h
   done
}
if [[ "$1" = "moni2" ]]; then
   monitorport_fun
   exit
fi
SSHN="$(grep -c home /etc/passwd)"
SSH2="$(echo ${SSHN} | bc)-2"
echo "${SSH2}" | bc >/etc/vps-freenet/controlador/SSH20.log
SSH3="$(less /etc/vps-freenet/controlador/SSH20.log)"
SSH4="$(echo $SSH3)"
user_info=$(cd /usr/local/shadowsocksr &>/dev/null && python mujson_mgr.py -l)
user_total=$(echo "${user_info}" | wc -l)
on="\033[1;92m[ON]" && off="\033[1;31m[OFF]"
[[ $(ps x | grep badvpn | grep -v grep | awk '{print $1}') ]] && badvpn=$on || badvpn=$off
echo -e "\033[1;97m   SSH REG:\033[1;92m $SSH4 \033[1;97m   SS-SSRR REG:\033[1;92m $user_total \033[1;97m   BADVPN: $badvpn"
VERY="$(ps aux | grep "${SCPusr}/usercodes verificar" | grep -v grep)"
VERY2="$(ps aux | grep "${SCPusr}/usercodes desbloqueo" | grep -v grep)"
VERY3="$(ps aux | grep "${SCPdir}/menu monitorservi" | grep -v grep)"
limseg="$(less /etc/vps-freenet/controlador/tiemlim.log)"
[[ -z ${VERY} ]] && verificar="\033[1;31m[OFF]" || verificar="\033[1;32m[ON]"
[[ -z ${VERY2} ]] && desbloqueo="\033[1;31m[OFF]" || desbloqueo="\033[1;32m[ON]"
[[ -z ${VERY3} ]] && monitorservi="\033[1;31m[OFF]" || monitorservi="\033[1;32m[ON]"

[[ -e ${SCPdir}/USRonlines ]] && msg -bar && msg -ne "\033[1;97m   LIMITADOR:\033[1;92m $verificar \033[1;97m DESBLOQUEO AUTOMATICO:\033[1;92m $desbloqueo\n   \033[1;32mCONECTADOS: " && echo -ne "\033[1;97m$(cat ${SCPdir}/USRonlines) "
[[ -e ${SCPdir}/USRexpired ]] && msg -ne "   EXPIRADOS: " && echo -ne "\033[1;97m$(cat ${SCPdir}/USRexpired) " && msg -ne " \033[1;95m BLOQUEADOS: " && echo -e "\033[1;97m$(cat ${SCPdir}/USRbloqueados) \n\033[1;97m        ACTULIZACION DE MONITOR CADA: \033[1;34m $limseg s"
creditoss() {
   clear
   msg -bar
   msg -tit
   echo -ne " \033[1;93m          CREDITOS Y REGISTRO DE CAMBIOS\n"
   msg -bar
   [[ -e ${SCPdir}/message.txt ]] && msg -bra " RESELLER AUTORIZADO: \n\033[1;96m $(cat ${SCPdir}/message.txt) "
   [[ -e ${SCPdir}/key.txt ]] && msg -bra " KEY DE REGISTRO:\n \033[1;93m $(cat ${SCPdir}/key.txt)"
   msg -bar
   echo -ne "\033[1;97m        CAMBIOS DE LA VERSION 8.5\n"
   echo -ne " - Compatible con Ubuntu's 14,16,18,20\n"
   echo -ne "        (Server live's ext 0.4)\n"
   echo -ne " - Compatibilidad Ubuntu 20, Squid,Openvpn,Dropbear\n"
   echo -ne " - Cambio en el proceso del usercode\n"
   echo -ne " - Menus Mas limpios\n"
   echo -ne " - Se ajustaron menus con retorno\n"
   echo -ne " - Ejecusion mas rapida de Comandos\n"
   echo -ne " - Instalador mejorado retro Compatible \n"
   echo -ne " - Add v2ray, opcion de port y tls manual \n"
   echo -ne " - Se agregaron 2 comandos mas al BOT Gestor \n"
   echo -ne "  (Bloquear y Desbloquear Usuarios, Como Ver Bloqueados)\n"
   echo -ne " + Auto Install Python para Install Inicial \n"
   echo -ne " + Selecionable Upgrade de S.O \n"
   echo -ne " + Cambio de pass root \n"
   echo -ne " + Se habilito el updater de menu \n"
   echo -ne " + Mas liviano y sencillo de actulizar\n"
   echo -ne " + Auto Reinicio Forzado (Actulizaciones de Ubuntu) \n"
   echo -ne " + Auto root Directo \n"
   echo -ne " + Error de IP Privada e IP Publica en menu \n"
   msg -bar
}
monhtop() {
   clear
   msg -bar
   msg -tit
   echo -ne " \033[1;93m             MONITOR DE PROCESOS HTOP\n"
   msg -bar
   msg -bra "    RECUERDA SALIR CON : \033[1;96m CTRL + C o FIN + F10 "
   [[ $(dpkg --get-selections | grep -w "htop" | head -1) ]] || apt-get install htop -y &>/dev/null
   msg -bar
   read -t 10 -n 1 -rsp $'\033[1;39m Preciona Enter Para continuar\n'
   clear
   sudo htop
   msg -bar
   msg -tit
   echo -ne " \033[1;93m             MONITOR DE PROCESOS HTOP\n"
   msg -bar
   echo -e "\e[97m                  FIN DEL MONITOR"
   msg -bar
}
msg -bar
menu_func "ADMINISTRAR CUENTAS | SSH/SSL/DROPBEAR" "ADMINISTRAR CUENTAS | SS/SSRR" "ADMINISTRAR CUENTAS | V2RAY" "\033[1;100mINSTALADORES DE PROTOCOLOS" "PUERTOS ACTIVOS" "HERRAMIENTAS y EXTRAS" "CAMBIAR COLORES DEL PANEL" "MONITOR DE PROTOCOLOS --------> ${monitorservi}" " AUTO INICIAR SCRIPT ----------> $AutoRun "
msg -bar
echo -ne " $(msg -verd " [10]") $(msg -verm2 "=>>") \e[36m MONITOR DE PROCESOS DE SISTEMA CON HTOP \e[97m \n"
msg -bar
echo -ne " \e[93m [11] \e[97m $(msg -verm2 "=>>") $(msg -verd "ACTUALIZAR ") " && echo -ne "\e[93m [12] \e[97m $(msg -verm2 "=>>") " && msg -bra "\033[1;31m DESINSTALAR "
msg -bar
echo -ne "$(msg -verd "  [13]") $(msg -verm2 "=>>") " && echo -ne "\033[1;97mCREDITOS" && echo -ne "$(msg -verd " [0]") $(msg -verm2 "=>>") " && msg -bra "\033[1;41m ❗️ SALIR DEL SCRIPT ❗️ "
msg -bar
selection=$(selection_fun 13)
case ${selection} in
1) ${SCPusr}/usercodes "${idioma}" ;;
2) ${SCPinst}/C-SSR.sh ;;
3) ${SCPinst}/v2ray.sh ;;
4) menu_inst ;;
5) mine_port ;;
6) ferramentas_fun ;;
7) canbio_color ;;
8) monservi_fun ;;
9) fun_autorun ;;
10) monhtop ;;
11) atualiza_fun ;;
12) remove_script ;;
13) creditoss ;;
0) cd $HOME && exit 0 ;;
esac
msg -ne "Enter Para Continuar" && read enter
${SCPdir}/menu
