#!/bin/bash
#
# A loop where we get our RAM and write it to disk
#

# Errors are fatal
set -e

#
# How often are we taking readings?
#
#INTERVAL=15 # On my Mac, just produces over 500 Megs of logs per day and goes over Splunk's free license
#INTERVAL=30
INTERVAL=60

#
# How many times are we looping before checking the date?
# This value * $INTERVAL will be how many seconds before checking the date.
#
LOOPS=240

#
# Create our logs directory.
#
pushd $(dirname $0) > /dev/null
mkdir -p logs/


while true
do

	DAY=$(date +"%Y%m%d")
	LOG="logs/${DAY}.txt"

	echo "# "
	echo "# Writing to ${LOG}..."
	echo "# "

	./better-ps.py --loops ${LOOPS} --interval ${INTERVAL} >> $LOG

	sleep $INTERVAL

	#
	# Delete old logs
	#
	find logs/ -type f -mtime +7 -exec rm -f {} \;

done

