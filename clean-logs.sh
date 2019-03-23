#!/bin/bash
#
# Remove the logs
#

# Errors are fatal
set -e

# Change to our directory
pushd $(dirname $0) > /dev/null

echo "# "
echo "# Removing the logs..."
echo "# "
rm -rfv logs/

