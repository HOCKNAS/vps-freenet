#!/bin/bash
#beta test
#by @vps-freenet
#codigo fuente separado

SCPdir="/etc/vps-freenet"
SCPdir2="${SCPdir}/herramientas"
SCPusr="${SCPdir}/controlador"
MyPID="${SCPusr}/pid-access"
MyTIME="${SCPusr}/time-access"
USRdatabase="${SCPdir}/accessuser"
mostrar_usuarios () {
for u in `cat /etc/passwd|grep 'home'|grep 'false'|grep -v 'syslog'|awk -F ':' '{print $1}'`; do
    echo "$u"
  done
}
droppids () {
local pids

local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
local NOREPEAT
local reQ
local Port
while read port; do
reQ=$(echo ${port}|awk '{print $1}')
Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
[[ $(echo -e $NOREPEAT|grep -w "$Port") ]] && continue
NOREPEAT+="$Port\n"
case ${reQ} in

dropbear)
[[ -z $DPB ]] && local DPB="\033[1;31m DROPBEAR: \033[1;32m"
DPB+="$Port ";;

esac
done <<< "${portasVAR}"


[[ ! -z $DPB ]] && echo -e $DPB 

local port_dropbear="$DPB"
#cat /var/log/auth.log|grep "$(date|cut -d' ' -f2,3)" > /var/log/authday.log
cat /var/log/auth.log|tail -1000 > /var/log/authday.log
local log=/var/log/authday.log
local loginsukses='Password auth succeeded'
[[ -z $port_dropbear ]] && return 1
for port in `echo $port_dropbear`; do
 for pidx in $(ps ax |grep dropbear |grep "$port" |awk -F" " '{print $1}'); do
  pids="${pids}$pidx\n"
 done
done
for pid in `echo -e "$pids"`; do
  pidlogs=`grep $pid $log |grep "$loginsukses" |awk -F" " '{print $3}'`
  i=0
    for pidend in $pidlogs; do
    let i++
    done
    if [[ $pidend ]]; then
    login=$(grep $pid $log |grep "$pidend" |grep "$loginsukses")
    PID=$pid
    user=`echo $login |awk -F" " '{print $10}' | sed -r "s/'//g"`
    waktu=$(echo $login |awk -F" " '{print $2"-"$1,$3}')
    [[ -z $user ]] && continue
	echo "$user|$PID|$waktu"
    fi
done
}

block_userfun () {
local USRloked="/etc/vps-freenet/vps-userlock"
local LIMITERLOG="${USRdatabase}/Limiter.log"
local LIMITERLOG2="${USRdatabase}/Limiter2.log"
if [[ $2 = "-loked" ]]; then 
[[ $(cat ${USRloked}|grep -w "$1") ]] && return 1
echo " $1 (BLOCK-MULTILOGIN) $(date +%r--%d/%m/%y)"
limseg="$(less /etc/vps-freenet/controlador/tiemdes.log)"
KEY="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
URL="https://api.telegram.org/bot$KEY/sendMessage"
MSG="⚠️ AVISO DE VPS: $NOM1 ⚠️
🔹 CUENTA: $1 
❗️📵 BLOCK FIJO/TEMPORAL 📵❗️
🔓( AUTOUNLOCK EN $limseg SEGUNDOS) 🔓"
curl -s --max-time 10 -d "chat_id=$IDB1&disable_web_page_preview=1&text=$MSG" $URL &>/dev/null

pkill -u $1 &>/dev/null

fi
if [[ $(cat ${USRloked}|grep -w "$1") ]]; then
usermod -U "$1" &>/dev/null
[[ -e ${USRloked} ]] && {
   newbase=$(cat ${USRloked}|grep -w -v "$1")
   [[ -e ${USRloked} ]] && rm ${USRloked}
   for value in `echo ${newbase}`; do
   echo $value >> ${USRloked}
   done
   }
[[ -e ${LIMITERLOG} ]] && [[ $(cat ${LIMITERLOG}|grep -w "$1") ]] && {
   newbase=$(cat ${LIMITERLOG}|grep -w -v "$1")
   [[ -e ${LIMITERLOG} ]] && rm ${LIMITERLOG}
   for value in `echo ${newbase}`; do
   echo $value >> ${LIMITERLOG}
   echo $value >> ${LIMITERLOG}    
   done
}
return 1
else
usermod -L "$1" &>/dev/null
pkill -u $1 &>/dev/null

droplim=`droppids|grep -w "$1"|cut -d'|' -f2` 
kill -9 $droplim &>/dev/null

echo $1 >> ${USRloked}
#notifi &>/dev/null
return 0
fi

} 

dropbear_pids () {
local pids

local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
local NOREPEAT
local reQ
local Port
while read port; do
reQ=$(echo ${port}|awk '{print $1}')
Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
[[ $(echo -e $NOREPEAT|grep -w "$Port") ]] && continue
NOREPEAT+="$Port\n"
case ${reQ} in

dropbear)
[[ -z $DPB ]] && local DPB=""
DPB+="$Port ";;

esac
done <<< "${portasVAR}"


[[ ! -z $DPB ]] && echo -e $DPB

local port_dropbear="$DPB"
#cat /var/log/auth.log|grep "$(date|cut -d' ' -f2,3)" > /var/log/authday.log
cat /var/log/auth.log|tail -1000 > /var/log/authday.log
local log=/var/log/authday.log
local loginsukses='Password auth succeeded'
[[ -z $port_dropbear ]] && return 1
for port in `echo $port_dropbear`; do
 for pidx in $(ps ax |grep dropbear |grep "$port" |awk -F" " '{print $1}'); do
  pids="${pids}$pidx\n"
 done
done
for pid in `echo -e "$pids"`; do
  pidlogs=`grep $pid $log |grep "$loginsukses" |awk -F" " '{print $3}'`
  i=0
    for pidend in $pidlogs; do
    let i++
    done
    if [[ $pidend ]]; then
    login=$(grep $pid $log |grep "$pidend" |grep "$loginsukses")
    PID=$pid
    user=`echo $login |awk -F" " '{print $10}' | sed -r "s/'//g"`
    waktu=$(echo $login |awk -F" " '{print $2"-"$1,$3}')
    [[ -z $user ]] && continue
	echo "$user|$PID|$waktu"
    fi
done
}

openvpn_pids () {
#nome|#loguin|#rcv|#snd|#time
  byte () {
   while read B dummy; do
   [[ "$B" -lt 1024 ]] && echo "${B} bytes" && break
   KB=$(((B+512)/1024))
   [[ "$KB" -lt 1024 ]] && echo "${KB} Kb" && break
   MB=$(((KB+512)/1024))
   [[ "$MB" -lt 1024 ]] && echo "${MB} Mb" && break
   GB=$(((MB+512)/1024))
   [[ "$GB" -lt 1024 ]] && echo "${GB} Gb" && break
   echo $(((GB+512)/1024)) terabytes
   done
   }
for user in $(mostrar_usuarios); do
user="$(echo $user|sed -e 's/[^a-z0-9 -]//ig')"
[[ ! $(sed -n "/^${user},/p" /etc/openvpn/openvpn-status.log) ]] && continue
i=0
unset RECIVED; unset SEND; unset HOUR
 while read line; do
 IDLOCAL=$(echo ${line}|cut -d',' -f2)
 RECIVED+="$(echo ${line}|cut -d',' -f3)+"
 SEND+="$(echo ${line}|cut -d',' -f4)+"
 DATESEC=$(date +%s --date="$(echo ${line}|cut -d',' -f5|cut -d' ' -f1,2,3,4)")
 TIMEON="$(($(date +%s)-${DATESEC}))"
  MIN=$(($TIMEON/60)) && SEC=$(($TIMEON-$MIN*60)) && HOR=$(($MIN/60)) && MIN=$(($MIN-$HOR*60))
  HOUR+="${HOR}h:${MIN}m:${SEC}s\n"
  let i++
 done <<< "$(sed -n "/^${user},/p" /etc/openvpn/openvpn-status.log)"
RECIVED=$(echo $(echo ${RECIVED}0|bc)|byte)
SEND=$(echo $(echo ${SEND}0|bc)|byte)
HOUR=$(echo -e $HOUR|sort -n|tail -1)
echo -e "$user|$i|$RECIVED|$SEND|$HOUR" 
done
}
##LIMITADOR 
verif_fun () {
usuarios_activos=($(mostrar_usuarios))
 # DECLARANDO VARIAVEIS PRIMARIAS
    local conexao
    local limite
    local TIMEUS
    declare -A conexao
    declare -A limite
    declare -A TIMEUS
    local LIMITERLOG="${SCPusr}/Limiter.log"
	local LIMITERLOG2="${SCPusr}/Limiter2.log"
    [[ $(dpkg --get-selections|grep -w "openssh"|head -1) ]] && local SSH=ON || local SSH=OFF
    [[ $(dpkg --get-selections|grep -w "dropbear"|head -1) ]] && local DROP=ON || local DROP=OFF
    [[ $(dpkg --get-selections|grep -w "openvpn"|head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && local OPEN=ON || local OPEN=OFF
    while true; do
    unset EXPIRED
    unset ONLINES
	unset BLOQUEADO
    #[[ -e ${MyTIME} ]] && source ${MyTIME}
    local TimeNOW=$(date +%s)
    # INICIA VERIFICAȃO
    
		while read user; do
           echo -ne "\033[1;33mUSUARIO: \033[1;32m$user "
           if [[ ! $(echo $(mostrar_usuarios)|grep -w "$user") ]]; then
              echo -e "\033[1;31mNO EXISTE"
              continue
           fi
           local DataUser=$(chage -l "${user}" |grep -i co|awk -F ":" '{print $2}')
           if [[ ! -z "$(echo $DataUser|grep never)" ]]; then
               echo -e "\033[1;31mILIMITADO" 
               continue
           fi
           local DataSEC=$(date +%s --date="$DataUser")
           if [[ "$DataSEC" -lt "$TimeNOW" ]]; then
              EXPIRED="1+"          
              block_userfun $user -loked && echo " $user (EXPIRADO) $(date +%r--%d/%m/%y)" >> $LIMITERLOG && echo " $user (EXPIRADO) $(date +%r--%d/%m/%y)" >> $LIMITERLOG2 && KEY="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
URL="https://api.telegram.org/bot$KEY/sendMessage"
MSG="⚠️ AVISO DE VPS: $NOM1 ⚠️
🔹 CUENTA: $user 
❗️ 📵 EXPIRADA 📵 ❗️"
curl -s --max-time 10 -d "chat_id=$IDB1&disable_web_page_preview=1&text=$MSG" $URL && pkill -u $user
              echo -e "\033[1;31m EXPIRADO"
              continue
           fi
           local PID="0+"
           [[ $SSH = ON  ]] && PID+="$(ps aux|grep -v grep|grep sshd|grep -w "$user"|grep -v root|wc -l 2>/dev/null)+"
           [[ $DROP = ON  ]] && PID+="$(dropbear_pids|grep -w "$user"|wc -l)+"
           [[ $OPEN = ON  ]] && [[ $(openvpn_pids|grep -w "$user"|cut -d'|' -f2) ]] && PID+="$(openvpn_pids|grep -w "$user"|cut -d'|' -f2)+"
            local ONLINES+="$(echo ${PID}0|bc)+"
            local conexao[$user]="$(echo ${PID}0|bc)"
           if [[ ${conexao[$user]} -gt '0' ]]; then #CONTADOR DE TEMPO ONLINE
              [[ -z "${TIMEUS[$user]}" ]] && local TIMEUS[$user]=0
              [[ "${TIMEUS[$user]}" != +([0-9]) ]] && local TIMEUS[$user]=0
              local TIMEUS[$user]="$((300+${TIMEUS[$user]}))"
              local VARS="$(cat ${MyTIME}|grep -w -v "$user")"
              echo "TIMEUS[$user]='${TIMEUS[$user]}'" > ${MyTIME}
             for variavel in $(echo ${VARS}); do echo "${variavel}" >> ${MyTIME}; done
            fi           
           local limite[$user]="$(cat ${USRdatabase}|grep -w "${user}"|cut -d' ' -f3)"
           [[ -z "${limite[$user]}" ]] && continue
           [[ "${limite[$user]}" != +([0-9]) ]] && continue
           if [[ "${conexao[$user]}" -gt "${limite[$user]}" ]]; then
           local lock=$(block_userfun $user -loked)
           pkill -u $user
		   
		   droplim=`dropbear_pids|grep -w "$user"|cut -d'|' -f2` 
		   kill -9 $droplim &>/dev/null
		   
		   openlim=`openvpn_pids|grep -w "$user"|cut -d'|' -f2`
		   kill -9 $openlim &>/dev/null
		   
		   echo "$lock" >> $LIMITERLOG && echo "$lock" >> $LIMITERLOG2
           echo -e "\033[1;31m ULTRAPASO LIMITE"
           continue
           fi
           echo -e "\033[1;33m OK! \033[1;31m${conexao[$user]} CONEXIONESS"
		   BLOQUEADO="$(wc -l /etc/vps-freenet/vps-userlock | awk '{print $1}')"
		   
		   BLOQUEADO2="$(echo ${BLOQUEADO}|bc)0"
		   BLOQUEADO3="/10"
		   EXPIRADO="$(grep -c EXPIRADO /etc/vps-freenet/controlador/Limiter.log)"
		   EXPIRADO2="$(echo ${EXPIRADO}|bc)0"
		   EXPIRADO3="/10"
    done <<< "$(mostrar_usuarios)"
    echo "${ONLINES}0"|bc > ${SCPdir}/USRonlines
    #echo "${EXPIRED}0"|bc > ${SCPdir}/USRexpired
	echo "${EXPIRADO2}${EXPIRADO3}"|bc > ${SCPdir}/USRexpired
	echo "${BLOQUEADO2}${BLOQUEADO3}"|bc > ${SCPdir}/USRbloqueados
	limseg="$(less /etc/vps-freenet/controlador/tiemlim.log)"
	
	sleep $limseg# TEMPO DE ESPERA DO LOOP
    clear
    done
 }
 verif_fun
 exit