#!/bin/bash -e

helpstring="
Processes chunk files found in $DATA_PATH/Cosmics (or provided -p argument) with either the unpacker (flag -u) or the light dqm (flag -a).
        Usage: mergeFiles.sh [options] [ -a | -u ]
        Options:
            -a the script will perform the dqm analysis
            -d provide debugging information
            -i initial chunk number to consider, defaults to 0
            -f final chunk number to consider
            -h prints this menu and exits
            -p path to datafiles of the form 'runXXXXXX_Cosmic_CERNQC8_YYYY-MM-DD_chunk_*.dat'
            -r run number of interest
            -u the script will perform the unpacking"

# Set Defaults
ADDHISTOS=""
CMD=""
FILEPATH="$DATA_PATH/Cosmics"
DEBUG=""
OPTION=""
RUNNUMBER=""
FILEEXT=""
INITIALCHUNK=$((0))
FINALCHUNK=$((-1))

# Get Options
OPTIND=1
while getopts ":p:r:i:f:hdau" opts
do
    case $opts in
        a)
            ADDHISTOS="true"
            CMD="dqm"
            FILEEXT="raw.root";;
        p) 
            FILEPATH="$OPTARG";;
        r)
            RUNNUMBER="$OPTARG";;
        i)
            INITIALCHUNK="$OPTARG";;
        f)
            FINALCHUNK="$OPTARG";;
        u)
            CMD="unpacker"
            OPTION="sdram"
            FILEEXT="dat";;
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
    echo 
    echo CMD ${CMD}
    echo FILEPATH ${FILEPATH}
    echo OPTION ${OPTION}
    echo RUNNUMBER ${RUNNUMBER}
    echo FILEEXT ${FILEEXT}
    echo INITIALCHUNK ${INITIALCHUNK}
    echo FINALCHUNK ${FINALCHUNK}
fi

if [ -z "$CMD" ]
then
    echo "You must supply either option '-a' or '-u'"
    echo ${helpstring}
    kill -INT $$;
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

#OUTPUTFILENAME=$(ls ${FILEPATH}/run${RUNSTRING}_Cosmic_CERNQC8_*_chunk_*.dat | grep "chunk_0.dat")
#OUTPUTFILENAME="${OUTPUTFILENAME%"_chunk_0.dat"}.dat"
#
#if [ -f ${OUTPUTFILENAME} ]; then
#    echo "file ${OUTPUTFILENAME} exists already"
#    echo "to prevent event duplication I am deleting it"
#    echo "rm ${OUTPUTFILENAME}"
#    rm ${OUTPUTFILENAME}
#fi

# Loop over files found in FILEPATH
#for file in ${FILEPATH}/run${RUNSTRING}_Cosmic_CERNQC8_*_chunk_*.dat
for file in ${FILEPATH}/run${RUNSTRING}_Cosmic_CERNQC8_*_chunk_*.${FILEEXT}
do
    chunkNumber=$(echo $file 2>/dev/null | awk -F _ '{ print $6 }' 2>/dev/null | awk -F . '{print $1}' )

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

    #echo "cat ${file} >> ${OUTPUTFILENAME}"
    #cat ${file} >> ${OUTPUTFILENAME} 
    if [ -n "$DEBUG" ]; then
        echo "${CMD} ${file} ${OPTION}"
    else
        echo "${CMD} ${file} ${OPTION}"
        ${CMD} ${file} ${OPTION}
    fi

    if [ -n "$ADDHISTOS" ]; then
        FILELIST="${FILELIST} ${file}"
    fi 
done

if [ -n "$ADDHISTOS" ]; then
    OUTPUTFILENAME=$(ls ${FILEPATH}/run${RUNSTRING}_Cosmic_CERNQC8_*_chunk_*.${FILEEXT} | grep "chunk_0.${FILEEXT}")
    OUTPUTFILENAME="${OUTPUTFILENAME%"_chunk_0.{$FILEEXT}"}.${FILEEXT}"
    
    if [ -f ${OUTPUTFILENAME} ]; then
        echo "file ${OUTPUTFILENAME} exists already; deleting it"
        echo "rm ${OUTPUTFILENAME}"
        rm ${OUTPUTFILENAME}
    fi

    echo ""
    echo "hadd -k ${OUTPUTFILENAME} ${FILELIST}"
    echo ""
fi

#echo ""
#echo "Your file can be found at:"
#echo ""
#echo    ${OUTPUTFILENAME}
#echo ""
echo "Done"
