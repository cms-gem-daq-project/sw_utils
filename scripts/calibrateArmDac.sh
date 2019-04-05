#!/bin/bash
usage() {
    echo './calibrateArmDac.sh -s slot -l link  -L armdaclist [-D detName] [-S shelf] [-m vfatmask] [-r path]'
    echo ''
    echo '    slot: Slot number'
    echo '    link: OH number on the CTP7'
    echo '    armdaclist: comma separate list of CFG_THR_ARM_DAC Values (e.g. 25,30,35,40,45,50)'
    echo '    detName: Serial Number of Detector, this should be a subfolder under DATA_PATH variable'
    echo '    shelf: Shelf number'
    echo '    vfatmask: 24-bit mask where a 1 in the n^th bit implies the n^th VFAT shall be excluded'
    echo '    path: output directory to be used instead of creating a new scandated directory'
    echo ''
    echo 'For each CFG_THR_ARM_DAC value specified will create a scandate directory, configure, print the configuration, and take an scurve. If "-r path" is provided, ARM DAC values for which an scurve log file already exists in the provided directory will be skipped.'
    kill -INT $$;
}



ISFILE=0;
OPTIND=1
while getopts "r:S:s:l:m:L:d:h" opts
do
    case $opts in
        s)
            SLOT=$OPTARG;;
        l)
            LINK=$OPTARG;;
        L)
            LIST_ARM_DAC=$OPTARG;;
        r)
            RESUMEDIR=$OPTARG;;
        S)
            SHELF=$OPTARG;;
        m)
            MASK=$OPTARG;;
        d)
            DETECTOR=$OPTARG;;
        h)
            usage;;
        \?)
            usage;;
        [?])
            usage;;
    esac
done
shift $((OPTIND-1))
unset OPTIND

if [ -z "$LIST_ARM_DAC" ] || [ -z "$SLOT" ] || [ -z "$LINK" ]
then
    usage
fi

if [ -z "$SHELF" ]
then
    SHELF=1
fi

if (( $SHELF < 10 ))
then
    SHELFSTRING="0${SHELF}"
else
    SHELFSTRING=$SHELF
fi

if (( $SLOT < 10 ))
then
    SLOTSTRING="0${SLOT}"
else
    SLOTSTRING=$SLOT
fi

CARDNAME="gem-shelf${SHELFSTRING}-amc${SLOTSTRING}"

if [ -z "$DETECTOR" ]
then
    DETECTOR=`python -c "from gempython.gemplotting.mapping.chamberInfo import chamber_config; print chamber_config[(${SHELF},${SLOT},${LINK})]" | tail -n1`
fi

if [ -z "$MASK"] 
then
    MASK=`python -c "from gempython.tools.amc_user_functions_xhal import HwAMC; amcboard = HwAMC('${CARDNAME}'); print str(hex(amcboard.getLinkVFATMask(${LINK}))).strip('L')" | tail -n 1`
fi

#export DATA_PATH=/<your>/<data>/<directory>
if [ -z "$DATA_PATH" ]
then
    echo "DATA_PATH not set, please set DATA_PATH to a directory where data files created by scan applications will be written"
    echo " (export DATA_PATH=<your>/<data>/<directory>/) and then rerun this script"
    return
fi

if [ -z "$RESUMEDIR" ];
then
    scandate=$(date +%Y.%m.%d.%H.%M)
    OUTDIR=${DATA_PATH}/${DETECTOR}/armDacCal/${scandate}
    mkdir -p $OUTDIR
    chmod g+rw $OUTDIR
    ln -snf $OUTDIR ${DATA_PATH}/${DETECTOR}/armDacCal/current
    echo -e "ChamberName\tscandate\tCFG_THR_ARM_DAC" 2>&1 | tee $OUTDIR/listOfScanDates_calibrateArmDac_${DETECTOR}.txt
else
    if [ ! -d "$RESUMEDIR" ];
    then
        echo "Error: provided directory ${RESUMEDIR} does not exist or is not a directory."
        return;
    fi
    OUTDIR=$RESUMEDIR
    #when running in resume mode, the list of scan dates file should already exist and we should not write the header again
    if [ ! -f $OUTDIR/listOfScanDates_calibrateArmDac_${DETECTOR}.txt ]; then
        echo -e "ChamberName\tscandate\tCFG_THR_ARM_DAC" 2>&1 | tee $OUTDIR/listOfScanDates_calibrateArmDac_${DETECTOR}.txt
    fi
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

    echo "Finding the first unmasked VFAT"
    first_unmasked_vfat=-1
    mask_as_array=`echo "obase=2; ibase=16; \`echo $MASK | awk -F"0x" '{print $2}' | awk '{print toupper($1)}'\`;" | bc | grep -o .`
    i=0;
    for vfat in $mask_as_array;
    do
        echo "Checking VFAT ${vfat}";
        if [ $vfat == 0 ];
        then
            first_unmasked_vfat=$i;
            print "The first unmasked VFAT is VFAT ${vfat}"
            break;
        fi;
        i=$(($i+1));
    done;
    
    if (( $first_unmasked_vfat < 0 || $first_unmasked_vfat > 23 ))
    then
        print "Problem finding the first unmasked VFAT, exiting"
        kill -INT $$
    fi
    
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

export ELOG_PATH=$OUTDIR/

#in a venv, the scripts in the macros directory of gem-plotting-tools, including calibrateThrDac.py, are not set as executable when they are installed
if [ $VIRTUAL_ENV ]
   then
       chmod a+x `find $VIRTUAL_ENV -name calibrateThrDac.py`;
fi

echo "calibrateThrDac.py $OUTDIR/listOfScanDates_calibrateArmDac_${DETECTOR}.txt 2>&1 | tee $OUTDIR/armDacCalLog_${DETECTOR}.txt"
calibrateThrDac.py $OUTDIR/listOfScanDates_calibrateArmDac_${DETECTOR}.txt 2>&1 | tee $OUTDIR/armDacCalLog_${DETECTOR}.txt

echo "Finished running all scans"

chmod g+rw -R $OUTDIR
