#!/bin/bash
#
# Remove the Splunk data
#

# Errors are fatal
set -e

# Change to our directory
pushd $(dirname $0) > /dev/null

echo "# "
echo "# Removing the Splunk data..."
echo "# "
rm -rfv data/

