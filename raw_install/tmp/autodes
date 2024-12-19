#!/bin/bash
SCPdir="/etc/vps-freenet"
SCPusr="${SCPdir}/controlador"
desbloqueo_auto () {
while true; do
Desbloqueo.sh 2>/dev/null
tiemdes="$(less /etc/vps-freenet/controlador/tiemdes.log)"
sleep $tiemdes
    done
}
# DESBLOQUEO AUTO
desbloqueo_auto
#fin