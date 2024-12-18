#!/bin/bash
NOM="$(less /etc/vps-freenet/controlador/nombre.log)"
NOM1="$(echo $NOM)"
IDB=`less /etc/vps-freenet/controlador/IDT.log` > /dev/null 2>&1
IDB1=`echo $IDB` > /dev/null 2>&1
KEY="7418077679:AAGBYojItZxnF1o4VOqYGyJrz4t4jT_ngzc"
URL="https://api.telegram.org/bot$KEY/sendMessage"
MSG="⚠️ AVISO DE VPS: $NOM1 ⚠️
❗️ VPS REINICIADA ❗️
🔰 INICIO EXITOSO 🔰 "
curl -s --max-time 10 -d "chat_id=$IDB1&disable_web_page_preview=1&text=$MSG" $URL &>/dev/null
