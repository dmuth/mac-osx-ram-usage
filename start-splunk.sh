#!/bin/bash
#
# Start up Splunk and ingest the memory usage logs.
#

# Errors are fatal
set -e


SPLUNK_PASSWORD=${SPLUNK_PASSWORD:-password1}
SPLUNK_PORT=${SPLUNK_PORT:-8000}
SPLUNK_BG=${SPLUNK_BG:-no}

#
# Change to the directory of this script
#
pushd $(dirname $0) >/dev/null

if ! test $(which docker)
then
	echo "! "
	echo "! Docker not found in the system path!"
	echo "! "
	echo "! Please double-check that Docker is installed on your system, otherwise you "
	echo "! can go to https://www.docker.com/ to download Docker. "
	echo "! "
	exit 1
fi

BG=""
if test "$SPLUNK_BG" -a "$SPLUNK_BG" != "no"
then
	BG="-d"
fi


echo "# "
echo "# Starting Splunk in Docker..."
echo "# "
echo "# SPLUNK_URL:       https://localhost:${SPLUNK_PORT}/"
echo "# SPLUNK_PASSWORD:  ${SPLUNK_PASSWORD}"
echo "# SPLUNK_BG:        ${SPLUNK_BG}"
echo "# "
echo "> "
echo "> Press ENTER to run Splunk with the above settings, or ctrl-C to abort..."
echo "> "
read
if test "$BG"
then
	echo "# "
	echo "# Starting Splunk in the background..."
	echo "# Note the Docker ID, which you can use with the \"docker kill\" command."
	echo "# "
fi
docker run -p $SPLUNK_PORT:8000 \
	-e SPLUNK_PASSWORD=${SPLUNK_PASSWORD} \
	-v $(pwd)/logs:/logs \
	-v $(pwd)/data:/data \
	-v $(pwd)/app:/app \
	$BG \
	dmuth1/splunk-lab


