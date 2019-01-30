#!/bin/zsh

helpstring="
Automatically scans latency through a predefined range.  You must have started the run beforehand.
    Usage:
        autoLatScan.sh [options]
        Options:
            -a AMC slot in uTCA crate
            -d Print additional debugging info
            -h Display this message and exit
            -l Latency range given as two numbers separated by a hyphen, e.g. 38-48
            -o ohMask to use for this scan (a 1 in the N^th bit means use the N^th OH)
            -s uTCA crate shelf number
            -t Time to wait in seconds before changing the latency"

# Set Defaults
AMC=2
DEBUG=$((0))
LATRANGE="38-48"
OHMASK=$((0xfff))
SHELF=1
TIME=300

# Get Options
OPTIND=1
while getopts "a:l:o:s:t:hd" opts
do
    case $opts in
        a) 
            AMC="$OPTARG";;
        l)
            LATRANGE="$OPTARG";;
        o)
            OHMASK="$OPTARG";;
        s)
            SHELF="$OPTARG";;
        t)
            TIME="$OPTARG";;
        d)
            DEBUG=$((1));;
        h)
            echo >&2 "${helpstring}"
            #return 1;;
            kill -INT $$;;
        \?)
            echo >&2 "${helpstring}"
            #return 1;;
            kill -INT $$;;
        [?])
            echo >&2 "${helpstring}"
            #return 1;;
            kill -INT $$;;
    esac
done
unset OPTIND

RANGE_FIRST=$((-1))
RANGE_LAST=$((-1))
for substr in $(echo $LATRANGE | tr "-" "\n")
do
    if [ ${RANGE_FIRST} -lt 0 ]; then
        RANGE_FIRST=$substr
    elif [ $RANGE_LAST -lt 0 ]; then
        RANGE_LAST=$substr
    else
    fi
done

if [ ${RANGE_FIRST} -lt 0 ]; then
    echo "I was unable to determine the first latency point"
    echo ${helpstring}
    kill -INT $$
fi

if [ $RANGE_LAST -lt 0 ]; then
    echo "I was unable to determine the last latency point"
    echo ${helpstring}
    kill -INT $$
fi

echo "Latency range of interest determined to be [$RANGE_FIRST,$RANGE_LAST]"
echo "Scanning this range"
for lat in {$RANGE_FIRST..$RANGE_LAST}
do
    echo "============================Latency ${lat}============================"
    echo "set_scanParams_latency.py -s $AMC --shelf=${SHELF} ${lat} ${OHMASK}"
    set_scanParams_latency.py -s $AMC --shelf=${SHELF} ${lat} ${OHMASK}
    echo "Waiting $TIME seconds"
    sleep $TIME
done

echo "Scan Complete; You may stop RCMS Now"
