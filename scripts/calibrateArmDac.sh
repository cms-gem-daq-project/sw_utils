#!/bin/zsh
# Usage:
#   executeScurveProgram.sh <DetName> <cardName> <link> <vfatmask> <Comma Separated List of CFG_THR_ARM_DAC Values>

helpstring="Usage:
    ./executeScurveProgram.sh [DetName] [cardName] [link] [vfatmask] [comma separated list of CFG_THR_ARM_DAC Values]
        
    For each CFG_THR_ARM_DAC value specified will create a scandate directory, configure, print the configuration, and take an scurve

        DetName: Serial Number of Detector, this should be a subfolder under DATA_PATH variable
        cardName: CTP7 network alias or ip address
        link: OH number on the CTP7
        vfatmask: 24-bit mask where a 1 in the n^th bit implies the n^th VFAT shall be excluded
"

DETECTOR=$1
CARDNAME=$2
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

echo -e "ChamberName\tscandate\tCFG_THR_ARM_DAC" 2>&1 | tee listOfScanDates_calibrateArmDac_${DETECTOR}.txt

runNum=0
for armDacVal in $(echo $LIST_ARM_DAC | sed "s/,/ /g")
do
    if [ -e scurveLog_ArmDac_${armDacVal}.txt ]
    then
        rm scurveLog_ArmDac_${armDacVal}.txt
    fi

    echo "=============Run $runNum============="
    echo "Issuing a link reset before CFG_THR_ARM_DAC=${armDacVal}"
    echo "gem_reg.py -n ${CARDNAME} -e write 'GEM_AMC.GEM_SYSTEM.CTRL.LINK_RESET 1' 2>&1 | tee scurveLog_ArmDac_${armDacVal}.txt"
    gem_reg.py -n ${CARDNAME} -e write "GEM_AMC.GEM_SYSTEM.CTRL.LINK_RESET 1" 2>&1 | tee scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "Configuring Detector for CFG_THR_ARM_DAC=${armDacVal}"
    echo "confChamber.py -c ${CARDNAME} -g ${LINK} --vt1=${armDacVal} --vfatmask=${MASK} --zeroChan --run 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt"
    confChamber.py -c ${CARDNAME} -g ${LINK} --vt1=${armDacVal} --vfatmask=${MASK} --zeroChan --run 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    sleep 1
    
    echo "Writing configuration for CFG_THR_ARM_DAC=${armDacVal} to file"
    echo "gem_reg.py -n ${CARDNAME} -e kw 'GEM_AMC.OH.OH${LINK}.GEB.VFAT0.CFG_' 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt"
    echo "Configuration of All VFATs:" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    gem_reg.py -n ${CARDNAME} -e kw "GEM_AMC.OH.OH${LINK}.GEB.VFAT0.CFG_" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "Writing IREF configuration for CFG_THR_ARM_DAC=${armDacVal} to file"
    echo "gem_reg.py -n ${CARDNAME} -e rwc 'GEM_AMC.OH.OH${LINK}.GEB.VFAT*.CFG_IREF' 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt"
    echo "CFG_IREF of All VFATs:" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    gem_reg.py -n ${CARDNAME} -e rwc "GEM_AMC.OH.OH${LINK}.GEB.VFAT*.CFG_IREF" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
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

    echo "Launching scurve for CFG_THR_ARM_DAC=${armDacVal}"
    echo "Scurve Output for scandate: ${scandate}" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    echo "ultraScurve.py -c ${CARDNAME} -g ${LINK} --vfatmask=${MASK} --latency=33 --mspl=3 --nevts=100 --voltageStepPulse --filename=${DATA_PATH}/${DETECTOR}/scurve/${scandate}/SCurveData.root 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt"
    ultraScurve.py -c ${CARDNAME} -g ${LINK} --vfatmask=${MASK} --latency=33 --mspl=3 --nevts=100 --voltageStepPulse --filename=${DATA_PATH}/${DETECTOR}/scurve/${scandate}/SCurveData.root 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "Analyzing results"
    echo "Analysis Log for scandate: ${scandate}" 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    echo "anaUltraScurve.py -i ${DATA_PATH}/${DETECTOR}/scurve/${scandate}/SCurveData.root -c --calFile=${DATA_PATH}/${DETECTOR}/scurve/calFile_${DETECTOR}.txt -f --isVFAT3 --deadChanCutLow=0 --deadChanCutHigh=0.45 --highNoiseCut=20 --maxEffPedPercent=0.1 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt"
    anaUltraScurve.py -i ${DATA_PATH}/${DETECTOR}/scurve/${scandate}/SCurveData.root -c --calFile=${DATA_PATH}/${DETECTOR}/scurve/calFile_${DETECTOR}.txt -f --isVFAT3 --deadChanCutLow=0 --deadChanCutHigh=0.45 --highNoiseCut=20 --maxEffPedPercent=0.1 2>&1 | tee -a scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "granting permissions to ${DATA_PATH}/${DETECTOR}/scurve/${scandate}"
    echo "chmod g+rw -R ${DATA_PATH}/${DETECTOR}/scurve/${scandate}"
    chmod g+rw -R ${DATA_PATH}/${DETECTOR}/scurve/${scandate}

    runNum=$(($runNum + 1))
done

echo "calibrateThrDac.py listOfScanDates_calibrateArmDac_${DETECTOR}.txt 2>&1 | tee armDacCalLog_${DETECTOR}.txt"
calibrateThrDac.py listOfScanDates_calibrateArmDac_${DETECTOR}.txt 2>&1 | tee armDacCalLog_${DETECTOR}.txt

echo "Finished running all scans"
