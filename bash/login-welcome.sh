#!/bin/bash
title="Overlord"
hostname=$(hostname)
thetime=$(date '+%HH:%MM')
theday=$(date '+%a')
message=""

case $theday in
	Mon)
		message="not again";;
	Tue)
		message="at least it's not yesterday";;
	Wed)
		message="Getting over the hump";;
	Thu)
		message="anyone thirsty yet?";;
	Fri)
		message="Work hard play hard";;
	Sat|Sun)
		message="Living the dream";;
	*);;
esac
echo $message
