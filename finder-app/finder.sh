#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <directory> <search string>"
    exit 1
fi

filesdir=$1
searchstr=$2

if [ ! -d "$filesdir" ]; then
    echo "Directory $filesdir does not exist"
    exit 1
fi

files_count=$(find "$filesdir" -type f | wc -l)
match_count=$(grep -r "$searchstr" "$filesdir" 2>/dev/null | wc -l)

echo "The number of files are $files_count and the number of matching lines are $match_count"

