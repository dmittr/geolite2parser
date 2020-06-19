#!/bin/bash

RUID=$(grep 'EU,Europe,RU,Russia,,,,,,,Europe/Moscow,0' GeoLite2/GeoLite2-City-Locations-en.csv|cut -d "," -f 1)
echo "Forming RU file"
grep ",$RUID," GeoLite2/GeoLite2-City-Blocks-IPv4.csv > GeoLite2/GeoLite2-City-Blocks-IPv4-ru.csv

for REGION in $(grep "EU,Europe,RU,Russia" GeoLite2/GeoLite2-City-Locations-en.csv | cut -d "," -f 7,8|sort |uniq|tr -s ' ' '_') ; do
	REGION=${REGION//[^,a-zA-Z0-9_]/}
	REG_CODE=${REGION%,*}
	REG_NAME=${REGION#*,}
	if [ ! -z $REG_NAME ] ; then
		FILE="RESULT/${REG_CODE}_$REG_NAME"
		test -f $FILE.tmp && rm $FILE.tmp
		echo "$FILE"
		for LOCATION in $(grep "EU,Europe,RU,Russia,$REG_CODE," GeoLite2/GeoLite2-City-Locations-en.csv | cut -d ',' -f 1) ; do 
			grep ",$LOCATION,$RUID," GeoLite2/GeoLite2-City-Blocks-IPv4-ru.csv | cut -d "," -f 1
		done | sort | grep -v "/3" | grep -v "/2[987]"> $FILE.tmp
		./summarize.py $FILE.tmp > $FILE.txt; rm $FILE.tmp
	fi
done

rm GeoLite2/GeoLite2-City-Blocks-IPv4-ru.csv

