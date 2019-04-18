#!/bin/bash

helpstring="Usage: doQC7.sh -c [DetName]
    Options:
        -a AMC slot number inside uTCA shelf
        -c chamber name, without '/' characters, e.g. 'GE11-X-S-CERN-0007'
        -d Debugging flag, prints additional information
        -f starting step to begin testConnectivity.py with, defaults to 1, options [1,5]
        -s uTCA shelf number"

AMCSLOT="5"
CHAMBER_NAME=""
SHELF="2"
STARTINGSTEP="1"

OPTIND=1
while getopts "a:c:f:s:hd" opts
do
    case $opts in
        a)
            AMCSLOT="$OPTARG";;
        c)
            CHAMBER_NAME="$OPTARG";;
        f)
            STARTINGSTEP="$OPTARG";;
        s)
            SHELF="$OPTARG";;
        h)
            echo >&2 "${helpstring}"
            kill -INT $$;;
        \?)
            echo >&2 "${helpstring}"
            kill -INT $$;;
        [?])
            echo >&2 "${helpstring}"
            kill -INT $$;;
    esac
done
unset OPTIND

if [ -z "$CHAMBER_NAME" ]
then
    echo -e "\e[31mYou must supply a detector serial number using the '-c' option\e[39m"
    echo ${helpstring}
    kill -INT $$
fi

#export DATA_PATH=/<your>/<data>/<directory>
if [ -z "${DATA_PATH}" ]
then
    echo "DATA_PATH not set, please set DATA_PATH to a directory where data files created by scan applications will be written"
    echo " (export DATA_PATH=<your>/<data>/<directory>/) and then rerun this script"
    return
fi

#export ELOG_PATH=/<your>/<data>/<directory>
if [ -z "${ELOG_PATH}" ]
then
    echo "ELOG_PATH not set, please set ELOG_PATH to a directory where additional log files created by 'testConnectivity.py' can be written"
    echo " (export ELOG_PATH=<your>/<directory>/) and then rerun this script"
    return
fi

# Strip '/' characters from input CHAMBER_NAME
CHAMBER_NAME="$( echo ${CHAMBER_NAME} | tr -d /)"

# Check if directory under DATA_PATH exists
if [ ! -d "${DATA_PATH}/${CHAMBER_NAME}" ]; then
    echo mkdir -p ${DATA_PATH}/${CHAMBER_NAME}
    mkdir -p ${DATA_PATH}/${CHAMBER_NAME}
    echo chmod g+rw ${DATA_PATH}/${CHAMBER_NAME}
    chmod g+rw ${DATA_PATH}/${CHAMBER_NAME}
fi

# Make the logfile
scandate=$(date +%Y.%m.%d.%H.%M)
LOGFILE=${DATA_PATH}/${CHAMBER_NAME}/connectivityLog_${CHAMBER_NAME}_${scandate}.log
echo "Terminal output will be saved too: ${LOGFILE}"
echo "Calling Command: " 2>&1 | tee ${LOGFILE}

# Call testConnectivity.py
echo "testConnectivity.py -c ${CHAMBER_NAME} --checkCSCTrigLink -f${STARTINGSTEP} -n 50 -o 0x10 --shelf=${SHELF} -s${AMCSLOT} --writePhases2File" 2>&1 | tee -a ${LOGFILE}
testConnectivity.py -c ${CHAMBER_NAME} --checkCSCTrigLink -f${STARTINGSTEP} -n 50 -o 0x10 --shelf=${SHELF} -s${AMCSLOT} --writePhases2File 2>&1 | tee -a ${LOGFILE}

# Move the GBT phase scan log to ${DATA_PATH}/${CHAMBER_NAME}
phaseScanLog=${ELOG_PATH}/gbtPhaseSettings.log
if [ -f ${phaseScanLog} ]; then
    echo "mv ${phaseScanLog} ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseScan_${CHAMBER_NAME}_${scandate}.log" 2>&1 | tee -a ${LOGFILE}
    mv ${phaseScanLog} ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseScan_${CHAMBER_NAME}_${scandate}.log 2>&1 | tee -a ${LOGFILE}
    echo "unlink ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseScan_${CHAMBER_NAME}_current.log" 2>&1 | tee -a ${LOGFILE}
    unlink ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseScan_${CHAMBER_NAME}_current.log 2>&1 | tee -a ${LOGFILE}
    echo "ln -sf ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseScan_${CHAMBER_NAME}_${scandate}.log ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseScan_${CHAMBER_NAME}_current.log" 2>&1 | tee -a ${LOGFILE}
    ln -sf ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseScan_${CHAMBER_NAME}_${scandate}.log ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseScan_${CHAMBER_NAME}_current.log 2>&1 | tee -a ${LOGFILE}
else
    echo "No GBT Phase Scan Results Found" 2>&1 | tee -a ${LOGFILE}
    echo "Connectivity Testing Probably Didn't Complete Successfully" 2>&1 | tee -a ${LOGFILE}
fi

# Move the GBT phase settings to ${DATA_PATH}/${CHAMBER_NAME}
phaseScanResults=${ELOG_PATH}/phases.log
if [ -f ${phaseScanResults} ]; then
    echo "mv ${phaseScanResults} ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseSetPoints_${CHAMBER_NAME}_${scandate}.log" 2>&1 | tee -a ${LOGFILE}
    mv ${phaseScanResults} ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseSetPoints_${CHAMBER_NAME}_${scandate}.log 2>&1 | tee -a ${LOGFILE}
    echo "unlink ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseSetPoints_${CHAMBER_NAME}_current.log" 2>&1 | tee -a ${LOGFILE}
    unlink ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseSetPoints_${CHAMBER_NAME}_current.log 2>&1 | tee -a ${LOGFILE}
    echo "ln -sf ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseSetPoints_${CHAMBER_NAME}_${scandate}.log ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseSetPoints_${CHAMBER_NAME}_current.log" 2>&1 | tee -a ${LOGFILE}
    ln -sf ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseSetPoints_${CHAMBER_NAME}_${scandate}.log ${DATA_PATH}/${CHAMBER_NAME}/gbtPhaseSetPoints_${CHAMBER_NAME}_current.log 2>&1 | tee -a ${LOGFILE}
else
    echo "No GBT Phase Settings Found" 2>&1 | tee -a ${LOGFILE}
    echo "Connectivity Testing Probably Didn't Complete Successfully" 2>&1 | tee -a ${LOGFILE}
fi

echo "ls -lhtr ${DATA_PATH}/${CHAMBER_NAME}/*${scandate}*.log" 2>&1 | tee -a ${LOGFILE}
ls -lhtr ${DATA_PATH}/${CHAMBER_NAME}/*${scandate}*.log 2>&1 | tee -a ${LOGFILE}

echo chmod g+rw -R ${DATA_PATH}/${CHAMBER_NAME}
chmod g+rw -R ${DATA_PATH}/${CHAMBER_NAME}
