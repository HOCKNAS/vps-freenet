#!/bin/bash

# ==============================================
#        Script de Gestión de Usuarios VPS
#        Compatible con SSH, HWID, y TOKEN
# ==============================================

# === VARIABLES GLOBALES ===
SCPdir="/etc/vps-freenet"
SCPusr="${SCPdir}/controlador"
SCPfrm="${SCPdir}/herramientas"
SCPinst="${SCPdir}/protocolos"
USRdatabase="${SCPdir}/accessuser"
USRdatabaseh="${SCPdir}/User-HWID"
tokens="${SCPdir}/User-TOKEN"

# === VALIDACIONES INICIALES ===
[[ ! -d /usr/local/lib/sped/tools ]] && exit
[[ ! -d /usr/local/include/snaps ]] && exit
[[ ! -d ${SCPfrm} ]] && exit
[[ ! -d ${SCPinst} ]] && exit

clear
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/"

# === FUNCIONES AUXILIARES ===

# Función para traducción automática
fun_trans() { 
  local LINGUAGE=$(cat ${SCPdir}/idioma 2>/dev/null || echo "es")
  [[ -z $LINGUAGE ]] && LINGUAGE=es
  [[ $LINGUAGE = "es" ]] && echo "$@" && return
  source /etc/vps-freenet/texto-es
  if [[ -z "$(echo ${texto[$@]})" ]]; then
    retorno="$(source trans -e bing -b es:${LINGUAGE} "$@" | sed -e 's/[^a-z0-9 -]//ig' 2>/dev/null)"
    echo "texto[$@]='$retorno'" >> /etc/vps-freenet/texto-es
    echo "$retorno"
  else
    echo "${texto[$@]}"
  fi
}

# Función para obtener IP pública
meu_ip () {
  MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
  MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
  [[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" || IP="$MEU_IP"
  echo "$MEU_IP2" > /bin/IPca
  echo "$IP"
}

# === GESTIÓN DE USUARIOS ===

# Agregar Usuario SSH
add_user() {
  local username=$1
  local password=$2
  local days=$3
  local limit=$4
  local valid=$(date '+%C%y-%m-%d' -d " +$days days")

  if useradd -M -s /bin/false -e ${valid} -K PASS_MAX_DAYS=$days -p $(openssl passwd -1 $password) -c sshm,$days $username; then
    echo "$username $valid $limit" >> ${USRdatabase}
    echo -e "\nUsuario SSH Creado:"
    echo -e "  ► Usuario: $username"
    echo -e "  ► Contraseña: $password"
    echo -e "  ► Expira: $(date "+%F" -d " + $days days")"
    echo -e "  ► Límite: $limit"
  else
    echo "Error: No se pudo crear el usuario."
  fi
}

# Bloquear Usuario
block_user() {
  local username=$1
  pkill -u $username &>/dev/null
  usermod -L "$username" &>/dev/null
  echo "$username" >> ${USRdatabase}/vps-userlock
  echo "Usuario $username bloqueado."
}

# Eliminar Usuario
delete_user() {
  local username=$1
  userdel --force "$username" &>/dev/null
  sed -i "/$username/d" ${USRdatabase}
  echo "Usuario $username eliminado."
}

# Mostrar Usuarios Activos
show_users() {
  echo -e "Usuarios SSH Activos:\n"
  for user in $(cat /etc/passwd | grep 'home' | grep 'false' | awk -F ':' '{print $1}'); do
    echo "- $user"
  done
}

# Renovar Usuario
renew_user() {
  local username=$1
  local days=$2
  local valid=$(date '+%C%y-%m-%d' -d " +$days days")

  chage -E $valid $username
  echo "Usuario $username renovado. Nueva expiración: $(date "+%F" -d " + $days days")."
}

# === MENÚ PRINCIPAL ===
main_menu() {
  while true; do
    clear
    echo -e "\033[1;32mGestión de Usuarios VPS\033[0m"
    echo -e "  [1] Agregar Usuario SSH"
    echo -e "  [2] Mostrar Usuarios Activos"
    echo -e "  [3] Bloquear Usuario"
    echo -e "  [4] Eliminar Usuario"
    echo -e "  [5] Renovar Usuario"
    echo -e "  [0] Salir"
    read -p "Seleccione una opción: " opt

    case $opt in
      1) 
        read -p "Nombre del usuario: " username
        read -p "Contraseña: " password
        read -p "Días de validez: " days
        read -p "Límite de conexiones: " limit
        add_user $username $password $days $limit
        ;;
      2) show_users ;;
      3) 
        read -p "Nombre del usuario a bloquear: " username
        block_user $username
        ;;
      4) 
        read -p "Nombre del usuario a eliminar: " username
        delete_user $username
        ;;
      5) 
        read -p "Nombre del usuario: " username
        read -p "Nuevos días de validez: " days
        renew_user $username $days
        ;;
      0) exit ;;
      *) echo "Opción inválida." ;;
    esac
    read -p "Presione Enter para continuar..." enter
  done
}

# === INICIO DEL SCRIPT ===
main_menu
