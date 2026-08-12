#!/bin/bash
echo "Hello, this script will run a health check on your Linux operating system. Would you like to continue?(y/n):"
read answer
	case $answer in
[yY]|[yY][eE][sS])
echo "Processing..."
;;
*)
echo "Ok, goodbye :)"
exit
;;
esac
echo "Did you want take results by telegram? y/n?"
read TELEGRAM
case $TELEGRAM in
[yY]|[yY][eE][sS])
	echo "Input your telegram chat id:"
	read CHAT_ID
	echo "Input your telegram bot TOKEN:"
	read TOKEN
SEND_TELEGRAM="True"
;;
*)
	echo "Telegram function OFF"
SEND_TELEGRAM="False"
;;
esac
echo "Procesing"
echo ""
echo "=========================="
echo "Cheking nginx..."
sleep 1
echo "Done"
echo "=========================="
echo "Cheking SSH..."
sleep 1
echo "Done" 
echo "==========================" 
echo "Cheking Docker..."
sleep 1
echo "Done" 
echo "==========================" 
echo "DISK cheking..."
sleep 1
echo "Done" 
echo "==========================" 
echo "RAM cheking..."
sleep 1
echo "Done" 
echo "==========================" 
echo "======SERVICE=HEALTH======"
echo ""
SYSTEMHEALTH=(nginx sshd docker)
OKSERVICE=0
FAILSERVICE=0
for SERVICE in "${SYSTEMHEALTH[@]}"
do
	if systemctl is-active --quiet "$SERVICE"
	then 
		echo "☑  $SERVICE OK"
		echo ""
	SERVICE_STATUS+=("$SERVICE")
	((OKSERVICE++))
	else
		echo "☒  $SERVICE OFF"
		echo ""	
	((FAILSERVICE++))
	SERVICE_STATUSBAD+=("$SERVICE")
	fi
done
if [ "${#SERVICE_STATUS[@]}" -eq 0 ]
then
    ACTIVE_SERVICES="No active services"
else
    ACTIVE_SERVICES="${SERVICE_STATUS[*]}"
fi
if [ "${#SERVICE_STATUSBAD[@]}" -eq 0 ]
then
    FAILED_SERVICES="No failed services"
else
    FAILED_SERVICES="${SERVICE_STATUSBAD[*]}"
fi
echo "======STORAGE=INFO========"
echo ""
sleep 1
        DISK_USAGE=$(df / 2>/dev/null | awk 'NR==2 {print $5}' | sed 's/%//')
	DISK_TOTAL=$(df -BG / 2>/dev/null | awk 'NR==2 {print $2}' | tr -d 'G')
	echo "Total disk storage is ${DISK_TOTAL} GB"
        echo "The hard drive is ${DISK_USAGE}% full." 
        MESSAGEDISK=$"Total hard disk storage is: ${DISK_TOTAL} GB | The hard drive is ${DISK_USAGE}% full"
echo ""
echo "=========================="
echo ""
sleep 1
	RAM_USAGE=$(free 2>/dev/null | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')
	RAM_TOTAL=$(free -g 2>/dev/null | awk '/Mem:/ {print $2}')
	echo "RAM: ${RAM_TOTAL} GB"
	echo "RAM is ${RAM_USAGE}% full"
	MESSAGERAM=$"Total RAM storage is: ${RAM_TOTAL} GB | RAM is ${RAM_USAGE}% full"
echo "=========================="
echo "Working services: $OKSERVICE"
echo "Failed services: $FAILSERVICE"
MESSAGETELEGRAM="Working services: $ACTIVE_SERVICES

Failed services: $FAILED_SERVICES

Storage info:

$MESSAGEDISK

$MESSAGERAM"
echo "RESULTS $MESSAGETELEGRAM"
if [ "$SEND_TELEGRAM" == "True" ]
then
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
     -d "chat_id=$CHAT_ID" \
     -d "text=$MESSAGETELEGRAM"
LOGFILE="healthcheck_$(date +%F).log"
echo "[$(date '+%F %T')] Status: $MESSAGETELEGRAM" >> "$LOGFILE"
else
echo "[$(date '+%F %T')] Status: $MESSAGETELEGRAM" >> "$LOGFILE"
echo "Done"
fi
