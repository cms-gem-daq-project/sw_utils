#!/bin/bash -e

usage() {
    echo "Usage: $0 <ztrim> <configname> <step> <scandate>"
    echo "     <ztrim> is an number corresponding to the set trim value"
    echo "     <configname> is the name of the new config to create (should be identical for each of the three steps"
    echo "     <step> is the step in the config generation process"
    echo "       - 1 is post trim"
    echo "       - 2 is post per-channel threshold scan"
    echo "       - 3 is post per-vfat trigger data threshold scan"
    echo "       - 4 is to set the configureation to a previous named configuration"
    echo "     <scandate> is the date of the scan used as input (trim or threshold, only for creating a new config)"
    echo "       - YYYY.MM.DD.HH.mm or YYYY-MM-DD-HH-mm numerical format"
    echo
    exit 0
}

zre='^[0-9]+([.][0-9]+)?$'
sre='^[1-4]$'
dre='^20[0-9][0-9][-.](0?[1-9]|1[0-2])[-.](0?[1-9]|[12]?[0-9]|3?[01])[-.]([01]?[0-9]|2?[0-3])[-.][0-5][0-9]$'
if ! [[ "$3" =~ $sre ]]
then
    echo "Error: $3 is not a valid step (1,2,3,4)";
    usage
fi

if ! [ "$3" == "4" ]
then
    if [ -z $4 ]
    then
        echo "Invalid usage: $0 $1 $2 $3 $4"
        usage
    elif ! [[ "$4" =~ $dre ]]
    then
        echo "Error: $4 is not a valid scandate";
        usage
    fi
fi

if ! [[ "$1" =~ $zre ]]
then
    echo "Error: $1 is not a valid ztrim";
    usage
fi

conftrim=$1
confname=$2
confstep=$3
scandate=$4

ztrim=$(printf "z%0.6f" ${conftrim})
shortztrim=$(printf "z%0.1f" ${conftrim})

confdirbase="/gemdata/configs"
newconfdir=${confdirbase}/${shortztrim}/${confname}

geminis=( 01 27 28 29 30 )
layers=( "L1" "L2" )

if ! [ "${confstep}" = "4" ]
then
    mkdir -p ${newconfdir}
fi
nfailed=0
for chamber in "${geminis[@]}"
do
    for layer in "${layers[@]}"
    do
        if [ "${confstep}" = "1" ]
        then
            if ! [ -d /gemdata/GEMINIm${chamber}${layer}/trim/${ztrim}/${scandate} ]
            then
                echo "No scan present for /gemdata/GEMINIm${chamber}${layer}/trim/${ztrim}/${scandate}"
                nfailed=$((nfailed+1))
                continue
            fi
            ln -sfn ${scandate} /gemdata/GEMINIm${chamber}${layer}/trim/${ztrim}/config
            cp /gemdata/GEMINIm${chamber}${layer}/trim/${ztrim}/${scandate}/SCurveData_Trimmed/chConfig.txt ${newconfdir}/chConfig_Original_GEMINIm${chamber}${layer}_${scandate}.txt
            ln -sfn chConfig_Original_GEMINIm${chamber}${layer}_${scandate}.txt ${newconfdir}/chConfig_Original_GEMINIm${chamber}${layer}.txt
            ln -sfn ${confname}/chConfig_Original_GEMINIm${chamber}${layer}.txt /gemdata/configs/${shortztrim}/chConfig_GEMINIm${chamber}${layer}.txt
        elif [ "${confstep}" = "2" ]
        then
            if ! [ -d /gemdata/GEMINIm${chamber}${layer}/threshold/channel/${scandate} ]
            then
                echo "No scan present for /gemdata/GEMINIm${chamber}${layer}/threshold/channel/${scandate}"
                nfailed=$((nfailed+1))
                continue
            fi
            cp /gemdata/GEMINIm${chamber}${layer}/threshold/channel/${scandate}/ThresholdScanData/vfatConfig.txt ${newconfdir}/vfatConfig_Original_GEMINIm${chamber}${layer}_${scandate}.txt
            ln -sfn vfatConfig_Original_GEMINIm${chamber}${layer}_${scandate}.txt ${newconfdir}/vfatConfig_Original_GEMINIm${chamber}${layer}.txt
            ln -sfn ${confname}/vfatConfig_Original_GEMINIm${chamber}${layer}.txt /gemdata/configs/${shortztrim}/vfatConfig_GEMINIm${chamber}${layer}.txt
            cp /gemdata/GEMINIm${chamber}${layer}/threshold/channel/${scandate}/ThresholdScanData/chConfig_MasksUpdated.txt ${newconfdir}/chConfig_MasksUpdated_GEMINIm${chamber}${layer}_${scandate}.txt
            ln -sfn chConfig_MasksUpdated_GEMINIm${chamber}${layer}_${scandate}.txt ${newconfdir}/chConfig_MasksUpdated_GEMINIm${chamber}${layer}.txt
            ln -sfn ${confname}/chConfig_MasksUpdated_GEMINIm${chamber}${layer}.txt /gemdata/configs/${shortztrim}/chConfig_GEMINIm${chamber}${layer}.txt
        elif [ "${confstep}" = "3" ]
        then
            if ! [ -d /gemdata/GEMINIm${chamber}${layer}/threshold/vfat/trig/${scandate} ]
            then
                echo "No scan present for /gemdata/GEMINIm${chamber}${layer}/threshold/vfat/trig/${scandate}"
                nfailed=$((nfailed+1))
                continue
            fi
            cp /gemdata/GEMINIm${chamber}${layer}/threshold/vfat/trig/${scandate}/ThresholdScanData/vfatConfig.txt ${newconfdir}/vfatConfig_Updated_GEMINIm${chamber}${layer}_${scandate}.txt
            ln -sfn vfatConfig_Updated_GEMINIm${chamber}${layer}_${scandate}.txt ${newconfdir}/vfatConfig_Updated_GEMINIm${chamber}${layer}.txt
            ln -sfn ${confname}/vfatConfig_Updated_GEMINIm${chamber}${layer}.txt /gemdata/configs/${shortztrim}/vfatConfig_GEMINIm${chamber}${layer}.txt
        elif [ "${confstep}" = "4" ]
        then
            if [ -f ${newconfdir}/chConfig_MasksUpdated_GEMINIm${chamber}${layer}.txt ]
            then
                ln -sfn ${confname}/chConfig_MasksUpdated_GEMINIm${chamber}${layer}.txt /gemdata/configs/${shortztrim}/chConfig_GEMINIm${chamber}${layer}.txt
            elif [ -f ${newconfdir}/chConfig_Original_GEMINIm${chamber}${layer}.txt ]
            then
                ln -sfn ${confname}/chConfig_Original_GEMINIm${chamber}${layer}.txt /gemdata/configs/${shortztrim}/chConfig_GEMINIm${chamber}${layer}.txt
            else
                echo "Unable to find channel configuration in ${confname} for GEMINIm${chamber}${layer}"
                nfailed=$((nfailed+1))
            fi

            if [ -f ${newconfdir}/vfatConfig_Updated_GEMINIm${chamber}${layer}.txt ]
            then
                ln -sfn ${confname}/vfatConfig_Updated_GEMINIm${chamber}${layer}.txt /gemdata/configs/${shortztrim}/vfatConfig_GEMINIm${chamber}${layer}.txt
            elif [ -f ${newconfdir}/vfatConfig_Original_GEMINIm${chamber}${layer}.txt ]
            then
                ln -sfn ${confname}/vfatConfig_Original_GEMINIm${chamber}${layer}.txt /gemdata/configs/${shortztrim}/vfatConfig_GEMINIm${chamber}${layer}.txt
                echo "Unable to find VFAT configuration in ${confname} for GEMINIm${chamber}${layer}"
                nfailed=$((nfailed+1))
            fi
        fi
    done
done

if [ "${confstep}" = "1" ]
then
    echo "Step 1 completed with ${nfailed} missing inputs."
    echo "Verify from the above output that things happened as expected and then exectue:"
    echo "sudo -u gempro -i confAllChambers.py -s3 --ztrim=<trimvalue>"
    echo "sudo -u gempro -i run_scans.py --tool=ultraThreshold.py --perchannel --nevts 1000 -s3 2>&1 | tee -a threshold_log.txt"
    echo "sudo -u gempro -i ana_scans.py --scandate=<date of previous threshold scan> --scandatetrim=${scandate} --chConfigKnown --ztrim=${conftrim} --anaType=thresholdch  2>&1 | tee -a ana_threshold_log.txt"
    echo "sudo -u gempro -i $0 $1 $2 2 <threshold scan date>"
elif [ "${confstep}" = "2" ]
then
    echo "Step 2 completed with ${nfailed} missing inputs."
    echo "Verify from the above output that things happened as expected and then exectue:"
    echo "sudo -u gempro -i confAllChambers.py -s3 --ztrim=<trimvalue> --config"
    echo "sudo -u gempro -i run_scans.py --tool=ultraThreshold.py --nevts 10000000 -s3 2>&1 | tee -a threshold_log.txt"
    echo "sudo -u gempro -i ana_scans.py --scandate=<date of previous threshold scan> --ztrim=${conftrim} --anaType=thresholdvftrig 2>&1 | tee -a ana_threshold_log.txt"
    echo "sudo -u gempro -i $0 $1 $2 3 <threshold scan date>"
elif [ "${confstep}" = "3" ]
then
    echo "Step 3 completed with ${nfailed} missing inputs."
    echo "Verify from the above output that things happened as expected."
    echo "If so, the new configuration should be in ${newconfdir} and linked to /gemdata/configs/${shortztrim}"
    echo "To change at any future time back to this (${newconfdir}) configuration execute:"
    echo "sudo -u gempro -i $0 $1 $2 3"
elif [ "${confstep}" = "4" ]
then
    echo "Step 4 completed with ${nfailed} missing inputs."
    echo "Verify from the above output that things happened as expected."
    echo "If so the configuration ${newconfdir} is correctly linked to /gemdata/configs/${shortztrim}"
fi
