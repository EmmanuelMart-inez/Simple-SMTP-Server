#!/bin/bash

refresh=5 #seconds
usermail="user@example.com"
file="ips.txt"

while [ : ]
do
	HOSTS=()
	a=0
	while IFS= read -r line
	do
        	HOSTS+=$line
        	HOSTS+=" "
	done < "$file"
#-#	echo ${HOSTS[0]}
	for i in ${HOSTS[@]}
	do
	a=$(ping $i -c1 | grep '^[0-9][0-9]' | awk '{print $7}' | awk -F= '{print $2}')
	dec1=$(echo "$a" | awk -F. '{print $1}')
	dec=$(($dec1 + 0))
#-#	echo ""
#-#	echo "ip: $i , vel: $a ... $dec"
	echo "$a" >> $i.txt
		if [[ $dec  > 0 ]]
		then
#-#			echo "Está lenta la ip : $i, tiene una velocidad de: $a"
			swaks --to user@example.com --header "Subject:A1 $i ;retardo_en_ping: $a ms"\
			 --body "IP:$i con respuesta de $a ms"  --server 127.0.0.1:1130 > /dev/null
		fi
	done

	sleep $refresh
done
