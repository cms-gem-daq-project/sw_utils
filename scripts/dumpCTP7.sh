#!/bin/bash

CARDNAME=$1

# Check inputs
if [ -z ${1+x} ] 
then
    echo "You must supply a CTP7 cardname, e.g. 'dumpCTP7.sh eagle35'"
    kill -INT $$
fi

DATE=$(date +%H.%M.%S-%d.%m.%Y)

echo Running remote reg_interface with DATE=$DATE
ssh gemuser@${CARDNAME} "sh -lic '(/mnt/persistent/gemdaq/bin/dumpCTP7)'" >& ${ELOG_PATH}/ctp7.${CARDNAME}.reg.dump.${DATE}.txt

echo -e "\nDone, output is in ${ELOG_PATH}/ctp7.${CARDNAME}.reg.dump.${DATE}.txt"
