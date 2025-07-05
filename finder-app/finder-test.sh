#!/bin/bash
# Script: finder-test.sh
# Runs a test to check if the writer app and finder app are working correctly

WRITE_NUM=10
WRITE_STRING="AELD_IS_FUN"
WRITRFILE="/tmp/aeld-data"
WRITRFILE_NAME="${WRITRFILE}/writer_$(date +%s)"

# Create the directory
mkdir -p "$WRITRFILE"

# Call writer
./writer "$WRITRFILE_NAME" "$WRITE_STRING"

# Run finder
MATCHCOUNT=$(./finder.sh "$WRITRFILE" "$WRITE_STRING" | grep -o 'Number of files are.*[0-9]' | grep -o '[0-9]*')

# Debug output
echo "WRITE_NUM = $WRITE_NUM"
echo "MATCHCOUNT = $MATCHCOUNT"

# If MATCHCOUNT is empty, it's a failure
if [ -z "$MATCHCOUNT" ]; then
    echo "Failure: MATCHCOUNT is empty"
    exit 1
fi

# Compare values
if [ "$MATCHCOUNT" -ne "$WRITE_NUM" ]; then
    echo "Failure: Expected $WRITE_NUM matches but found $MATCHCOUNT"
    exit 1
else
    echo "Success: Found expected number of matches ($MATCHCOUNT)"
    exit 0
fi

