#!/bin/bash
SCPdir="/etc/vps-freenet" && [[ ! -d ${SCPdir} ]] && exit 1
SCPusr="${SCPdir}/controlador" 
SCPfrm="${SCPdir}/herramientas" 
SCPinst="${SCPdir}/protocolos" 

monitor_auto () {
while true; do
monitor.sh 2>/dev/null
sleep 90s 
    done
}
monitor_auto
exit
