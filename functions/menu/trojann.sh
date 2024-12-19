#!/bin/bash
fun_ip() {
MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MIP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
echo "$IP" >/bin/IPca
}  
config="/usr/local/etc/trojan/config.json"
temp="/etc/trojan/temp.json"
trojdir="/etc/trojan" && [[ ! -d $trojdir ]] && mkdir $trojdir
user_conf="/etc/trojan/user" && [[ ! -e $user_conf ]] && touch $user_conf
backdir="/etc/trojan/back" && [[ ! -d ${backdir} ]] && mkdir ${backdir}
tmpdir="$backdir/tmp"

fun_ip
msg () {
#ACTULIZADOR
													
[[ ! -e /etc/script_version ]] && echo 1 > /etc/script_version
v11=$(cat /etc/script_version_new) 
v22=$(cat /etc/script_version)
#[[ $v11 = $22 ]] && 
vesaoSCT="\033[1;37mVersion \033[1;32m$v22\033[1;31m]" #|| vesaoSCT="\033[1;32mUPDATE\033[1;91m[\033[1;32m$v11\033[1;31m]" 

local colors="/etc/vps-freenet/colors"
if [[ ! -e $colors ]]; then
COLOR[0]='\033[1;37m' #BRAN='\033[1;37m'
COLOR[1]='\e[93m' #VERMELHO='\e[31m'
COLOR[2]='\e[92m' #VERDE='\e[32m'
COLOR[3]='\e[91m' #AMARELO='\e[33m'
COLOR[4]='\e[94m' #AZUL='\e[34m'
COLOR[5]='\e[95m' #MAGENTA='\e[35m'
COLOR[6]='\033[1;97m' #MAG='\033[1;36m'
COLOR[7]='\033[36m' #MAG='\033[36m'
else
local COL=0
for number in $(cat $colors); do
case $number in
1)COLOR[$COL]='\033[1;37m';;
2)COLOR[$COL]='\e[31m';;
3)COLOR[$COL]='\e[32m';;
4)COLOR[$COL]='\e[33m';;
5)COLOR[$COL]='\e[34m';;
6)COLOR[$COL]='\e[35m';;
7)COLOR[$COL]='\033[1;36m';;
8)COLOR[$COL]='\e[36m';;
esac
let COL++
done
fi
NEGRITO='\e[1m'
SEMCOR='\e[0m'
 case $1 in
  -ne)cor="${COLOR[1]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -nazu) cor="${COLOR[6]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nverd)cor="${COLOR[2]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nama) cor="${COLOR[1]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -ama)cor="${COLOR[1]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verm)cor="${COLOR[3]}${NEGRITO}[!] ${COLOR[1]}" && echo -e "${cor}${2}${SEMCOR}";;
  -verm2)cor="${COLOR[3]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -nverm)cor="${COLOR[3]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -azu)cor="${COLOR[6]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -azuc)cor="${COLOR[7]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verd)cor="${COLOR[2]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -azul)cor="${COLOR[4]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -bra)cor="${COLOR[0]}${SEMCOR}" && echo -e "${cor}${2}${SEMCOR}";;
  -nblanco)cor="${COLOR[0]}${SEMCOR}" && echo -ne "${cor}${2}${SEMCOR}";;
  "-bar2"|"-bar")cor="\e[1;30m————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
  -tit)echo -e "\e[91m≪━━─━━─━─━─━─━─━━─━━─━─━─◈─━━─━─━─━─━━─━─━━─━─━━─━≫ \e[0m\n  \e[2;97m\e[3;93m❯❯❯❯❯❯ ꜱᴄʀɪᴩᴛ ᴍᴏᴅ ʟᴀᴄᴀꜱɪᴛᴀᴍx ❮❮❮❮❮❮\033[0m \033[1;31m[\033[1;32m$vesaoSCT\n\e[91m≪━━─━─━━━─━─━─━─━─━━─━─━─◈─━─━─━─━─━━━─━─━─━━━─━─━≫   \e[0m" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
 # -bar3) $([[ ! -e $(echo -e $(echo "2F7573722F6C6F63616C2F6C69622F726D"| sed 's/../\\x&/g;s/$/ /')) ]] && $( aviso_bock > /dev/null 2>&1)) && echo -e "${SEMCOR}${cor}${SEMCOR}";;
 esac
}
numero='^[0-9]+$'
hora=$(printf '%(%H:%M:%S)T') 
fecha=$(printf '%(%D)T')

trojango(){
  clear

[[ ! -e $trojdir/conf ]] && echo "autBackup 0" > $trojdir/conf
if [[ $(cat $trojdir/conf | grep "autBackup") = "" ]]; then
	echo "autBackup 0" >> $trojdir/conf
fi
unset barra
barra="\033[0;34m•••••••••••••••••••••••••••••••••••••••••••••••••\033[0m"
#

restroj(){
msg -bar
killall trojan &> /dev/null
[[ -e /root/server.log ]] && echo > /root/server.log || touch /root/server.log
[[ $(uname -m 2> /dev/null) != x86_64 ]] && {
echo -ne "\033[1;32m RESTART FOR ARM X64 " && (screen -dmS trojanserv trojan --config /usr/local/etc/trojan/config.json >> /root/server.log &) && echo "OK " || echo -e "\033[1;31m FAIL"
} || echo -ne "\033[1;32m REINICIANDO SERVICIO " && (screen -dmS trojanserv trojan /usr/local/etc/trojan/config.json -l /root/server.log &) && echo "OK " || echo -e "\033[1;31m FAIL"
msg -bar
}

restore(){
	clear

	unset num
	unset opcion
	unset _res

	if [[ -z $(ls $backdir) ]]; then
		title "	no se encontraron respaldos"
		sleep 0.3
		return
	fi
	num=1
	title "	   Lista de Respaldos creados"
	blanco "	      nom  \033[0;31m| \033[1;37mfechas \033[0;31m|  \033[1;37mhora"
	msg -bar
	for i in $(ls $backdir); do
		col "$num)" "$i"
		_res[$num]=$i
		let num++
	done
	msg -bar
	col "0)" "VOLVER"
	msg -bar
	blanco " cual desea restaurar?" 0
	read opcion

	[[ $opcion = 0 ]] && return
	[[ -z $opcion ]] && blanco "\n deves seleccionar una opcion!" && sleep 2 && return
	[[ ! $opcion =~ $numero ]] && blanco "\n solo deves ingresar numeros!" && sleep 2 && return
	[[ $opcion -gt ${#_res[@]} ]] && blanco "\n solo numeros entre 0 y ${#_res[@]}" && sleep 2 && return

	mkdir $backdir/tmp
	tar xpf $backdir/${_res[$opcion]} -C $backdir/tmp/

	clear
	title "	Archivos que se restauran"

	if rm -rf $config && cp $tmpdir/config.json $temp; then
		sleep 1
		cat $temp > $config
		chmod 777 $config
		rm $temp
		blanco " /usr/local/etc/trojan/config.json..." && verde "[ok]" 
	else
		blanco " /usr/local/etc/trojan/config.json..." && rojo "[fail]"	
	fi

	if rm -rf $user_conf && cp $tmpdir/user $user_conf; then
		blanco " /etc/trojan/user..." && verde "[ok]"
	else
		blanco " /etc/trojan/user..." && rojo "[fail]"
	fi
    #[[ -e $tmpdir/fullchain.cer ]] && mv $tmpdir/fullchain.cer $tmpdir/fullchain.crt
	if rm -rf /etc/vps-freenet/trojancert && mkdir /etc/vps-freenet/trojancert && cp $tmpdir/*.cer /etc/vps-freenet/trojancert/fullchain.cer && cp $tmpdir/*.key /etc/vps-freenet/trojancert/private.key; then
		blanco " /etc/vps-freenet/trojancert/fullchain.cer..." && verde "[ok]"
		blanco " /etc/vps-freenet/trojancert/private.key..." && verde "[ok]"
	else
		blanco " /etc/vps-freenet/trojancert/fullchain.cer..." && rojo "[fail]"
		blanco " /etc/vps-freenet/trojancert/private.key..." && rojo "[fail]"
		echo $barra
		echo -e "VALIDA TU CERTIFICADO SSL "
		fi
	rm -rf $tmpdir
	msg -bar
	continuar
	read foo
}

backups(){
	while :
	do
		unset opcion
		unset PID
		if [[ $(ps x | grep "autBackup" | grep -v grep) = "" ]]; then
			PID="\033[0;31m[offline]"
		else
			PID="\033[1;92m[online]"
		fi

	clear
	title "	Config de Respaldos"
	col "1)" "Respaldar Ahora"
	col "2)" "\033[1;92mRestaurar Respaldo"
	col "3)" "\033[0;31mEliminiar Respaldos"
	col "4)" "\033[1;34mRespaldo en linea $PID"
	col "5)" "\033[1;33mRespaldos automatico $(on_off_res)"
	msg -bar
	
	col "6)" "\033[1;33m RESTAURAR Online PORT :81 "
	col "7)" "\033[1;33m RESPALDO LOCAL "
	msg -bar
	col "0)" "VOLVER"
	msg -bar
	blanco "opcion" 0
	read opcion

	case $opcion in
		1)	backup
			clear
			title "	Nuevo Respaldo Creado..."
			sleep 0.5;;
		2)	restore;;
		3)	rm -rf $backdir/*.tar
			clear
			title "	Almacer de Respaldo limpia..."
			sleep 0.5;;
		4)	server;;


		5)	if [[ $(cat $v2rdir/conf | grep "autBackup" | cut -d " " -f2) = "0" ]]; then
				sed -i 's/autBackup 0/autBackup 1/' $v2rdir/conf
			else
				sed -i 's/autBackup 1/autBackup 0/' $v2rdir/conf
			fi;;
		6)
		clear
		echo -e "\033[0;33m
         ESTA FUNCION EXPERIMENTAL 
Una vez que se descarge tu Fichero, Escoje el BackOnline
	
				  + OJO +
				 
   Luego de Restaurarlo, Vuelve Activar el TLS 
 Para Validar la Configuracion de tu certificao"
msg -bar
echo -e "INGRESE LINK Online en GitHub, o VPS \n" 
read -p "Pega tu Link : " url1
wget -q -O $backdir/BakcOnline.tar $url1 && echo -e "\033[1;31m- \033[1;32mFile Exito!"  && restore || echo -e "\033[1;31m- \033[1;31mFile Fallo" && sleep 2
		;;
		7)
		bakc;;
		0)	break;;
		*)	blanco "opcion incorrecta..." && sleep 2;;
	esac
	done
}



backup() {
	unset fecha
	unset hora
	unset tmp
	unset back
	unset cer
	unset key
	#fecha=`date +%d-%m-%y-%R`
	fecha=`date +%d-%m-%y`
	hora=`date +%R`
	tmp="$backdir/tmp" && [[ ! -d ${tmp} ]] && mkdir ${tmp}
	back="$backdir/troj___${fecha}___${hora}.tar"
	[[ -e /etc/vps-freenet/trojancert/fullchain.cer ]] && cer="/etc/vps-freenet/trojancert/fullchain.cer"
	[[ -e /etc/vps-freenet/trojancert/private.key ]] && key="/etc/vps-freenet/trojancert/private.key"

	cp $user_conf $tmp
	cp $config $tmp
	[[ ! $cer = null ]] && [[ -e $cer ]] && cp $cer $tmp
	[[ ! $key = null ]] && [[ -e $cer ]] && cp $key $tmp

	cd $tmp
	tar -cpf $back *
	cp $back /var/www/html/trojanBack.tar && echo -e "
 Descargarlo desde cualquier sitio con acceso WEB
  LINK : http://$IP:81/trojanBack.tar \033[0m
-------------------------------------------------------"
read -p "ENTER PARA CONTINUAR"
	rm -rf $tmp
 }

trojan() {
main
}


changeCERT () {
clear&&clear
unset opcion
			dataCERT=$(cat $config | jq -r .ssl.cert)
			dataKEY=$(cat $config | jq -r .ssl.key)
			msg -bar && echo ""
			echo -e " INGRESO DE RUTA DE CERTIFICADO SSL VALIDO ACTUAL" && echo ""
			echo -e " DATA CRT : ${dataCERT}" && echo "" && echo -e " DATA CRT : ${dataKEY}" && echo "" && msg -bar3 && echo -e ""
	while :
    do
	echo -e " DESEAS CAMBIAR RUTA DE TU CERTIFICADO SSL ? "
			read -p " [SI / NO ] :" opcion
            case $opcion in
				0)break ;;
                [Yy]|[Ss]) 
				echo -e " A CONTINUACION INGRESE SUS NUEVAS RUTAS DE CERTIFICADO"
				echo -e " DEFAULT ( /data/cert.crt && /data/cert.key ) ." && echo ""
				read -p "$(echo -e " DATA CRT :")" -e -i "/data/cert.crt" newdataCERT
				tput cuu1 && tput dl1
				read -p "$(echo -e " DATA KEY :")" -e -i "/data/cert.key" newdataKEY
				sed -i "s%${dataCERT}%${newdataCERT}%g" $config
				sed -i "s%${dataKEY}%${newdataKEY}%g" $config
				break
				;;
                [Nn]) cancelar && sleep 0.5 && break;;
                *) echo -e "\n \033[1;49;37mSelecione (S) para si o (N) para no!\033[0m" && sleep 0.5 && continue
	tput cuu1 && tput dl1
	tput cuu1 && tput dl1
	tput cuu1 && tput dl1
	tput cuu1 && tput dl1
					;;
            esac
	done
			
		}

 
changeSNI () {
clear&&clear
unset opcion
			dataCERT=$(cat $config | jq -r .ssl.sni)
			msg -bar && echo ""
			echo -e " INGRESO INGRESA SNI VALIDO" && echo ""
			echo -e " SNI : ${dataCERT}" && echo "" && msg -bar3 && echo -e ""
	while :
    do
	echo -e " DESEAS CAMBIAR SNI ? "
			read -p " [SI / NO ] :" opcion
            case $opcion in
				0)break ;;
                [Yy]|[Ss])
				echo -e " A CONTINUACION INGRESE SU NUEVO SNI"
				read -p "$(echo -e " SNI Defauld : ")" -e -i "ssl.whatsapp.net" newdataKEY
				if sed -i "s%${dataCERT}%${newdataCERT}%g" $config ; then
				echo -e " EXITO AL CAMBIAR TU SNI"
				else
				newdataKEY='"sni": "${newdataKEY}",'
				sed -i "s%${dataCERT}%${newdataCERT}%g" $config
				echo -e " ERROR AL MODIFICAR SNI"
				fi
				break
				;;
                [Nn]) cancelar && sleep 0.5 && break;;
                *) echo -e "\n \033[1;49;37mSelecione (S) para si o (N) para no!\033[0m" && sleep 0.5 && continue
					;;
            esac
	done
			
		}

 
on_off_res(){
	if [[ $(cat $trojdir/conf | grep "autBackup" | cut -d " " -f2) = "0" ]]; then
		echo -e "\033[0;31m[off]"
	else
		echo -e "\033[1;92m[on]"
	fi
 }

blanco(){
	[[ !  $2 = 0 ]] && {
		echo -e "\033[1;37m$1\033[0m"
	} || {
		echo -ne " \033[1;37m$1:\033[0m "
	}
}

verde(){
	[[ !  $2 = 0 ]] && {
		echo -e "\033[1;32m$1\033[0m"
	} || {
		echo -ne " \033[1;32m$1:\033[0m "
	}
}

rojo(){
	[[ !  $2 = 0 ]] && {
		echo -e "\033[1;31m$1\033[0m"
	} || {
		echo -ne " \033[1;31m$1:\033[0m "
	}
}

col(){

	nom=$(printf '%-55s' "\033[0;92m${1} \033[0;31m ➣   \033[1;37m${2}")
	echo -e "	$nom\033[0;31m${3}   \033[0;92m${4}\033[0m"
}

col2(){

	echo -e " \033[1;91m$1\033[0m \033[1;37m$2\033[0m"
}

vacio(){

	blanco "\n no se puede ingresar campos vacios..."
}

cancelar(){

	echo -e "\n \033[3;49;31minstalacion cancelada...\033[0m"
}

continuar(){
	echo -e " \033[3;49;32mEnter para continuar...\033[0m"
}

title2(){
trojanports=`lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN" | grep trojan | awk '{print substr($9,3); }' > /tmp/trojan.txt && echo | cat /tmp/trojan.txt | tr '\n' ' ' > /etc/vps-freenet/trojanports.txt && cat /etc/vps-freenet/trojanports.txt` > /dev/null 2>&1 
trojanports=$(echo $trojanports | awk {'print $1'})
_tconex=$(netstat -nap | grep "$trojanports" | grep trojan | grep ESTABLISHED | awk {'print $5'} | awk -F ":" '{print $1}' | sort | uniq | wc -l)
	
	msg -tit
	[[ $(uname -m 2> /dev/null) != x86_64 ]] && echo -e "	CPU : ARM64 - BINARIO : trojan-go"
	#{pPIniT
	echo -e "           \033[1;37mIP: \033[1;31m$IP \033[1;37m"
	[[ ! -z $trojanports ]] && echo -e "       \e[97m\033[1;41mPUERTO ACTIVO :\033[0m \033[3;32m$trojanports\033[0m   \e[97m\033[1;41m ACTIVOS:\033[0m \033[3;32m\e[97m\033[1;41m $_tconex " ||  echo -e "     \e[97m\033[1;41m  SERVICIO TROJAN NO INICIADO \033[3;32m"
}

title(){
	msg -bar
	
	echo -e "     >>>>>>> Fecha Actual $(date '+%d-%m-%Y') <<<<<<<<<<<"
	blanco "$1"
	msg -bar
}

userDat(){
	#echo -e "     >>>>>>> Fecha Actual $(date '+%d-%m-%Y') <<<<<<<<<<<"
	blanco "	N°    Usuarios 		  fech exp   dias"
	msg -bar
}

log_traff () {
[[ $log0 -le 1 ]] && restroj && let log0++ && clear 
msg -bar
echo -e ""
echo -e " ESPERANDO A LA VERIFICACION DE IPS Y USUARIOS "
echo -e "      ESPERE UN MOMENTO PORFAVOR $log0"
echo -e ""
msg -bar
fun_bar
msg -bar
sleep 5s
clear&&clear
title2
msg -bar
IP_tconex=$(netstat -nap | grep "$trojanports" | grep trojan | grep ESTABLISHED | awk {'print $5'} | awk -F ":" '{print $1}' | sort | uniq)
nick="$(cat $config | grep ',"')"
users="$(echo $nick|sed -e 's/[^a-z0-9 -]//ig')"
n=1
[[ -z $IP_tconex ]] && echo -e " NO HAY USUARIOS CONECTADOS!" && return
for i in $IP_tconex
do
	USERauth=$(cat $HOME/server.log | grep $i | cut -d: -f4 | grep authenticated |awk '{print $4}'| sort | uniq)
	
	Users+="$USERauth\n"
	#let n++
done
#echo -e "$Users"
echo -e " N) USER - CONEXIONES "|column -t -s '-'
for U in $users
	do
	CConT=$(echo -e "$Users" | grep $U |wc -l)
	[[ $CConT = 0 ]] && continue
	UConc+=" $n) $U -$CConT\n"
	let n++
done
echo -e "$UConc"|column -t -s '-' 
msg -bar
continuar
read -p " " enter

}

fun_bar () {
#==comando a ejecutar==
comando="$1"
#==interfas==
in=' ['
en=' ] '
full_in="➛"
full_en='100%'
bar=("--------------------"
"=-------------------"
"]=------------------"
"[-]=-----------------"
"=[-]=----------------"
"-=[-]=---------------"
"--=[-]=--------------"
"---=[-]=-------------"
"----=[-]=------------"
"-----=[-]=-----------"
"------=[-]=----------"
"-------=[-]=---------"
"--------=[-]=--------"
"---------=[-]=-------"
"----------=[-]=------"
"-----------=[-]=-----"
"------------=[-]=----"
"-------------=[-]=---"
"--------------=[-]=--"
"---------------=[-]=-"
"----------------=[-]="
"-----------------=[-]"
"------------------=["
"-------------------="
"------------------=["
"-----------------=[-]"
"----------------=[-]="
"---------------=[-]=-"
"--------------=[-]=--"
"-------------=[-]=---"
"------------=[-]=----"
"-----------=[-]=-----"
"----------=[-]=------"
"---------=[-]=-------"
"--------=[-]=--------"
"-------=[-]=---------"
"------=[-]=----------"
"-----=[-]=-----------"
"----=[-]=------------"
"---=[-]=-------------"
"--=[-]=--------------"
"-=[-]=---------------"
"=[-]=----------------"
"[-]=-----------------"
"]=------------------"
"=-------------------"
"--------------------");
#==color==
in="\033[1;33m$in\033[0m"
en="\033[1;33m$en\033[0m"
full_in="\033[1;31m$full_in"
full_en="\033[1;32m$full_en\033[0m"

 _=$(
$comando > /dev/null 2>&1
) & > /dev/null
pid=$!
while [[ -d /proc/$pid ]]; do
	for i in "${bar[@]}"; do
		echo -ne "\r $in"
		echo -ne "ESPERE $en $in \033[1;31m$i"
		echo -ne " $en"
		sleep 0.1
	done
done
echo -e " $full_in $full_en"
sleep 0.1s
}



add_user(){
config="/usr/local/etc/trojan/config.json"
temp="/etc/trojan/temp.json"
trojdir="/etc/trojan" && [[ ! -d $trojdir ]] && mkdir $trojdir
user_conf="/etc/trojan/user" && [[ ! -e $user_conf ]] && touch $user_conf
backdir="/etc/trojan/back" && [[ ! -d ${backdir} ]] && mkdir ${backdir}
tmpdir="$backdir/tmp"
[[ ! -e $trojdir/conf ]] && echo "autBackup 0" > $trojdir/conf
if [[ $(cat $trojdir/conf | grep "autBackup") = "" ]]; then
	echo "autBackup 0" >> $trojdir/conf
fi
barra="\033[0;31m=====================================================\033[0m"
numero='^[0-9]+$'
hora=$(printf '%(%H:%M:%S)T') 
fecha=$(printf '%(%D)T')

	unset seg
	seg=$(date +%s)
	while :
	do
	clear
	nick="$(cat $config | grep ',"')"
	users="$(echo $nick|sed -e 's/[^a-z0-9 -]//ig')"
	title "		CREAR USUARIO Trojan"
	userDat
	n=1
	for i in $users
	do
		unset DateExp
		unset seg_exp
		unset exp

		[[ $i = "vps-freenet" ]] && {
			n=0
			i="Administrador"
			a='◈'
			DateExp=" indefinido"
			col "$a)" "$i" "$DateExp"
			
		} || {
		
			DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
			seg_exp=$(date +%s --date="$DateExp")
			exp="[$(($(($seg_exp - $seg)) / 86400))]"
			col "$n)" "$i" "$DateExp" "$exp"
			}
		
		let n++
	done
	msg -bar
	col "0)" "VOLVER"
	msg -bar
	blanco "Ingresa Nombre de USUARIO :" 0
	read usser
	usser=$(echo ${usser} |sed -e's/[^0-9a-z]//ig')
	[[ -z $usser ]] && vacio && sleep 0.3 && continue
	[[ $usser = 0 ]] && return
	[[ -z $(echo "$users" | grep $usser) ]] && {
	opcion=$usser 
	msg -bar
	blanco "DURACION EN DIAS" 0
	read dias
	dias=$(echo ${dias} |sed -e's/[^0-9]//ig')
	espacios=$(echo "$opcion" | tr -d '[[:space:]]')
	opcion=$espacios
	mv $config $temp
	movetm=$(echo -e "$opcion" | sed 's/^/,"/;s/$/"/')
	sed "10i\        $movetm" $temp > $config
	#echo -e "$opcion" | sed 's/^/,"/;s/$/"/'
	#$(date '+%d-%b-%y' -d " + $DIAS days")
	#sed -i "/usser/d" $user_conf
	echo "$opcion | $usser | $(date '+%d-%b-%y' -d " +$dias days")" >> $user_conf
	chmod 777 $config
	rm $temp
	clear
	msg -bar
	blanco "	Usuario $usser creado con exito"
	msg -bar
	autoDel
	restroj
	} || echo " USUARIO YA EXISTE " && sleep 0.5s
    done
}

renew(){
	while :
	do
		unset user
		clear
		title "		RENOVAR USUARIOS"
		userDat
		userEpx=$(cut -d " " -f1 $user_conf)
		n=1
		for i in $userEpx
		do
			DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
			seg_exp=$(date +%s --date="$DateExp")
			[[ "$seg" -gt "$seg_exp" ]] && {
				col "$n)" "$i" "$DateExp" "\033[0;31m[Exp]"
				uid[$n]="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f2|tr -d '[[:space:]]')"
				user[$n]=$i
				let n++
			}
		done
		[[ -z ${user[1]} ]] && blanco "		No hay expirados"
		msg -bar
		col "0)" "VOLVER"
		msg -bar
		blanco "NUMERO DE USUARIO A RENOVAR" 0
		read opcion

		[[ -z $opcion ]] && vacio && sleep 0.3 && continue
		[[ $opcion = 0 ]] && return

		[[ ! $opcion =~ $numero ]] && {
			blanco " solo numeros apartir de 1"
			sleep 0.3
		} || {
			[[ $opcion>=${n} ]] && {
				let n--
				blanco "solo numero entre 1 y $n"
				sleep 0.3
		} || {
			blanco "DURACION EN DIAS" 0
			read dias
			mv $config $temp
			movetm=$(echo -e "${user[$opcion]}" | sed 's/^/,"/;s/$/"/')
			sed "10i\        $movetm" $temp > $config
			sed -i "/${user[$opcion]}/d" $user_conf
			echo "${user[$opcion]} | ${user[$opcion]} | $(date '+%d-%b-%y' -d " +$dias days")" >> $user_conf
			chmod 777 $config
			rm -f $temp
			clear
			msg -bar
			blanco "	Usuario > ${user[$opcion]} renovado hasta $(date '+%d-%b-%y' -d " +$dias days")"
			sleep 5s
		  }
		}
	done
restroj
continuar
read foo
}




autoDel(){
clear
config="/usr/local/etc/trojan/config.json"
temp="/etc/trojan/temp.json"
trojdir="/etc/trojan" && [[ ! -d $trojdir ]] && mkdir $trojdir
user_conf="/etc/trojan/user" && [[ ! -e $user_conf ]] && touch $user_conf
backdir="/etc/trojan/back" && [[ ! -d ${backdir} ]] && mkdir ${backdir}
tmpdir="$backdir/tmp"
[[ ! -e $trojdir/conf ]] && echo "autBackup 0" > $trojdir/conf
if [[ $(cat $trojdir/conf | grep "autBackup") = "" ]]; then
	echo "autBackup 0" >> $trojdir/conf
fi
barra="\033[0;31m=====================================================\033[0m"
numero='^[0-9]+$'
hora=$(printf '%(%H:%M:%S)T') 
fecha=$(printf '%(%D)T')
	seg=$(date +%s)
	while :
	do
		unset users
		nick="$(cat $config | grep ',"')"
		users="$(echo $nick|sed -e 's/[^a-z0-9 -]//ig')"
		n=0
		for i in $users
		do
			[[ ! $i = null ]] && {
				DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
				seg_exp=$(date +%s --date="$DateExp")
				[[ "$seg" -ge "$seg_exp" ]] && {
					mv $config $temp
					sed "/$i/ d" $temp > $config
					echo "Usuario eliminado $i" >> trojan-log
					chmod 777 $config
					killall trojan
					screen -dmS trojanserv trojan /usr/local/etc/trojan/config.json
				}
			}
			let n++
			done
			break
		done
		
	}


[[ $1 = "autoDel" ]] && {
	autoDel
} || {
	autoDel
	}
	
dell_user(){
	unset seg
	seg=$(date +%s)
	while :
	do
	clear
	nick="$(cat $config | grep ',"')"
	users="$(echo $nick|sed -e 's/[^a-z0-9 -]//ig')"
	title "	ELIMINAR USUARIO TROJAN"
	userDat
	n=1
	for i in $users
	do
		userd[$n]=$i
		unset DateExp
		unset seg_exp
		unset exp
		[[ $i = "vps-freenet" ]] && {
			i="default"
			a='◈'
			DateExp=" unlimited"
			col "$a)" "$i" "$DateExp"
		} || {
				
			DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
			seg_exp=$(date +%s --date="$DateExp")
			exp="[$(($(($seg_exp - $seg)) / 86400))]"
			col "$n)" "$i" "$DateExp" "$exp"
			}
		
		p=$n
		let n++
	done
	userEpx=$(cut -d " " -f 1 $user_conf)
	for i in $userEpx
	do	
		DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
		seg_exp=$(date +%s --date="$DateExp")
		[[ "$seg" -gt "$seg_exp" ]] && {
			col "$n)" "$i" "$DateExp" "\033[0;31m[Exp]"
			expUser[$n]=$i
		}
		let n++
	done
	msg -bar
	col "0)" "VOLVER"
	msg -bar
	blanco "NUMERO DE USUARIO A ELIMINAR" 0
	read opcion
	[[ -z $opcion ]] && vacio && sleep 0.3 && continue
	[[ $opcion = 0 ]] && break

	[[ ! $opcion =~ $numero ]] && {
		blanco " solo numeros apartir de 1"
		sleep 0.3
	} || {
		let n--
		[[ $opcion>=${n} ]] && {
			blanco "solo numero entre 1 y $n"
			sleep 0.3
		} || {
			
			[[ $opcion>=${p} ]] && {
			sed -i "/${expUser[$opcion]}/d" $user_conf
			} || {
			mv $config $temp 
			sed -i "/${expUser[$opcion]}/d" $user_conf
			sed -i "/${userd[$opcion]}/ d" $temp > $config
			chmod 777 $config
			rm $temp
			clear
			msg -bar
			blanco "	Usuario ${userd[$opcion]}${expUser[$opcion]} eliminado"
			msg -bar
			sleep 0.5s
			}
		}
	
	}
	done
	restroj
}

bakc() {
clear
	while :
	do
	clear
		#col "5)" "\033[1;33mCONFIGURAR Trojan"
		msg -bar
		col "1)" "\033[1;33mRestaurar Copia"
		msg -bar
		col "2)" "\033[1;33mCrear Copia"
		msg -bar
		col "0)" "SALIR \033[0;31m|| $(blanco "Respaldos automaticos") $(on_off_res)"
		msg -bar
		blanco "opcion" 0
		read opcion
		case $opcion in
			1)[[ -e config.json ]] && cp config.json /usr/local/etc/trojan/config.json || echo "No existe Copia";;
			2)[[ -e /usr/local/etc/trojan/config.json ]] && cp /usr/local/etc/trojan/config.json config.json || echo "No existe Copia";;
			0) return;;
			*) blanco "\n selecione una opcion del 0 al 2" && sleep 0.3;;
		esac
	done


}

reintro() {
clear
	while :
	do
	clear
		#col "5)" "\033[1;33mCONFIGURAR Trojan"
		msg -bar
		col "1)" "\033[1;33mReinstalar Servicio"
		msg -bar
		col "2)" "\033[1;33mReiniciar Servicio"
		msg -bar
		col "3)" "\033[1;33mEditar Manual ( nano )"
		msg -bar
		col "4)" "\033[1;33mREGISTRAR DOMINIO "
		msg -bar
		col "0)" "SALIR \033[0;31m|| $(blanco "Respaldos automaticos") $(on_off_res)"
		msg -bar
		blanco "opcion" 0
		read opcion
		case $opcion in
			1)
			main
			;;
			2)
			[[ -e /usr/local/etc/trojan/config.json ]] && {
			title "Fichero Interno Configurado"
			restroj
			} || echo -e  "Servicio No instalado Aun"
			;;
			3)
			nano /usr/local/etc/trojan/config.json
			;;
			4)
			dmn=$(echo "$(ls /root/.acme.sh | grep '_ecc')" | sed 's/_ecc//')
			echo -e " INGRESA TU DOMINIO REGISTRADO EN TU CERTIFICADO "
			echo -e "                +    OJO     +"
			echo -e "  Si validaste tu certificado con dominio ACME"
			echo -e "        Se tomara tu dominio automatico"
			read -p " DIGITA TU DOMINIO : " -e -i $dmn domain
			echo "$domain" > /etc/vps-freenet/trojancert/domain
			;;
			0) return;;
			*) blanco "\n selecione una opcion del 0 al 3" && sleep 0.3;;
		esac
	done


continuar
read foo
}

cattro () {

clear
	while :
	do
	clear
		#col "5)" "\033[1;33mCONFIGURAR Trojan"
		msg -bar
		col "1)" "\033[1;33mMostrar fichero de CONFIG "
		msg -bar
		col "2)" "\033[1;33mEditar Config Manual ( Comando nano )"
		msg -bar
		col "3)" "\033[1;33m Cambiar RUTA CERTIFICADO"
		msg -bar
		col "4)" "\033[1;33m CAMBIAR SNI INTERNO"
		msg -bar
		col "0)" "SALIR \033[0;31m|| $(blanco "Respaldos automaticos") $(on_off_res)"
		msg -bar
		blanco "opcion" 0
		read opcion
		case $opcion in
			1)
			title "Fichero Interno Configurado"
			cat /usr/local/etc/trojan/config.json
			blanco "Fin Fichero "
			continuar
			read foo
			;;
			2)
			[[ -e /usr/local/etc/trojan/config.json ]] && {
			title "Fichero Interno Configurado"
			nano /usr/local/etc/trojan/config.json
			restroj
			} || echo -e  "Servicio No instalado Aun"
			;;
			3)
			changeCERT
			restroj
			;;
			4)
			changeSNI
			restroj
			;;
			0) return;;
			*) blanco "\n selecione una opcion del 0 al 2" && sleep 0.3;;
		esac
	done
continuar
}

view_user(){
trojanport=`lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN" | grep trojan | awk '{print substr($9,3); }' > /tmp/trojan.txt && echo | cat /tmp/trojan.txt | tr '\n' ' ' > /etc/vps-freenet/trojanports.txt && cat /etc/vps-freenet/trojanports.txt`;
trojanport=$(cat /etc/vps-freenet/trojanports.txt  | sed 's/\s\+/,/g' | cut -d , -f1)
	unset seg
	seg=$(date +%s)
	while :
	do

		clear
	nick="$(cat $config | grep ',"')"
	users="$(echo $nick|sed -e 's/[^a-z0-9 -]//ig')"
		title "	VER USUARIO TROJAN"
		userDat

		n=1
		for i in $users
		do
			unset DateExp
			unset seg_exp
			unset exp
		
		[[ $i = "vps-freenet" ]] && {
			i="Admin"
			DateExp=" ilimitado"
		} || {
				DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
				seg_exp=$(date +%s --date="$DateExp")
				exp="[$(($(($seg_exp - $seg)) / 86400))]"
			
			}

			col "$n)" "$i" "$DateExp" "$exp"
			let n++
		done
		msg -bar
		col "0)" "VOLVER"
		msg -bar
		blanco "VER DATOS DEL USUARIO" 0
		read opcion
		[[ -z $opcion ]] && vacio && sleep 0.3 && continue
		[[ $opcion = 0 ]] && return
		n=1
		unset i
		for i in $users
		do
			unset DateExp
			unset seg_exp
			unset exp
				DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
				seg_exp=$(date +%s --date="$DateExp")
				exp="[$(($(($seg_exp - $seg)) / 86400))]"
			#col "$n)" "$i" "$DateExp" "$exp"
		[[ $n = $opcion ]] && trojanpass=$i && dataEX=$DateExp && dEX=$exp
				let n++
		done
		let opcion--
		addip=$IP
		host=$(cat /usr/local/etc/trojan/config.json | jq -r .ssl.sni)
		[[ $host = null ]] && read -p " Host / SNI : " host
		[[ -z $host ]] && host="null"
		clear&&clear
		blanco $barra
		blanco "              TROJAN LINK CONFIG"
		blanco $barra
		col "$opcion)" "$trojanpass" "$dataEX" "$dEX"
		trojan_conf
		blanco $barra
		continuar
		read foo
	done
}

trojan_conf (){
[[ -e /etc/vps-freenet/trojancert/domain ]] && domain=$(cat < /etc/vps-freenet/trojancert/domain)
		msg -bar
		col2 " Remarks   : " "$trojanpass"
		[[ -z $domain ]] || col2 " DOMAIN    : " "$domain"
		col2 " IP-Address: " "$addip"
		col2 " Port      : " "$trojanport"
		col2 " Password  : " "$trojanpass"
		[[ $(cat $config | jq -r .websocket.enabled) = "true" ]] && col2 " NetWork   : " "WS/TCP" || col2 " NetWork   : " "TCP"
		[[ ! -z $host ]] && col2 " Host/SNI  : " "$host"
		msg -bar3
		echo " CONFIG TCP NATIVA"
		echo -e "\033[3;32m trojan://$(echo $trojanpass@$addip:$trojanport?sni=$host#$trojanpass )\033[3;32m"
		msg -bar3
		echo -ne "$(msg -verd "") $(msg -verm2 " ") "&& msg -bra "\033[1;41mEn APPS como HTTP Inyector,CUSTOM,Trojan,etc"
		[[ $(cat $config | jq -r .websocket.enabled) = "true" ]] && echo -e "\033[3;32m trojan://$trojanpass@$IP:$trojanport?path=%2F&security=tls&type=ws&sni=$host\033[3;32m" || echo -e "\033[3;32m trojan://$(echo $trojanpass@$addip:$trojanport?sni=$host#$trojanpass )\033[3;32m"
		msg -bar
		[[ -z $domain ]] || echo -e "\033[3;32m trojan://$(echo $trojanpass@$domain:$trojanport?sni=$host#$trojanpass )\033[3;32m"

}

main(){
	[[ ! -e $config ]] && {
		clear
		msg -bar
		blanco " No se encontro ningun archovo de configracion Trojan"
		msg -bar
		blanco "	  No instalo Trojan o esta usando\n	     una vercion diferente!!!"
		msg -bar
		echo -e "		\033[4;31mNOTA importante\033[0m"
		echo -e " \033[0;31mSi esta usando una vercion Trojan diferente"
		echo -e " y opta por cuntinuar usando este script."
		echo -e " Este puede; no funcionar correctamente"
		echo -e " y causar problemas en futuras instalaciones.\033[0m"
		msg -bar
		continuar
		read foo
		trojanin
	}
	while :
	do
		_usor=$(printf '%-8s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")
		_usop=$(printf '%-1s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
		#[[ -e /bin/troj.sh ]] && enrap="\033[1;92m[Encendido]" || enrap="\033[0;31m[Apagado]"
		clear
		title2
		title "   Ram: \033[1;32m$_usor  \033[0;31m<<< \033[1;37mMENU Trojan \033[0;31m>>>  \033[1;37mCPU: \033[1;32m$_usop"
		col "1)" "CREAR USUARIO "
		col "2)" "\033[1;92mRENOVAR USUARIO "
		col "3)" "\033[1;31mREMOVER USUARIO "
		col "4)" "VER DATOS DE USUARIOS "
		col "5)" "VER USUARIOS CONECTADOS "
		#col "5)" "\033[1;33mCONFIGURAR Trojan"
		msg -bar
		col "6)" "\033[1;37mRECONSTRUIR CONFIG"
		#col "6)" "\033[1;33mEntrada Rapida $enrap"
		msg -bar
		col "7)" "\033[1;33mMostrar/Editar Fichero interno"
		col "8)" "\033[1;33mMenu Avanzado Trojan"
		col "9)" "\033[1;33mConf. Copias de Respaldo"
		#col "10)" "\033[1;33mVer tráfico"
	col "10)" "\033[1;33mDESINSTALAR SCRIPT"
	
		msg -bar
		col "0)" "SALIR \033[0;31m|| $(blanco "Respaldos automaticos") $(on_off_res)"
		msg -bar
		blanco "opcion" 0
		read opcion

		case $opcion in
			1)add_user;;
			2)renew;;
			3)dell_user;;
			4)view_user;;
			5)log_traff;;
			#6)enttrada;;
			7)cattro;;
			8)reintro;;
			9)backups;;
			#10)log_traff;;
			10)
source <(curl -sL https://git.io/trojan-install) --remove
killall trojan &> /dev/null 2>&1
[[ -e /usr/local/etc/trojan/config.json ]] && rm -f /usr/local/etc/trojan /usr/local/etc/trojan/config.json
[[ -e /bin/troj.sh ]] && rm -rf /bin/troj.sh
rm -rf /etc/vps-freenet/trojancert
rm -rf /etc/trojan/user
clear
echo -e "\033[1;37m  Desinstalacion Completa \033[0m"
;;
6)
clear
msg -ama "	RECONFIGURANDO CONFIG"
cp /etc/vps-freenet/tmp/trojan.json /usr/local/etc/trojan/config.json 
chmod 777 /usr/local/etc/trojan/config.json
killall trojanserv &>/dev/null
rm -rf /etc/trojan/user
screen -dmS trojanserv trojan /usr/local/etc/trojan/config.json && echo -e "\033[1;32m Iniciando Trojan Server" || echo -e "\033[1;32m Error al Iniciar TROJAN"
return 0
;;
			0) break;;
			*) blanco "\n selecione una opcion del 0 al 10" && sleep 0.3s;;
		esac
	done
}


	main

}

trojanin(){
clear
troport () {
clear
msg -tit
echo -e "[\033[1;31m-\033[1;33m]\033[1;31m \033[1;33m"
echo -e "\033[1;33m Escriba el puerto de Trojan Server"
read -p ": " trojanport
sed -i 's/443/'$trojanport'/g' /usr/local/etc/trojan/config.json
echo -e "\033[1;33m Escriba el password de Trojan Server"
read -p ": " trojanpass
sed -i 's/passtrojan/'$trojanpass'/g' /usr/local/etc/trojan/config.json
echo -e "\033[1;32mÎ” Iniciando Trojan Server"
unset bot_ini
PIDGEN=$(ps x|grep -v grep|grep "/usr/local/etc/trojan/config.json")
if [[ ! $PIDGEN ]]; then
	msg -bar
	echo -ne "\033[1;97m Poner en linea despues de un reinicio [s/n]: "
	read bot_ini
	msg -bar
[[ $bot_ini = @(s|S|y|Y) ]] && {
crontab -l > /root/cron
echo "@reboot screen -dmS trojanserv trojan /usr/local/etc/trojan/config.json " >> /root/cron
crontab /root/cron
rm /root/cron
} || {
killall trojanserv > /dev/null 2>&1
crontab -l > /root/cron
sed -i '/trojanserv/ d' /root/cron
crontab /root/cron
rm /root/cron
}
screen -dmS trojanserv trojan /usr/local/etc/trojan/config.json && echo -e "\033[1;32mÎ” Iniciando Trojan Server" || echo -e "\033[1;32mÎ” Error al Iniciar TROJAN"
else
killall trojan
fi
clear
msg -tit

echo -e "[\033[1;31m-\033[1;33m]\033[1;31m \033[1;33m"
echo -e "\033[1;33m                  Trojan Server Instalado"
echo -ne "$(msg -verd "") $(msg -verm2 " ") "&& msg -bra "\033[1;41mEn APPS como HTTP Inyector,CUSTOM,Trojan,etc"
echo -ne "$(msg -verd "") $(msg -verm2 "LINK : ") "&& msg -bra "\033[1;41m $trojanpass@$IP:$trojanport?sni=$host#$trojanpass"
echo -e "\033[1;33mEl puerto del servidor es: \033[1;32m $trojanport"
echo -e "\033[1;33mEl password del servidor es: \033[1;32m $trojanpass"
echo -e "Remarks:" "$trojanpass"
echo -e "IP-Address:" "$IP"
echo -e "Port:" "$trojanport"
echo -e "password:" "$trojanpass"
echo -ne "$(msg -verd "") $(msg -verm2 "LINK : ") "&& msg -bra "\033[1;41m trojan://vps-freenet@$IP:$trojanport"
echo -e "\033[1;33mSi necesitas cambiar el password edita el archivo o Ve a Menu de Control"
echo -e "\033[1;32mRuta de Configuracion: /usr/local/etc/trojan/config.json"
read -p " Enter para continuar"
}

troman(){
clear
[[ -d /etc/vps-freenet/trojancert ]] && rm -rf /etc/vps-freenet/trojancert
mkdir /etc/vps-freenet/trojancert 1> /dev/null 2> /dev/null
cat << TROJ > /usr/local/etc/trojan/config.json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "passtrojan"
        ,"vps-freenet"
    ],
    "log_level": 1,
    "ssl": {
        "cert":"/data/cert.crt",
        "key":"/data/cert.key",
        "key_password": "",
        "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "alpn_port_override": {
            "h2": 81
        },
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "prefer_ipv4": false,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": true,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "",
        "key": "",
        "cert": "",
        "ca": ""
    },
        "websocket": {
        "enabled": true,
        "path": "/vpsfreenet",
        "hostname": "0.0.0.0"
    },
        "mux": {
        "enabled": true
    }
}

TROJ

#wget -q -O /usr/local/etc/trojan/config.json https://www.dropbox.com/s/1c3k94q4raquisu/config.json 1> /dev/null 2> /dev/null
openssl genrsa 2048 > /etc/vps-freenet/trojancert/trojan.key
chmod 400 /etc/vps-freenet/trojancert/trojan.key
openssl req -new -x509 -nodes -sha256 -days 365 -key /etc/vps-freenet/trojancert/trojan.key -out /etc/vps-freenet/trojancert/trojan.crt
clear
echo -ne " \033[1;31m[ ! ] GENERANDO Certificado TROJAN" # Generate CA Config
(
sed -i '13i        "cert":"/etc/vps-freenet/trojancert/trojan.crt",' /usr/local/etc/trojan/config.json
sed -i '14i        "key":"/etc/vps-freenet/trojancert/trojan.key",' /usr/local/etc/trojan/config.json
) && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
cp /usr/local/etc/trojan/config.json /etc/vps-freenet/tmp/trojan.json
echo -e "CERTIFICADO GENERADO EXITOSAMENTE"
}

troauto() {
clear
echo -ne " \033[1;31m[ ! ] GENERANDO Certificado TROJAN" # Generate CA Config
(
[[ -d /etc/vps-freenet/trojancert ]] && rm -rf /etc/vps-freenet/trojancert
mkdir /etc/vps-freenet/trojancert 1> /dev/null 2> /dev/null
cat << TROJ > /usr/local/etc/trojan/config.json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "passtrojan"
        ,"vps-freenet"
    ],
    "log_level": 1,
    "ssl": {
        "cert":"/data/cert.crt",
        "key":"/data/cert.key",
        "key_password": "",
        "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "alpn_port_override": {
            "h2": 81
        },
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "prefer_ipv4": false,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": true,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "",
        "key": "",
        "cert": "",
        "ca": ""
    },
        "websocket": {
        "enabled": true,
        "path": "/vpsfreenet",
        "hostname": "0.0.0.0"
    },
        "mux": {
        "enabled": true
    }
}
TROJ
#wget -q -O /usr/local/etc/trojan/config.json https://www.dropbox.com/s/1c3k94q4raquisu/config.json 1> /dev/null 2> /dev/null
openssl genrsa -out /etc/vps-freenet/trojancert/trojan.key 2048 > /dev/null 2>&1
chmod 400 /etc/vps-freenet/trojancert/trojan.key > /dev/null 2>&1
(echo "$(curl -sSL ipinfo.io > info && cat info | grep country | awk '{print $2}' | sed -e 's/[^a-z0-9 -]//ig')"; echo ""; echo "$IP:81"; echo ""; echo ""; echo ""; echo "@vps-freenet")|openssl req -new -x509 -nodes -sha256 -days 365 -key /etc/vps-freenet/trojancert/trojan.key -out /etc/vps-freenet/trojancert/trojan.crt > /dev/null 2>&1
#echo -e "\033[1;37mÎ” Generando Configuracion"
sed -i '13i        "cert":"/etc/vps-freenet/trojancert/trojan.crt",' /usr/local/etc/trojan/config.json
sed -i '14i        "key":"/etc/vps-freenet/trojancert/trojan.key",' /usr/local/etc/trojan/config.json
cd $HOME
) && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
echo -e "CERTIFICADO GENERADO EXITOSAMENTE"
cp /usr/local/etc/trojan/config.json /etc/vps-freenet/tmp/trojan.json
#fun_bar
}


[[ -e /etc/vps-freenet/message.txt ]] && nomkey="$(cat < /etc/vps-freenet/message.txt)"
IP=$(wget -qO- ifconfig.me)

fun_ip () {
MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" || IP="$MEU_IP"
}

insta_tro () {
clear
killall trojan
bash -c "$(wget -O- https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)" 
clear
}

msg -tit

#echo -e "[\033[1;31m-\033[1;33m]\033[1;30m =======================================\033[1;33m"
echo -e "\033[1;37m ∆ Linux Dist:	$distribution › Version: $os_version\033[0m"
msg -bar
#echo -e "[\033[1;31m-\033[1;33m]\033[1;30m =======================================\033[1;33m"
echo -e "\033[1;37m - INSTALADOR TROJAN   \033[0m"
echo -e "\033[1;33m Se instalara¡ el servidor de Trojan\033[0m"
echo -e "\033[1;33m Si ya tenias una instalacion Previa, esta se eliminara\033[0m"
echo -e "\033[1;33m Debes tener instalado previamente GO Lang\033[0m"
msg -bar
[[ -d /usr/local/go ]] && {
echo -e "\033[1;33m Go Lang Instalado" 
} || { 
echo " go lang no instalado"
goinst
}
echo -e "\033[1;33m IMPORTANTE DEBES TENER LIBRES PUERTOS 80 / 443\033[0m"
echo -e "\033[1;33m Continuar?\033[0m"
while [[ ${yesno} != @(s|S|y|Y|n|N) ]]; do
read -p "[S/N]: " yesno
tput cuu1 && tput dl1
done
if [[ ${yesno} = @(s|S|y|Y) ]]; then

echo -e " Generando Certificados SSL"


menutro () {
clear
msg -tit
while [[ ${varread} != @([0-3]) ]]; do
echo -e "Bienvenido a TROJAN\n \033[1;36mLee detenidamente las indicaciones antes de continuar  \n 1).- Certificado Automatico\n 2).- Crear Certificado MANUAL\n 3).- Menu Administrativo Trojan\n"  
echo -ne "$BARRA"
read -p " Selecione una opcion: "  varread
done
echo -e "$BARRA"
if [[ ${varread} = 0 ]]; then
return 0
elif [[ ${varread} = 1 ]]; then
insta_tro
troauto
troport
elif [[ ${varread} = 2 ]]; then
insta_tro
troman
troport
elif [[ ${varread} = 3 ]]; then
trojango
return 0
fi
}
fi
fun_ip
menutro
}

goinst(){
clear
echo -e "A continuacion se instalara el paquete GO Lang"
msg -bar 
echo -e "     \033[41m-- SISTEMA ACTUAL $(lsb_release -si) $(lsb_release -sr) --"
msg -bar 
apt install golang -y
cd $HOME
echo "DESACIENDO DIRECTORIOS EXISTENTES" && rm -rf /usr/local/go 1> /dev/null 2> /dev/null
echo "Buscando paquete mas Actual" && sudo curl -O https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz  # Descargar el archivo. Cambie el nombre del archivo si necesita otra versión de Go o otra arquitectura# https://golang.org/dl/go1.17.3.linux-amd64.tar.gz
echo -ne "Descomprimiendo Ultimo paquete Descargado"
sudo tar -xvf go1.9.linux-amd64.tar.gz > /dev/null && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
sudo mv go /usr/local  # Desplazar los binarios hacia /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile  # Se actualiza su perfil bash para que Go este en el PATH
sleep 0.5s
echo -e "Reiniciando Fuente de Terminal..."
rm -f go1.9.linux-amd64.tar.*
source ~/.profile
}
trojango