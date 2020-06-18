#!/bin/bash

SHELF=$1

# Check inputs
if [ -z ${1+x} ] 
then
    echo "You must supply a uTCA shelf number, e.g. 'dumpAMC13.sh 1'"
    kill -INT $$
fi


DATE=$(date +%H.%M.%S-%d.%m.%Y)
echo Dumping AMC13 registers with DATE=$DATE

ORIG_DIR=$PWD
cd $ELOG_PATH
echo -e 'wu
exit' | \
    AMC13Tool2.exe -i gem.shelf0${SHELF}.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml \
    >& ${ELOG_PATH}/amc13.shelf0${SHELF}.reg.dump.${DATE}.txt

echo -e "\nDone, output is in ${ELOG_PATH}/amc13.shelf0${SHELF}.reg.dump.${DATE}.txt"
cd $ORIG_DIR
