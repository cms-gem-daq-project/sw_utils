#!/bin/bash -e

helpstring="
Individually processes chunk files found in $DATA_PATH/Cosmics (or provided -p argument) with the unpacker, adds the output raw.root files together, and then processes this final file with the light dqm.
        Usage: mergeFiles.sh [options]
        Options:
            -d Outputs commands that will be executed, nothing is produced
            -i initial chunk number to consider, defaults to 0
            -f final chunk number to consider, if not provided all chunk files will be processed
            -h prints this menu and exits
            -p path to datafiles of the form 'runXXXXXX_Cosmic_CERNQC8_YYYY-MM-DD_chunk_*.dat'
            -r run number of interest"

# Set Defaults
FILEPATH="$DATA_PATH/Cosmics"
DEBUG=""
RUNNUMBER=""
INITIALCHUNK=$((0))
FINALCHUNK=$((-1))

# Get Options
OPTIND=1
while getopts ":p:r:i:f:hdau" opts
do
    case $opts in
        p) 
            FILEPATH="$OPTARG";;
        r)
            RUNNUMBER="$OPTARG";;
        i)
            INITIALCHUNK="$OPTARG";;
        f)
            FINALCHUNK="$OPTARG";;
        d)
            DEBUG="true";;
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

if [ -n "$DEBUG" ]
then
    echo FILEPATH ${FILEPATH}
    echo RUNNUMBER ${RUNNUMBER}
    echo INITIALCHUNK ${INITIALCHUNK}
    echo FINALCHUNK ${FINALCHUNK}
fi

# Create the run number string
RUNSTRING=""
if (( ${RUNNUMBER} > 99999 )); then
    echo "true"
    RUNSTRING="${RUNNUMBER}"
elif (( ${RUNNUMBER} > 9999 )); then
    RUNSTRING="0${RUNNUMBER}"
elif (( ${RUNNUMBER} > 999 )); then
    RUNSTRING="00${RUNNUMBER}"
elif (( ${RUNNUMBER} > 99 )); then
    RUNSTRING="000${RUNNUMBER}"
elif (( ${RUNNUMBER} > 9 )); then
    RUNSTRING="0000${RUNNUMBER}"
else
    RUNSTRING="00000${RUNNUMBER}"
fi

# Loop over files found in FILEPATH
for file in ${FILEPATH}/run${RUNSTRING}_Cosmic_CERNQC8_*_chunk_*.dat
do
    chunkNumber=$(echo $file 2>/dev/null | awk -F _ '{ print $7 }' 2>/dev/null | awk -F . '{print $1}' )

    # Skip chunk files below initial number
    if (( ${chunkNumber} < ${INITIALCHUNK} )); then
        if [ -n "$DEBUG" ]; then
            echo "skipping chunk ${chunkNumber}"
        fi
        continue
    fi

    # Skip chunk files above final number if provided
    if (( ${FINALCHUNK} -gt -1 )); then
        if (( ${chunkNumber} > ${FINALCHUNK} )); then
            if [ -n "$DEBUG" ]; then
                echo "skipping chunk ${chunkNumber}"
            fi
            continue
        fi
    fi

    if [ -n "$DEBUG" ]; then
        echo "unpacker ${file} sdram"
    else
        echo "unpacker ${file} sdram"
        unpacker ${file} sdram
    fi

    thisRawFile="${file%".dat"}.raw.root"
    FILELIST="${FILELIST} ${thisRawFile}"
done

echo "Finished unpacker loop, now adding raw files together"

# Add raw.root files together
FINALRAWFILE=$(ls ${FILEPATH}/run${RUNSTRING}_Cosmic_CERNQC8_*_chunk_*.raw.root | grep "chunk_${INITIALCHUNK}.raw.root")
FINALRAWFILE="${FINALRAWFILE%"_chunk_${INITIALCHUNK}.raw.root"}.raw.root"

if [ -n "$DEBUG" ]; then
    echo ""
    echo "hadd -k ${FINALRAWFILE} ${FILELIST}"
    echo ""
else
    if [ -f ${FINALRAWFILE} ]; then
        echo "file ${FINALRAWFILE} exists already; deleting it"
        echo "rm ${FINALRAWFILE}"
        rm ${FINALRAWFILE}
    fi
    hadd -k ${FINALRAWFILE} ${FILELIST}
fi

echo "Finished adding raw files together, now running dqm"

if [ -n "$DEBUG" ]; then
    echo "dqm ${FINALRAWFILE}"
else
    echo "dqm ${FINALRAWFILE}"
    dqm ${FINALRAWFILE}
fi

FINALANAFILE="${FINALRAWFILE%".raw.root"}.analyzed.root"

echo ""
echo "Your file can be found at:"
echo ""
echo    ${FINALANAFILE}
echo ""
echo "Done"
