#!/bin/bash
# Usage:
#   calibrateArmDac.sh <DetName> <cardName> <link> <vfatmask> <Comma Separated List of CFG_THR_ARM_DAC Values>

helpstring="Usage:
    ./calibrateArmDac.sh [DetName] [cardName] [shelf]  [slot] [link] [vfatmask] [comma separated list of CFG_THR_ARM_DAC Values]
    ./calibrateArmDac.sh -r [PATH] [DetName] [cardName] [shelf] [slot] [link] [vfatmask] [comma separated list of CFG_THR_ARM_DAC Values]
        
    For each CFG_THR_ARM_DAC value specified will create a scandate directory, configure, print the configuration, and take an scurve

        DetName: Serial Number of Detector, this should be a subfolder under DATA_PATH variable
        cardName: CTP7 network alias or ip address
        link: OH number on the CTP7
        shelf: Shelf number
        slot: Slot number 
        vfatmask: 24-bit mask where a 1 in the n^th bit implies the n^th VFAT shall be excluded

    If -r [PATH] is provided, the directory [PATH] will be used instead of creating a new scandate directory and ARM DAC values for which a scurve log file already exists in that directory will be skipped
"

ISFILE=0;
OPTIND=1
while getopts "r:h" opts
do
    case $opts in
        r)
            RESUMEDIR=$OPTARG;;
        h)
            echo ${helpstring};;
        \?)
            echo ${helpstring};;
        [?])
            echo ${helpstring};;
    esac
done
shift $((OPTIND-1))
unset OPTIND

DETECTOR=$1
CARDNAME=$2
SHELF=$3
SLOT=$4
LINK=$5
MASK=$6
LIST_ARM_DAC=$7

# Check inputs
if [ -z ${7+x} ] 
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

echo -e "ChamberName\tscandate\tCFG_THR_ARM_DAC" 2>&1 | tee ${DATA_PATH}/${DETECTOR}/armDacCal/${scandate}/listOfScanDates_calibrateArmDac_${DETECTOR}.txt

if [ -z ${RESUMEDIR} ];
then
    scandate=$(date +%Y.%m.%d.%H.%M)
    OUTDIR=${DATA_PATH}/${DETECTOR}/armDacCal/${scandate}
    mkdir -p $OUTDIR
    ln -snf $OUTDIR ${DATA_PATH}/${DETECTOR}/armDacCal/current
else
    if [ ! -d ${RESUMEDIR} ];
    then
        echo "Error: provided directory ${RESUMEDIR} does not exist or is not a directory."
        return;
    fi
    OUTDIR=$RESUMEDIR
fi

runNum=0
for armDacVal in $(echo $LIST_ARM_DAC | sed "s/,/ /g")
do

    if [ -f $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt ]; then
        continue;
    fi

    echo "=============Run $runNum============="
    echo "Issuing a link reset before CFG_THR_ARM_DAC=${armDacVal}"
    echo "gem_reg.py -n ${CARDNAME} -e write 'GEM_AMC.GEM_SYSTEM.CTRL.LINK_RESET 1' 2>&1 | tee $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt"
    gem_reg.py -n ${CARDNAME} -e write "GEM_AMC.GEM_SYSTEM.CTRL.LINK_RESET 1" 2>&1 | tee $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "Configuring Detector for CFG_THR_ARM_DAC=${armDacVal}"
    echo "confChamber.py --shelf ${SHELF} -s ${SLOT} -g ${LINK} --vt1=${armDacVal} --vfatmask=${MASK} --zeroChan --run 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt"
    confChamber.py --shelf ${SHELF} -s ${SLOT} -g ${LINK} --vt1=${armDacVal} --vfatmask=${MASK} --zeroChan --run 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    first_unmasked_vfat=0
    mask_as_array=`echo "obase=2; ibase=16; \`echo $MASK | awk -F"0x" '{print $2}' | awk '{print toupper($1)}'\`;" | bc | grep -o .`
    i=0; for vfat in $mask_as_array; do echo $vfat; if [ $vfat == 0 ]; then first_unmasked_vfat=$i; break; fi; i=$(($i+1)); done;

    echo "Writing configuration for CFG_THR_ARM_DAC=${armDacVal} to file"
    echo "gem_reg.py -n ${CARDNAME} -e kw 'GEM_AMC.OH.OH${LINK}.GEB.VFAT${first_unmasked_vfat}.CFG_' 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt"
    echo "Configuration of All VFATs:" 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    gem_reg.py -n ${CARDNAME} -e kw "GEM_AMC.OH.OH${LINK}.GEB.VFAT${first_unmasked_vfat}.CFG_" 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "Writing IREF configuration for CFG_THR_ARM_DAC=${armDacVal} to file"
    echo "gem_reg.py -n ${CARDNAME} -e rwc 'GEM_AMC.OH.OH${LINK}.GEB.VFAT*.CFG_IREF' 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt"
    echo "CFG_IREF of All VFATs:" 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    gem_reg.py -n ${CARDNAME} -e rwc "GEM_AMC.OH.OH${LINK}.GEB.VFAT*.CFG_IREF" 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    scurve_scandate=$(date +%Y.%m.%d.%H.%M)
    echo "Making Directory: ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}"
    echo "mkdir -p ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}"
    mkdir -p ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}
    echo "unlink ${DATA_PATH}/${DETECTOR}/scurve/current"
    unlink ${DATA_PATH}/${DETECTOR}/scurve/current
    echo "ln -sf ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate} ${DATA_PATH}/${DETECTOR}/scurve/current"
    ln -sf ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate} ${DATA_PATH}/${DETECTOR}/scurve/current

    echo "Adding Entry to listOfScanDates_calibrateArmDac_${DETECTOR}.txt"
    echo -e "${DETECTOR}\t${scurve_scandate}\t${armDacVal}" 2>&1 | tee -a $OUTDIR/listOfScanDates_calibrateArmDac_${DETECTOR}.txt

    echo "Launching scurve for CFG_THR_ARM_DAC=${armDacVal}"
    echo "Scurve Output for scandate: ${scurve_scandate}" 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    echo "ultraScurve.py --shelf ${SHELF} -s ${SLOT} -g ${LINK} --vfatmask=${MASK} --latency=33 --mspl=3 --nevts=100 --voltageStepPulse --filename=${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}/SCurveData.root 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt"
    ultraScurve.py --shelf ${SHELF} -s ${SLOT} -g ${LINK} --vfatmask=${MASK} --latency=33 --mspl=3 --nevts=100 --voltageStepPulse --filename=${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}/SCurveData.root 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "Analyzing results"
    echo "Analysis Log for scandate: ${scurve_scandate}" 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    echo "anaUltraScurve.py -i ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}/SCurveData.root -c --calFile=${DATA_PATH}/${DETECTOR}/calFile_calDac_${DETECTOR}.txt -f --deadChanCutLow=0 --deadChanCutHigh=0 --highNoiseCut=20 --maxEffPedPercent=0.1 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt"
    anaUltraScurve.py -i ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}/SCurveData.root -c --calFile=${DATA_PATH}/${DETECTOR}/calFile_calDac_${DETECTOR}.txt -f --deadChanCutLow=0 --deadChanCutHigh=0 --highNoiseCut=20 --maxEffPedPercent=0.1 2>&1 | tee -a $OUTDIR/scurveLog_ArmDac_${armDacVal}.txt
    sleep 1

    echo "granting permissions to ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}"
    echo "chmod g+rw -R ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}"
    chmod g+rw -R ${DATA_PATH}/${DETECTOR}/scurve/${scurve_scandate}

    runNum=$(($runNum + 1))
done

echo "calibrateThrDac.py listOfScanDates_calibrateArmDac_${DETECTOR}.txt 2>&1 | tee $OUTDIR/armDacCalLog_${DETECTOR}.txt"

export ELOG_PATH=$OUTDIR/

calibrateThrDac.py listOfScanDates_calibrateArmDac_${DETECTOR}.txt 2>&1 | tee $OUTDIR/armDacCalLog_${DETECTOR}.txt

echo "Finished running all scans"

chmod g+rw -R $OUTDIR
