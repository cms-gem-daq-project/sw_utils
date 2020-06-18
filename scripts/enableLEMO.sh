#!/bin/bash

SHELF=$1

# Check inputs
if [ -z ${1+x} ] 
then
    echo "You must supply a uTCA shelf number, e.g. 'dumpAMC13.sh 1'"
    kill -INT $$
fi

echo Enabling LEMO input on gem.shelf0${SHELF}.amc13

echo -e 'wv CONF.TTC.T3_TRIG 1
exit' | \
    AMC13Tool2.exe -i gem.shelf0${SHELF}.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml 

echo -e "\nDone, T3_TRIG is now"
echo -e 'rv CONF.TTC.T3_TRIG
exit' | \
    AMC13Tool2.exe -i gem.shelf0${SHELF}.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml 
