#!/bin/bash

SHELF=$1

# Check inputs
if [ -z ${1+x} ] 
then
    echo "You must supply a uTCA shelf number, e.g. 'dumpAMC13.sh 1'"
    kill -INT $$
fi

ORIG_DIR=$PWD
echo -e 'st
exit' | \
    AMC13Tool2.exe -i gem.shelf0${SHELF}.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml \
    | grep "L1A"
