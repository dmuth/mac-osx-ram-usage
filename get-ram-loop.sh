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
		#
		# The date is in the format recommended at 
		# https://answers.splunk.com/answers/5357/what-is-the-best-timestamp-format-to-use-for-my-custom-log-to-be-indexed-by-splunk.html#answer-550100
		#

		DATE=$(date +"%Y-%m-%dT%T.000%z")
		ps aux |sort 2>&1 | sed -e s/^/"${DATE} "/ >> $LOG

		sleep $INTERVAL

	done

	#
	# TODO: Delete old logs here.
	#

done

