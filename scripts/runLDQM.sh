#!/bin/bash -e

helpstring="
Individually processes chunk files found in $DATA_PATH/Cosmics (or provided -p argument) with the unpacker, adds the output raw.root files together, and then processes this final file with the light dqm.
        Usage: mergeFiles.sh [options]
        Options:
            -d Outputs commands that will be executed, nothing is produced
            -i initial chunk or lumi section number to consider, defaults to 0
            -f final chunk or lumi section number to consider, if not provided all files will be processed
            -h prints this menu and exits
            -p path to datafiles of the form 'runXXXXXX_Cosmic_CERNQC8_YYYY-MM-DD_chunk_*.dat' or 'runXXXXXX_ls*.raw'
            -r run number of interest
            -u unpacker uses the sdram headers, default is ferol"

# Set Defaults
DEBUG=""
FILEPATH="$DATA_PATH/Cosmics"
FINALCHUNK=$((-1))
INITIALCHUNK=$((0))
LOCALREADOUT=""
RUNNUMBER=""
UNPACKERHEADER="ferol"

# Get Options
OPTIND=1
while getopts ":p:r:i:f:hd" opts
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
        u)
            LOCALREADOUT="true"
            UNPACKERHEADER="sdram";;
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

# Run either local readout unpacking or the uFEDKit unpacking
if [ -n "$LOCALREADOUT" ]; then
    #########################
    ##### Local Readout #####
    #########################

    # Loop over files found in FILEPATH
    for file in ${FILEPATH}/run${RUNSTRING}_Cosmic_CERNQC8_*_chunk_*.dat
    do
        # Determine this chunk number
        chunkNumber=$(echo $file 2>/dev/null | awk -F _ '{ print $7 }' 2>/dev/null | awk -F . '{print $1}' )

        # Skip chunk files below initial number
        if (( ${chunkNumber} < ${INITIALCHUNK} )); then
            if [ -n "$DEBUG" ]; then
                echo "skipping chunk ${chunkNumber}"
            fi
            continue
        fi

        # Skip chunk files above final number if provided
        if (( ${FINALCHUNK} > -1 )); then
            if (( ${chunkNumber} > ${FINALCHUNK} )); then
                if [ -n "$DEBUG" ]; then
                    echo "skipping chunk ${chunkNumber}"
                fi
                continue
            fi
        fi

        # Call unpacker
        if [ -n "$DEBUG" ]; then
            echo "unpacker ${file} ${UNPACKERHEADER}"
        else
            echo "unpacker ${file} ${UNPACKERHEADER}"
            unpacker ${file} ${UNPACKERHEADER}
        fi

        thisRawFile="${file%".dat"}.raw.root"
        FILELIST="${FILELIST} ${thisRawFile}"
    done

    echo "Finished unpacker loop, now adding raw files together"

    # Add raw.root files together
    FINALRAWFILE=$(ls ${FILEPATH}/run${RUNSTRING}_Cosmic_CERNQC8_*_chunk_*.raw.root | grep "chunk_${INITIALCHUNK}.raw.root")
    FINALRAWFILE="${FINALRAWFILE%"_chunk_${INITIALCHUNK}.raw.root"}.raw.root"
else
    #########################
    ##### FEDKit Readout ####
    #########################

    FIRSTLUMISECSTR=""
    for file in ${FILEPATH}/run${RUNSTRING}_ls*_index*.raw
    do
        # Determine this lumisection
        lsNumberStr=$(echo $file 2>/dev/null | awk -F _ '{ print $2 }' 2>/dev/null | awk -F . '{print $1}' )
        lsNumberStr=$(echo $lsNumberStr | cut -c 3-6) #Drops the leading 'ls' and returns only the number

        # Transform into an integer
        pythonCall="print(int('$lsNumberStr'))"
        lsNumber=$(python -c "$pythonCall")

        # Skip lumi section files below initial number
        if (( ${lsNumber} < ${INITIALCHUNK} )); then
            if [ -n "$DEBUG" ]; then
                echo "lumi section ${lsNumber} less than initial requested lumi section ${INITIALCHUNK}; skipping"
            fi
            continue
        fi

        # Determine the first lumi section we actually process
        if [ -n "FIRSTLUMISECSTR" ]; then
            FIRSTLUMISECSTR=${lsNumberStr}
        fi

        # Skip chunk files above final number if provided
        if (( ${FINALCHUNK} > -1 )); then
            if (( ${lsNumber} > ${FINALCHUNK} )); then
                if [ -n "$DEBUG" ]; then
                    echo "lumi section ${lsNumber} greater than final requested lumi section ${FINALCHUNK}; skipping"
                fi
                continue
            fi
        fi

        # Call unpacker
        if [ -n "$DEBUG" ]; then
            echo "unpacker ${file} ${UNPACKERHEADER}"
        else
            echo "unpacker ${file} ${UNPACKERHEADER}"
            unpacker ${file} ${UNPACKERHEADER}
        fi

        thisRawFile="${file%".raw"}.raw.root"
        FILELIST="${FILELIST} ${thisRawFile}"
    done
    echo "Finished unpacker loop, now adding raw files together"

    # Add raw.root files together
    FINALRAWFILE=$(ls ${FILEPATH}/run${RUNSTRING}_ls*.raw.root | grep "ls${FIRSTLUMISECSTR}" | grep "raw.root")
    FINALRAWFILE=$(echo $FINALRAWFILE 2>/dev/null | awk -F / '{ print $4 }' | awk -F _ '{print $1"_allLumi_"$3}')
    if [ -n "$DEBUG" ]; then
        echo "FINALRAWFILE ${FINALRAWFILE}"
    fi
fi

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
