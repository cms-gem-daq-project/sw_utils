#!/bin/zsh
# Usage:
#   calibrateVThreshold1DAC.sh <DetName> <cardName> <link> <vfatmask> <Comma Separated List of VThreshold1 Values>

helpstring="Usage:
    ./calibrateVThreshold1DAC.sh [DetName] [slot] [link] [vfatmask] [comma separated list of VThreshold1 Values]
        
    For each VThreshold1 value specified will create a scandate directory, configure, print the configuration, and take an scurve

        DetName: Serial Number of Detector, this should be a subfolder under DATA_PATH variable
	    slot: AMC slot number of the CTP7
        link: OH number on the CTP7
        vfatmask: 24-bit mask where a 1 in the n^th bit implies the n^th VFAT shall be excluded
"

DETECTOR=$1
SLOT=$2
LINK=$3
MASK=$4
LIST_ARM_DAC=$5

# Check inputs
if [ -z ${5+x} ] 
then
    echo ${helpstring}
    return
fi

#export DATA_PATH=/<your>/<data>/<directory>
if [ -z "$DATA_PATH" ]
then
    echo "DATA_PATH not set, please set DATA_PATH to a directory where data files created by scan applications will be written"
    echo " (export DATA_PATH=<your>/<data>/<directory>/) and then rerun this script"
    return
fi

echo -e "ChamberName\tscandate\tVThreshold1" 2>&1 | tee listOfScanDates_calibrateArmDac_${DETECTOR}.txt

runNum=0
for armDacVal in $(echo $LIST_ARM_DAC | sed "s/,/ /g")
do
    if [ -e scurveLog_ArmDac_${armDacVal}.txt ]
    then
        rm scurveLog_ArmDac_${armDacVal}.txt
    fi

    echo "=============Run $runNum============="
    echo "Configuring Detector for VThreshold1=${armDacVal}"
    echo "confChamber.py -s ${SLOT} -g ${LINK} --vt1=${armDacVal} --vfatmask=${MASK} --run 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt"
    confChamber.py -s ${SLOT} -g ${LINK} --vt1=${armDacVal} --vfatmask=${MASK} --run 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    sleep 1
    
    echo "Writing configuration for VThreshold1=${armDacVal} to file"
    echo "Configuration of All VFATs:" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    echo "vfat_info_uhal.py --shelf=1 -s ${SLOT} -g ${LINK}" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    vfat_info_uhal.py --shelf=1 -s ${SLOT} -g ${LINK} 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    scandate=$(date +%Y.%m.%d.%H.%M)
    echo "Making Directory: ${DATA_PATH}/${DETECTOR}/scurve/${scandate}"
    echo "mkdir -p ${DATA_PATH}/${DETECTOR}/scurve/${scandate}"
    mkdir -p ${DATA_PATH}/${DETECTOR}/scurve/${scandate}
    echo "unlink ${DATA_PATH}/${DETECTOR}/scurve/current"
    unlink ${DATA_PATH}/${DETECTOR}/scurve/current
    echo "ln -sf ${DATA_PATH}/${DETECTOR}/scurve/${scandate} ${DATA_PATH}/${DETECTOR}/scurve/current"
    ln -sf ${DATA_PATH}/${DETECTOR}/scurve/${scandate} ${DATA_PATH}/${DETECTOR}/scurve/current

    echo "Adding Entry to listOfScanDates_calibrateArmDac_${DETECTOR}.txt"
    echo -e "${DETECTOR}\t${scandate}\t${armDacVal}" 2>&1 | tee -a listOfScanDates_calibrateArmDac_${DETECTOR}.txt

    echo "Launching scurve for VThreshold1=${armDacVal}"
    echo "Scurve Output for scandate: ${scandate}" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    echo "ultraScurve.py -s ${SLOT} -g ${LINK} --vfatmask=${MASK} --filename=${DATA_PATH}/${DETECTOR}/scurve/${scandate}/SCurveData.root 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt"
    ultraScurve.py -s ${SLOT} -g ${LINK} --vfatmask=${MASK} --filename=${DATA_PATH}/${DETECTOR}/scurve/${scandate}/SCurveData.root 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "Analyzing results"
    echo "Analysis Log for scandate: ${scandate}" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    echo "anaUltraScurve.py -i ${DATA_PATH}/${DETECTOR}/scurve/${scandate}/SCurveData.root -f 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt"
    anaUltraScurve.py -i ${DATA_PATH}/${DETECTOR}/scurve/${scandate}/SCurveData.root -f 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "granting permissions to ${DATA_PATH}/${DETECTOR}/scurve/${scandate}"
    echo "chmod g+rw -R ${DATA_PATH}/${DETECTOR}/scurve/${scandate}"
    chmod g+rw -R ${DATA_PATH}/${DETECTOR}/scurve/${scandate}

    runNum=$(($runNum + 1))
done

echo "calibrateThrDac.py listOfScanDates_calibrateArmDac_${DETECTOR}.txt 2>&1 | tee armDacCalLog_${DETECTOR}.txt"
calibrateThrDac.py listOfScanDates_calibrateArmDac_${DETECTOR}.txt 2>&1 | tee armDacCalLog_${DETECTOR}.txt

echo "Finished running all scans"
