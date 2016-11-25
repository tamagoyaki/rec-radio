#!/bin/bash
#
# USAGE:
#
#    fadeinout.sh filename [ ... ]
#

FI=5
FO=5

for file in $*; do
    # echo $file;

    DURA=`ffmpeg -i $file 2>&1 | awk '/Duration:/{print \$2}' | sed 's/,//'`
    #echo $DURA

    if [ "N/A" = "$DURA" ]; then
	echo "Error: $file has N/A Duration"
	exit
    fi

    name=`echo $file | sed 's/\..*//'`
    #echo $name
    
    ST=`date -d "$DURA today - $FO seconds" +'%T' | sed 's/:/\\\\\\\\:/g'`
    #echo $ST
    
    ffmpeg -i $file -af "afade=t=in:ss=0:d=$FI,afade=t=out:st=$ST:d=$FO" faded-$name.mp3
done


