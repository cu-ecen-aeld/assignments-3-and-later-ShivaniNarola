#!/bin/bash

set -e

cd "$(dirname "$0")"

make clean
make

WRITENUM=10
WRITEDIR=/tmp/aeld-data

rm -rf "$WRITEDIR"
mkdir -p "$WRITEDIR"

for i in $(seq 1 $WRITENUM); do
    ./writer "$WRITEDIR/file$i.txt" "This is file $i with some content"
done

MATCHCOUNT=$(./finder.sh "$WRITEDIR" "some content" | grep "matching lines" | awk '{print $NF}')

if [ "$MATCHCOUNT" -eq "$WRITENUM" ]; then
    echo "SUCCESS: $MATCHCOUNT matches found"
else
    echo "FAILURE: Expected $WRITENUM matches, but found $MATCHCOUNT"
    exit 1
fi

