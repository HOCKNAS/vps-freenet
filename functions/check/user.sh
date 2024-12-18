l="/usr/local/lib/sped" && [[ ! -d ${l} ]] && exit
clear
clear

# Colores declarados
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m" )

# Directorios principales
SCPdir="/etc/vps-freenet"
SCPfrm="${SCPdir}/herramientas" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="${SCPdir}/protocolos" && [[ ! -d ${SCPinst} ]] && exit

# Obtener IP del servidor
chk_ip=$(wget -qO- ifconfig.me)

# Mostrar los puertos activos
mportas(){
    unset portas
    portas_var=$(lsof -V -i -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND")
    while read port; do
        var1=$(echo $port | awk '{print $1}')
        var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
        [[ "$(echo -e $portas | grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
    done <<< "$portas_var"
    echo -e "$portas"
}

# Encabezado del menu
title(){
    clear
    msg -bar
    if [[ -z $2 ]]; then
        print_center -azu "$1"
    else
        print_center "$1" "$2"
    fi
    msg -bar
}

# Opcion volver
back(){
    msg -bar
    echo -ne "$(msg -verd " [0]") $(msg -verm2 ">") " && msg -bra "\033[1;41mVOLVER"
    msg -bar
}

# Seleccion de opciones
selection_fun () {
    local selection="null"
    local range
    for((i=0; i<=$1; i++)); do range[$i]="$i "; done
    while [[ ! $(echo ${range[*]} | grep -w "$selection") ]]; do
        echo -ne "\033[1;37m$(fun_trans " ► Selecione una Opcion"): " >&2
        read selection
        tput cuu1 >&2 && tput dl1 >&2
    done
    echo $selection
}

# Solicitar entrada
in_opcion(){
    unset opcion
    if [[ -z $2 ]]; then
        msg -azu " $1: " >&2
    else
        msg $1 " $2: " >&2
    fi
    read opcion
}

# Imprimir texto centrado
print_center(){
    if [[ -z $2 ]]; then
        text="$1"
    else
        col="$1"
        text="$2"
    fi
    while read line; do
        unset space
        x=$(( ( 54 - ${#line}) / 2))
        for (( i = 0; i < $x; i++ )); do
            space+=' '
        done
        space+="$line"
        if [[ -z $2 ]]; then
            msg -azu "$space"
        else
            msg "$col" "$space"
        fi
    done <<< $(echo -e "$text")
}

# Menu de opciones
menu_func(){
    local options=${#@}
    local array
    for((num=1; num<=$options; num++)); do
        echo -ne "$(msg -verd " [$num]") $(msg -verm2 ">") "
        array=(${!num})
        case ${array[0]} in
            "-vd")echo -e "\033[1;33m[!]\033[1;32m ${array[@]:1}";;
            "-vm")echo -e "\033[1;33m[!]\033[1;31m ${array[@]:1}";;
            "-fi")echo -e "${array[@]:2} ${array[1]}";;
            *)echo -e "\033[1;37m${array[@]}";;
        esac
    done
}

# Iniciar servicio
start(){
    if [[ $(systemctl is-active chekuser) = "active" ]]; then
        msg -azu "DESABILITANDO CHEKUSER"
        systemctl stop chekuser &>/dev/null
        systemctl disable chekuser &>/dev/null
        rm -rf /etc/systemd/system/chekuser.service
        msg -verd 'chekuser, se desactivo con exito!'
        return
    fi

    while true; do
        echo -ne "\033[1;37m"
        read -p " INGRESE UN PUERTO: " chekuser
        echo ""
        [[ $(mportas | grep -w "$chekuser") ]] || break
        echo -e "\033[1;33m Este puerto está en uso"
        unset chekuser
    done
    echo " $(msg -ama "Puerto") $(msg -verd "$chekuser")"

    print_center 'SELECCIONA UN FORMATO DE FECHA'
    msg -bar
    menu_func 'YYYY/MM/DD' 'DD/MM/YYYY'
    msg -bar
    date=$(selection_fun 2)
    case $date in
        1) fecha="YYYY/MM/DD";;
        2) fecha="DD/MM/YYYY";;
    esac
    [[ $date = 0 ]] && return
    del 5
    echo " $(msg -ama "Formato") $(msg -verd "$fecha")"

    print_center -ama 'Instalando python3-pip'
    if apt install -y python3-pip &>/dev/null; then
        print_center -verd 'Instalacion de python3-pip exitosa'
    else
        print_center -verm2 'Falla al instalar python3-pip'
        return
    fi

    print_center -ama 'Instalando flask'
    if pip3 install flask &>/dev/null; then
        print_center -verd 'Instalacion de flask exitosa'
    else
        print_center -verm2 'Falla al instalar flask'
        return
    fi

    echo -e "[Unit]\nDescription=chekuser Service\nAfter=network.target\n[Service]\nExecStart=/usr/bin/python3 /etc/vps-freenet/protocolos/chekuser.py $chekuser $date\nRestart=always\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/chekuser.service
    
    systemctl enable chekuser &>/dev/null
    systemctl start chekuser &>/dev/null

    if [[ $(systemctl is-active chekuser) = "active" ]]; then
        title -verd 'Instalacion completa'
        print_center -ama "URL: http://$chk_ip:$chekuser/checkUser"
    else
        print_center -verm2 'Falla al iniciar servicio chekuser'
    fi
}

# Menu principal
while [[ $? -eq 0 ]]; do
    title 'VERIFICACION DE USUARIOS ONLINE'
    menu_func 'ACTIVAR CHEKUSER' 'MODIFICAR PUERTO' 'SALIR'
    back
    opcion=$(selection_fun 3)
    case $opcion in
        1) start;;
        2) mod_port;;
        0) exit;;
    esac
done