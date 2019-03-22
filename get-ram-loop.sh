#!/bin/bash
#
# A loop where we get our RAM and write it to disk
#

# Errors are fatal
set -e

#
# How often are we taking readings?
#
INTERVAL=10

#
# How many times are we looping before checking the date?
# This value * $INTERVAL will be how many seconds before checking the date.
#
LOOPS=360

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

	for I in $(seq 1 $LOOPS)
	do
		ps aux 2>&1 >> $LOG
		sleep $INTERVAL
	done

	#
	# TODO: Delete old logs here.
	#

done

