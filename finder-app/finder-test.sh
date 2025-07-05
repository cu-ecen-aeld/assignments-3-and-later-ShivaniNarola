#!/bin/bash

set -e
set -u

# Default parameters
WRITE_STR="AELD_IS_FUN"
WRITE_NUM=10
WRITELEN=0
WRITEDIR="/tmp/aeld-data"

# Accept command line overrides
if [ $# -ge 1 ]; then
    WRITE_STR=$1
fi

if [ $# -ge 2 ]; then
    WRITE_NUM=$2
fi

# Navigate to the script's directory (i.e., finder-app)
cd "$(dirname "$0")"

# 🔧 ADD THIS: Clean and build writer before running it
make clean
make

# Remove old data
rm -rf ${WRITEDIR}
mkdir -p ${WRITEDIR}

# Write files using writer
for i in $(seq 1 ${WRITE_NUM}); do
    ./writer "${WRITEDIR}/file${i}.txt" "${WRITE_STR}"
done

# Find string occurrences
MATCHCOUNT=$(./finder.sh "${WRITEDIR}" "${WRITE_STR}" | grep "Number of files" | awk '{print $6}')

if [ "$MATCHCOUNT" -eq "$WRITE_NUM" ]; then
    echo "Success: Found $MATCHCOUNT matches"
    exit 0
else
    echo "Failure: Expected $WRITE_NUM matches but found $MATCHCOUNT"
    exit 1
fi
