# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export LC_ALL="en_US.UTF-8"

# Set umask for group read and write
umask g+rw

##################  Colors ##########################
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NOCOL='\033[0m' # No Color

##################  ALIASES #########################
source ~/.aliases

##################  GEM DAQ environment  ############
#if [ -f /opt/cmsgemos/etc/profile.d/gemdaqenv.sh ]
if [ -f /data/bigdisk/sw/gemdaqenv.sh ]
then
    #source /opt/cmsgemos/etc/profile.d/gemdaqenv.sh 
    source /data/bigdisk/sw/gemdaqenv.sh
else
    echo "${RED}ERROR: /data/bigdisk/sw/gemdaqenv.sh NOT FOUND${NOCOL}"
    echo "${RED}	Environment NOT Set!!!${NOCOL}"
    kill -INT $$
fi

# setup gemdaq
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/wiscrpcsvc/lib/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/xhal/lib/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rwreg/lib/

export PATH=$PATH:/opt/reg_utils/bin/
export PATH=$PATH:/opt/xhal/bin/

export BUILD_HOME=/home/gemuser/gemdaq
export DATA_PATH=/data/bigdisk/GEM-Data-Taking/GE11_QC8/
export ELOG_PATH=$BUILD_HOME/gemelog
export FIRMWARE_GEM=/data/bigdisk/GEMDAQ_Documentation/system/firmware/files
export GBT_SETTINGS=/data/bigdisk/GEMDAQ_Documentation/system/OptoHybrid/V3/GBT_Files

# LDQM DB Locations
export GEM_DB_HOST=gem904qc8daq.cern.ch
#export GEM_DB_NAME=ldqm_tif_qc8_db
export GEM_DB_PORT=3306

# GEM Online DB Locations
export GEM_ONLINE_DB_NAME="enter db name"
export GEM_ONLINE_DB_CONN="enter db connection"

# Add config tools to path
export PATH=$BUILD_HOME/config/daq/:$PATH

# Add gemplotting tools to the path
export PATH=/usr/lib/python2.7/site-packages/gempython/gemplotting/macros/:$PATH

# Add light-dqm tools to the path
export PATH=$BUILD_HOME/gem-light-dqm/gemtreewriter/bin/linux/x86_64_centos7/:$PATH
export PATH=$BUILD_HOME/gem-light-dqm/dqm-root/bin/linux/x86_64_centos7/:$PATH

# Add sw_utils to path
export PATH=$BUILD_HOME/sw_utils/scripts/:$PATH

# Add gem_ops scripts
export PATH=$BUILD_HOME/gem_ops/DCS_STATUS:$PATH

# Add system specific hardware constants to PYTHONPATH
export PYTHONPATH=/home/gemuser/gemdaq/config:$PYTHONPATH

################## USER MESSAGES ####################

echo -e ""
echo "Current umask is:"
umask -S
echo ""
echo -e "If the system experienced a power cut to recover follow instructions:"
echo -e "  ${BLUE}https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#recovering-from-a-power-cut${NOCOL}"
echo -e "An example of a successful CTP7 recovery is shown:"
echo -e "  ${BLUE}http://cmsonline.cern.ch/cms-elog/1060543${NOCOL}"
echo -e ""
echo 'Firmware files can be found under $FIRMWARE_GEM'
echo '   $FIRMWARE_GEM/OptoHybrid'
echo '   $FIRMWARE_GEM/CTP7'
echo ""
echo 'GBT Settings can be found under $GBT_SETTINGS/OHv3c'
echo ""
echo "To connect to the AMC13 for eagle23, eagle26 & eagle35 execute:"
echo -e ${GREEN}
echo '  AMC13Tool2.exe -i gem.shelf01.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml'
echo -e ${NOCOL}
echo ""
echo "To connect to the AMC13 for eagle60 execute:"
echo -e ${GREEN}
echo '  AMC13Tool2.exe -i gem.shelf02.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml'
echo -e ${NOCOL}
echo ""
echo "To launch the command line register interface with the CTP7 execute:"
echo -e "  ${GREEN}gem_reg.py${NOCOL}"
echo ""
echo "To change the configuration that will be written when calling confChamber.py"
echo "edit the chamber_vfatDACSettings dictionary for the corresponding link by calling:"
#echo -e " ${GREEN}/home/gemuser/DAQ/chamberInfo.py${NOCOL}"
echo -e "   ${GREEN}editConfig${NOCOL}"
echo ""
echo "Note: editing other dictionaries in this file may lead to undefined behavior."
echo ""
echo -e "The available screen's are: ${GREEN}"
screen -list
echo -e "${NOCOL}You should launch scan applications within a screen!"
echo -e "To dettach from a screen press ${BLUE}'Ctrl+A' then 'D'${NOCOL}"
echo -e "To scroll inside a screen press ${BLUE}'Ctrl+A' then 'Esc'${NOCOL}"
echo -e "To stop scrolling inside a scree press ${BLUE}'Esc'${NOCOL}"
echo -e "To attach to a screen execute: ${BLUE}screen -r -S SCREENNAME${NOCOL}"
echo ""
echo -e "The RCMS server for 904 is accessible at:"
echo -e "   ${BLUE}http://gem904daq01:10000/rcms/gui/servlet/FMPilotServlet${NOCOL}"
echo ""

#################  MISC  ############################

export PATH=$PATH:$HOME/.local/bin:$HOME/bin
