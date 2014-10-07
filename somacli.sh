#!/bin/bash
baseurl="http://somafm.com"
tmpdir="/tmp/"
boldtext=`tput bold`
normaltext=`tput sgr0`
WGET="/usr/bin/wget"
MPLAYER="/usr/bin/mplayer"

stationnames=("Christmas Rocks!" "Christmas Lounge" "Xmas in Frisko (holiday)" "Groove Salad (ambient/electronica)" "Lush (electronica)" "Earwaves (experimental)" "Deep Space One (ambient)" "Drone Zone (ambient)" "PopTron (alternative)" "DEF CON Radio (specials)" "Dub Step Beyond (electronica)" "Space Station Soma (electronica)" "Mission Control (ambient/electronica)" "Indie Pop Rocks! (alternative)" "Folk Forward (folk/alternative)" "BAGeL Radio (alternative)" "Digitalis (electronica/alternative)" "Sonic Universe (jazz)" "Secret Agent (lounge)" "Suburbs of Goa (world)" "Boot Liquor (americana)" "Illinois Street Lounge (lounge)" "The Trip (electronica)" "cliqhop idm (electronica)" "Iceland Airwaves (alternative)" "Covers (eclectic)" "Underground 80s (alternative/electronica)" "Beat Blender (electronica)" "Doomed (ambient/industrial)" "Black Rock FM (eclectic)" "SF 10-33 (ambient/news)")
stationslist=("xmasrocks" "christmas" "xmasinfrisko" "groovesalad" "lush" "earwaves" "deepspaceone" "dronezone" "poptron" "events" "dubstep" "spacestation" "missioncontrol" "indiepop" "folkfwd" "bagel" "digitalis" "sonicuniverse" "secretagent" "suburbsofgoa" "bootliquor" "illstreet" "thetrip" "cliqhop" "airwaves" "covers" "u80s" "beatblender" "doomed" "brfm" "sf1033")
stationdescription=("Have your self an indie/alternative holiday season!" "Chilled holiday grooves and classic winter lounge tracks. (Kid and Parent safe!)" "SomaFM's wacky and eclectic holiday mix. Not for the easily offended." "A nicely chilled plate of ambient/downtempo beats and grooves." "Sensuous and mellow vocals  mostly female  with an electronic influence." "Spanning the history of electronic and experimental music from the early pioneers to the latest innovators." "Deep ambient electronic  experimental and space music. A soundtrack for inner and outer space exploration." "Served best chilled  safe with most medications. Atmospheric textures with minimal beats." "Electropop and indie dance rock with sparkle and pop." "Music for Hacking. From DEF CON 21 in Las Vegas." "Dubstep  Dub and Deep Bass. May damage speakers at high volume." "Tune in  turn on  space out. Spaced-out ambient and mid-tempo electronica." "Celebrating NASA and Space Explorers everywhere." "New and classic favorite indie pop tracks." "Indie Folk  Alt-folk and the occasional folk classics." "What alternative rock radio should sound like." "Digitally affected analog rock to calm the agitated heart." "Transcending the world of jazz with eclectic  avant-garde takes on tradition." "The soundtrack for your stylish  mysterious  dangerous life. For Spies and PIs too!" "Desi-influenced Asian world beats and beyond." "Americana Roots music for Cowhands  Cowpokes and Cowtippers" "Classic bachelor pad  playful exotica and vintage music of tomorrow." "Progressive house / trance. Tip top tunes." "Blips'n'beeps backed mostly w/beats. Intelligent Dance Music." "Music from bands who will be performing at Iceland Airwaves [explicit]" "Just covers. Songs you know by artists you don't. We've got you covered." "Early 80s UK Synthpop and a bit of New Wave." "A late night blend of deep-house and downtempo chill." "Dark industrial/ambient music for tortured souls." "From the Playa to the world  for the 2013 Burning Man festival" "Ambient music mixed with the sounds of San Francisco public safety radio traffic.")

function selectstation() {
 selected=""
 stationcount=$(( ${#stationnames[@]} - 1 ))
 while ((! selected)); do
	clear
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
