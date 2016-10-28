#!/bin/bash


#
# $1 - filename (format: xxxx-NN.eee)
#
function numbering()
{
    no=`ls $1-* -lt | head -n1 | sed 's/.*-\([0-9]\+\).*/\1/' `

    # numeric ?
    re='^[0-9]+$'
    if ! [[ $no =~ $re ]] ; then
	no=0
    fi

    echo $(($no + 1))
}
# num=$(numbering world)
# echo $num
# exit


#
# $1 - station name
# $2 - file number
#
function rec_radiotunes
{
    curl -H "Host: pub1.radiotunes.com" -H "Referer: http://www.radiotunes.com/$1" -H "User-Agent: Mozilla/5.0" http://pub1.radiotunes.com/radiotunes_$1_aacplus?type=.flv -v | mplayer - -dumpstream -dumpfile $1-$2.flv
}

IFS=$','
CHS="quit,at40,at40classic,vocalsmoothjazz,world"

select ch in $CHS; do
	if [ "$ch" = "quit" ]; then
	    exit
	elif [ "$ch" = "at40" ]; then
	    num=$(numbering $ch)
	    mplayer -loop 0 -playlist http://americantop40.akacast.akamaistream.net/7/785/58084/v1/auth.akacast.akamaistream.net/americantop40.m3u -dumpstream -dumpfile $ch-$num.aac
	elif [ "$ch" = "at40classic" ]; then
	    num=$(numbering $ch)
	    mplayer -loop 0 http://at70-fl.ng.akacast.akamaistream.net:80/7/763/234624/v1/auth.akacast.akamaistream.net/at70-fl -dumpstream -dumpfile $ch-$num.aac
	elif [ "$ch" = "vocalsmoothjazz" ] || [ "$ch" = "world" ]; then
	    num=$(numbering $ch)
	    rec_radiotunes $ch $num
	fi
done

