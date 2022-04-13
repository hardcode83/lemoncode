#!/bin/bash
URL=$1
FILE=$2
WORD=$3
if [[ $# < 3 ]]; then
 echo "USAGE: ./$0 URL FILETOSAVE WORDTOFIND"
 echo "Example: ./$0 https://www.google.com google.com.txt <BODY>"
 exit 2
else
 curl -s $URL -o $FILE
 grep -n $WORD $FILE |  cut -f1 -d:
fi
