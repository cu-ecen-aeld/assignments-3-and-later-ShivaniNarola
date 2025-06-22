#!/bin/sh

if [ $# -lt 2 ]; then
    echo "Error: Missing parameters"
    exit 1
fi

WRITEFILE=$1
WRITESTR=$2

mkdir -p "$(dirname "$WRITEFILE")" || exit 1
echo "$WRITESTR" > "$WRITEFILE"

