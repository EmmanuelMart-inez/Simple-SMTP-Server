#!/bin/bash
oid=.1.3.6.1.2.1.25.3.3.1.2
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
#	a=$(ping $i -c1 | grep '^[0-9][0-9]' | awk '{print $7}' | awk -F= '{print $2}')
	a=$(snmpwalk -v2c -c public $i $oid)
	dec1=$(echo "$a" | awk '{print $4}')
	dec=$(($dec1 + 0))
	echo ""
	echo "ip: $i , porcentaje de uso del cpu: $dec %"
	echo "$a" >> $i.txt
		if [[ $dec  == 1 ]]
		then
#-#			echo "Está lenta la ip : $i, tiene una velocidad de: $a"
			perl swaks.pl --to user@example.com --header \
			"Subject:A2;"$i";utilizacion_CPU"\
			 --body "IP:$i usando el $dec %  del CPU "  \
			 --server 127.0.0.1:1130 > /dev/null
		fi
	done

	sleep $refresh
done
