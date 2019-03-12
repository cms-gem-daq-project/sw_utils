# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export LC_ALL="en_US.UTF-8"

##################  ALIASES #########################
source ~/.aliases

##################  GEM DAQ environment  ############
if [ -f /opt/cmsgemos/etc/profile.d/gemdaqenv.sh ]
then
    source /opt/cmsgemos/etc/profile.d/gemdaqenv.sh 
fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/wiscrpcsvc/lib/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/xhal/lib/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rwreg/lib/

export PATH=$PATH:/opt/reg_utils/bin/
export PATH=$PATH:/opt/xhal/bin/

export FIRMWARE_GEM=/home/gemuser/DAQ/fw

################## USER MESSAGES ####################

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NOCOL='\033[0m' # No Color

echo -e ""
echo -e "If the uTCA crate experienced a power cut recover the AMC13 follwoing instructions:"
echo -e "  ${BLUE}http://cmsonline.cern.ch/cms-elog/1060542${NOCOL}"
echo -e "Then recover the CTP7 following instructions:"
echo -e "  ${BLUE}http://cmsonline.cern.ch/cms-elog/1060543${NOCOL}"
echo -e ""

echo ""
echo "System address table links point to:"
ls -lhtr /home/gemuser/DAQ/fw/*.xml
echo "If any of the above links are broken your address tables will be set incorrectly."
echo -e "If you don't know how to correctly set these you ${RED}should not alter them.${NOCOL}"
echo ""

echo ""
echo 'Firmware files can be found under $FIRMWARE_GEM'
echo '   $FIRMWARE_GEM/oh_fw'
echo '   $FIRMWARE_GEM/ctp7'
echo ""

echo ""
echo "To connect to the AMC13 execute:"
echo -e ${GREEN}
echo '  AMC13Tool2.exe -i gem.shelf01.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml'
echo -e ${NOCOL}
echo ""

echo ""
echo "To launch the command line register interface with the CTP7 execute:"
echo -e "  ${GREEN}gem_reg.py${NOCOL}"
echo ""

echo ""
echo "To change the configuration that will be written when calling confChamber.py"
echo "edit the chamber_vfatDACSettings dictionary for the corresponding link in file:"
echo -e " ${GREEN}/home/gemuser/DAQ/chamberInfo.py${NOCOL}"
echo ""
echo "Note: editing other dictionaries in this file may lead to undefined behavior."

#################  MISC  ############################

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
export DATA_PATH=$HOME/data

