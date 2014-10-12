#!/bin/bash
baseurl="http://somafm.com"
stationsfile="stations.txt"
tmpdir="/tmp/"
boldtext=`tput bold`
normaltext=`tput sgr0`
WGET="/usr/bin/wget"
MPLAYER="/usr/bin/mplayer"

index=0

stationnames=()
stationslist=()
stationdescription=()

while read line; do
    	name=$(echo "$line" | cut -f1 -d\|)
    	sname=$(echo "$line" | cut -f2 -d\|)
    	desc=$(echo "$line" | cut -f3 -d\|)
        stationnames+=("$name")
        stationslist+=("$sname")
        stationdescription+=("$desc")
done < $stationsfile

function selectstation() {
 selected=""
 stationcount=$(( ${#stationnames[@]} - 1 ))
 while ((! selected)); do
#	clear
	for stationnumber in $( seq 0 ${stationcount})
	 do
	 echo "${boldtext}$stationnumber ) ${stationnames[$stationnumber]}" 
	 echo "${normaltext}	${stationdescription[$stationnumber]}" 
	done
	read -p 'Selection? ' selection
	##check for input validity
	[[ $selection =~ ^[[:digit:]]+$ ]] && (($selection <= $stationcount)) && selected=1
	if ((! selected)); then echo "Invalid selection"; sleep 1; fi
done
}

function getandplay () {
echo "${boldtext}Retrieving ${stationnames[$selection]}${normaltext}"
$WGET -q ${baseurl}/${stationslist[$selection]}.pls -O ${tmpdir}somafm.pls
mplayer -really-quiet -playlist ${tmpdir}somafm.pls < /dev/null 2> /dev/null &
mplayerpid=$!
}

while :; do 
optaction=0
selectstation
getandplay
while ((! optaction)); do
	echo "${boldtext}C${normaltext}hange station ${boldtext}Q${normaltext}uit"
	read -n1 activeopt
	case $activeopt in
		[cC]) 
			kill $mplayerpid && selected=0 && optaction=1
		;;
		[qQ])
			kill $mplayerpid && exit 0
		;;
		*) echo "Invalid option";;
	esac
done
done
