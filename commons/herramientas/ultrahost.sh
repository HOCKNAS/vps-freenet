#!/bin/bash
#27/06/2021
clear
clear
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m" )
SCPdir="/etc/vps-freenet" && [[ ! -d ${SCPdir} ]] && exit 1
SCPusr="${SCPdir}/controlador" && [[ ! -d ${SCPusr} ]] && mkdir ${SCPusr}
SCPfrm="${SCPdir}/herramientas" && [[ ! -d ${SCPfrm} ]] && mkdir ${SCPfrm}
SCPinst="${SCPdir}/protocolos" && [[ ! -d ${SCPfrm} ]] && mkdir ${SCPfrm}
subdom () {
SUBDOM="$1"
[[ "$SUBDOM" = "" ]] && return
randomize="$RANDOM"
    for sites in `cat $log`; do
    [[ $(echo ${DNS[@]}|grep $sites) = "" ]] && DNS+=($sites)
    [[ $(echo ${DNS[@]}|grep $sites) != "" ]] && cat $log|grep -v "$sites" > $log
    done
    while true; do
    [[ "$(pidof lynx | wc -w)" -lt "20" ]] && break
    done
    (
    HOST[$randomize]="$SUBDOM"
    curl -sSL "${HOST[$randomize]}"|grep -Eoi '<a [^>]+>'|grep -Eo 'href="[^\"]+"'|grep -Eo '(http|https)://[a-zA-Z0-9./*]+'|sort -u|awk -F "://" '{print $2}' >> $log
    ) > /dev/null 2>&1 &
}

iniciar () {
while [[ -z $SUB_DOM ]]; do
echo -ne "\033[1;33m$(fun_trans "Introduzca el Dominio para realizar la prueba"): " && read SUB_DOM
done
[[ -z $limite ]] && echo -ne "\033[1;33m$(fun_trans "Escriba el Limite de Resultados"): " && read limite
[[ -z ${limite} ]] && limite="300"
msg -bar
#CRIA LOG
log="./loog" && touch $log
#INICIA PRIMEIRA BUSCA
_DOM=$(curl -sSL "$SUB_DOM"|grep -Eoi '<a [^>]+>'|grep -Eo 'href="[^\"]+"'|grep -Eo '(http|https)://[a-zA-Z0-9./*]+'|sort -u|awk -F "://" '{print $2}')
  for _DOMS in `echo $_DOM`; do
 [[ $(echo ${DNS[@]}|grep ${_DOMS}) = "" ]] && DNS+=(${_DOMS})
  done
#INICIA THREADS
i=0
while true; do
DOMAIN=$(echo "${DNS[$i]}")
[[ $DOMAIN = "" ]] && break
 if [[ $(echo -e "${PESQ[@]}"|grep "$DOMAIN") = "" ]]; then
  subdom "$DOMAIN"
  echo -e "\033[1;31m(Scan\033[1;32m $((${#PESQ[@]}+1))\033[1;31m de \033[1;32m${#DNS[@]}\033[1;31m) - $(fun_trans "Escaneando") ---> \033[1;36mhttp://$DOMAIN\033[1;37m"
  PESQ+=($DOMAIN)
 fi
[[ "$(echo ${#DNS[@]})" -gt "$limite" ]] && break
i=$(($i+1))
sleep 1s
done
rm $log
msg -bar
echo -e "\033[1;32m$(fun_trans "Scan Finalizado Inicio de la colección de IPs")\033[1;31m\033[0m"
[[ -e $HOME/subresult ]] && rm $HOME/subresult
[[ ! -e $HOME/subresult ]] && touch $HOME/subresult
for result in $(echo "${DNS[@]}"); do
(
rand="$RANDOM"
dns[rand]="$result"
scan[rand]=$(echo ${result}|cut -d'/' -f1)
IP[rand]=$(nslookup "${scan[rand]}"|grep -Eo 'Address: [0-9.]+'|grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|tail -1) > /dev/null 2>&1
echo -e "====================================\nDNS: ${dns[rand]}\nIP: ${IP[rand]}\n====================================" >> $HOME/subresult
unset IP
) &
done
while true; do
[[ $(pidof nslookup|wc -w) -lt "1" ]] && break
done
msg -bar
RSLT=$(($(cat $HOME/subresult|wc -l)/4)) && echo -e "\033[1;32m$RSLT $(fun_trans "Hosts Capturados")\033[0m"
msg -bar
echo -ne "$(fun_trans "Desea Imprimir Resultados")? [S/N]: "; read yn
   [[ $yn = @(s|S|y|Y) ]] && {
   echo -ne "\033[1;32m"
   cat $HOME/subresult|grep -v =
   echo -e "$barra\033[0m"
   }
return 0
}
#INICIA SCRIPT
msg -bar
msg -tit
echo -e "\033[1;33m $(fun_trans "                  SCAN DE SUNDOMINIOS")"
msg -bar
iniciar
[[ $? = "0" ]] &&
echo -e "\033[1;32m$(fun_trans "Registro generado en el archivo") $HOME/subresult\033[0m" &&
msg -bar