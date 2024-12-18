ll="/usr/local/include/snaps" && [[ ! -d ${ll} ]] && exit
l="/usr/local/lib/sped" && [[ ! -d ${l} ]] && exit

# Directorio destino
DIR=/var/www/html
# Nombre de archivo HTML a generar
ARCHIVO=monitor.html
# Fecha actual
FECHA=$(date +'%d/%m/%Y %H:%M:%S')

# Declaración de la función EstadoServicio
EstadoServicio () {
    systemctl --quiet is-active $1
    if [ $? -eq 0 ]; then
        echo "<p>Estado del servicio $1 está || <span class='encendido'> ACTIVO</span>.</p>" >> $DIR/$ARCHIVO
    else
        echo "<p>Estado del servicio $1 está || <span class='detenido'> DESACTIVADO | REINICIANDO</span>.</p>" >> $DIR/$ARCHIVO
        service $1 restart &
        
        NOM=$(less /etc/vps-freenet/controlador/nombre.log 2>/dev/null)
        IDB=$(less /etc/vps-freenet/controlador/IDT.log 2>/dev/null)
        KEY="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
        URL="https://api.telegram.org/bot$KEY/sendMessage"
        MSG="⚠️ _AVISO DE VPS:_ *$NOM* ⚠️\n❗️ _Protocolo_ *[ $1 ]* _con Fallo_ ❗️ \n🛠 _-- Reiniciando Protocolo_ -- 🛠 "
        curl -s --max-time 10 -d "chat_id=$IDB&disable_web_page_preview=true&parse_mode=markdown&text=$MSG" $URL
    fi
}

# Inicio del archivo HTML
echo "<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='UTF-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <meta http-equiv='X-UA-Compatible' content='ie=edge'>
  <link rel='stylesheet' href='estilos.css'>
</head>
<body>
<p id='ultact'>Última actualización: $FECHA</p>
<hr>" > $DIR/$ARCHIVO

# Verificación de servicios comunes
EstadoServicio v2ray
EstadoServicio ssh
EstadoServicio dropbear
EstadoServicio stunnel4
[[ $(EstadoServicio squid) ]] && EstadoServicio squid3
EstadoServicio apache2

# Servicio BADVPN
on="<span class='encendido'> ACTIVO "
off="<span class='detenido'> DESACTIVADO | REINICIANDO "
[[ $(ps x | grep badvpn | grep -v grep) ]] && badvpn=$on || badvpn=$off

echo "<p>Estado del servicio badvpn está || $badvpn </span>.</p>" >> $DIR/$ARCHIVO
PIDVRF3=$(ps aux | grep badvpn | grep -v grep | awk '{print $2}')
if [[ -z $PIDVRF3 ]]; then
    screen -dmS badvpn2 /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
    
    NOM=$(less /etc/vps-freenet/controlador/nombre.log 2>/dev/null)
    IDB=$(less /etc/vps-freenet/controlador/IDT.log 2>/dev/null)
    KEY="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
    URL="https://api.telegram.org/bot$KEY/sendMessage"
    MSG="⚠️ _AVISO DE VPS:_ *$NOM* ⚠️\n❗️ _Protocolo_ *[ BADVPN ]* _con Fallo_ ❗️ \n🛠 _-- Reiniciando Protocolo_ -- 🛠 "
    curl -s --max-time 10 -d "chat_id=$IDB&disable_web_page_preview=true&parse_mode=markdown&text=$MSG" $URL
fi

# Reinicio de servicios Python
ureset_python () {
    for port in $(cat /etc/vps-freenet/PortPD.log | grep -v "nobody" | cut -d' ' -f1); do
        PIDVRF3=$(ps aux | grep pydic-"$port" | grep -v grep | awk '{print $2}')
        if [[ -z $PIDVRF3 ]]; then
            screen -dmS pydic-"$port" python /etc/vps-freenet/protocolos/python.py "$port"
            
            NOM=$(less /etc/vps-freenet/controlador/nombre.log 2>/dev/null)
            IDB=$(less /etc/vps-freenet/controlador/IDT.log 2>/dev/null)
            KEY="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
            URL="https://api.telegram.org/bot$KEY/sendMessage"
            MSG="⚠️ _AVISO DE VPS:_ *$NOM* ⚠️\n❗️ _Protocolo_ *[ PyDirec: $port ]* _con Fallo_ ❗️ \n🛠 _-- Reiniciando Protocolo_ -- 🛠 "
            curl -s --max-time 10 -d "chat_id=$IDB&disable_web_page_preview=true&parse_mode=markdown&text=$MSG" $URL
        fi
    done
}
ureset_python

# Servicio PySSL
ureset_pyssl () {
    for port in $(cat /etc/vps-freenet/PySSL.log | grep -v "nobody" | cut -d' ' -f1); do
        PIDVRF3=$(ps aux | grep pyssl-"$port" | grep -v grep | awk '{print $2}')
        if [[ -z $PIDVRF3 ]]; then
            screen -dmS pyssl-"$port" python /etc/vps-freenet/protocolos/python.py "$port"
            
            NOM=$(less /etc/vps-freenet/controlador/nombre.log 2>/dev/null)
            IDB=$(less /etc/vps-freenet/controlador/IDT.log 2>/dev/null)
            KEY="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
            URL="https://api.telegram.org/bot$KEY/sendMessage"
            MSG="⚠️ _AVISO DE VPS:_ *$NOM* ⚠️\n❗️ _Protocolo_ *[ PySSL: $port ]* _con Fallo_ ❗️ \n🛠 _-- Reiniciando Protocolo_ -- 🛠 "
            curl -s --max-time 10 -d "chat_id=$IDB&disable_web_page_preview=true&parse_mode=markdown&text=$MSG" $URL
        fi
    done
}
ureset_pyssl

# Fin del archivo HTML
echo "</body>
</html>" >> $DIR/$ARCHIVO
