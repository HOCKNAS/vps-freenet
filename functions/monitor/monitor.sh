#!/bin/bash

# Variables iniciales
ll="/usr/local/include/snaps" && [[ ! -d "${ll}" ]] && exit
l="/usr/local/lib/sped" && [[ ! -d "${l}" ]] && exit

# Directorio destino
DIR="/var/www/html"
ARCHIVO="monitor.html"
FECHA=$(date +'%d/%m/%Y %H:%M:%S')

# Función para verificar el estado de un servicio
EstadoServicio() {
    if systemctl --quiet is-active "$1"; then
        echo "<p>Estado del servicio $1 está || <span class='encendido'>ACTIVO</span>.</p>" >> "${DIR}/${ARCHIVO}"
    else
        echo "<p>Estado del servicio $1 está || <span class='detenido'>DESACTIVADO | REINICIANDO</span>.</p>" >> "${DIR}/${ARCHIVO}"
        service "$1" restart &
        
        NOM=$(< /etc/vps-freenet/controlador/nombre.log)
        IDB=$(< /etc/vps-freenet/controlador/IDT.log)
        KEY="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
        URL="https://api.telegram.org/bot$KEY/sendMessage"
        MSG="⚠️ _AVISO DE VPS:_ *$NOM* ⚠️\n❗️ _Protocolo_ *[ $1 ]* _con Fallo_ ❗️ \n🛠 _-- Reiniciando Protocolo_ -- 🛠 "
        curl -s --max-time 10 -d "chat_id=$IDB&disable_web_page_preview=true&parse_mode=markdown&text=$MSG" "$URL"
    fi
}

# Inicio del archivo HTML
cat > "${DIR}/${ARCHIVO}" <<EOF
<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='UTF-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <link rel='stylesheet' href='estilos.css'>
</head>
<body>
<p id='ultact'>Última actualización: ${FECHA}</p>
<hr>
EOF

# Verificación de servicios comunes
EstadoServicio v2ray
EstadoServicio ssh
EstadoServicio dropbear
EstadoServicio stunnel4
EstadoServicio squid || EstadoServicio squid3
EstadoServicio apache2

# Verificación de BADVPN
if pgrep -x badvpn > /dev/null; then
    badvpn="<span class='encendido'>ACTIVO</span>"
else
    badvpn="<span class='detenido'>DESACTIVADO | REINICIANDO</span>"
    screen -dmS badvpn2 /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
fi
echo "<p>Estado del servicio badvpn está || ${badvpn}</p>" >> "${DIR}/${ARCHIVO}"

# Reinicio de servicios Python
ureset_python() {
    while read -r port; do
        if ! pgrep -f "pydic-${port}" > /dev/null; then
            screen -dmS "pydic-${port}" python /etc/vps-freenet/protocolos/python.py "${port}"
            send_telegram "PyDirec: ${port}"
        fi
    done < <(cut -d' ' -f1 /etc/vps-freenet/PortPD.log | grep -v "nobody")
}

ureset_pyssl() {
    while read -r port; do
        if ! pgrep -f "pyssl-${port}" > /dev/null; then
            screen -dmS "pyssl-${port}" python /etc/vps-freenet/protocolos/python.py "${port}"
            send_telegram "PySSL: ${port}"
        fi
    done < <(cut -d' ' -f1 /etc/vps-freenet/PySSL.log | grep -v "nobody")
}

# Función de Telegram centralizada
send_telegram() {
    local PROTOCOLO="$1"
    NOM=$(< /etc/vps-freenet/controlador/nombre.log)
    IDB=$(< /etc/vps-freenet/controlador/IDT.log)
    KEY="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
    URL="https://api.telegram.org/bot${KEY}/sendMessage"
    MSG="⚠️ _AVISO DE VPS:_ *${NOM}* ⚠️\n❗️ _Protocolo_ *[ ${PROTOCOLO} ]* _con Fallo_ ❗️ \n🛠 _-- Reiniciando Protocolo_ -- 🛠 "
    curl -s --max-time 10 -d "chat_id=${IDB}&disable_web_page_preview=true&parse_mode=markdown&text=${MSG}" "${URL}"
}

# Ejecutar funciones
ureset_python
ureset_pyssl

# Finalizar HTML
echo "</body></html>" >> "${DIR}/${ARCHIVO}"
