#!/bin/bash
# tiny script to check if all of the stations in
# the station list file still resolve as some
# channels are periodically removed.

STATIONS_FILE="stations"


for url in $(cut -d '|' -f 3 "$STATIONS_FILE" | awk '{printf "https://somafm.com%s\n", $1}') ; do
	printf "checking %s..." "$url"
	curl --max-time 10 --silent -o /dev/null "$url"
	[[ "$?" -eq 0 ]] && printf "OK" || printf "FAILED"
	echo
done
