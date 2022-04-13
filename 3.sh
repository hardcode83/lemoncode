#!/bin/bash
MESSAGE="Que me gusta la bash!!!!"
FILE1=foo/dummy/file1.txt
FILE2=foo/dummy/file2.txt
mkdir -p foo/{dummy,empty}
if [[ $# < 1 ]]; then
 echo $MESSAGE > $FILE1
else
 echo $1 > $FILE1
fi
touch $FILE2
cat $FILE1 > $FILE2
mv $FILE2 foo/empty
