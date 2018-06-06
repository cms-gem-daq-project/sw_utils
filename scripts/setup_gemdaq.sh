#!/bin/zsh
invoked=$_
OPTIND=1

helpstring="Usage: $0 [options] -p </path/to/venv/location>
    Options:
        -c cmsgemos release version (e.g. X.Y.Z)
        -d debug information is printed
        -g gemplotting release version (e.g. X.Y.Z)
        -G gemplotting dev version (e.g. single integer)
        -h displays this string
        -v vfatqc release version (e.g. X.Y.Z)
        -V vfatqc dev version (e.g. single integer)
        -w No value following, deletes and recreates the venv from scratch

    The virtualenv found at -p will either be activated or created"

CMSGEMOS_VERSION=""
DEBUG=""
GEMPLOT_VERSION=""
GEMPLOT_DEV_VERSION=""
VFATQC_VERSION=""
VFATQC_DEV_VERSION=""
VENV_ROOT=""
WIPE=""

while getopts "c:g:G:v:V:p:wh" opts
do
    case $opts in
        c)
            CMSGEMOS_VERSION="$OPTARG";;
        d)
            DEBUG="true";;
        g)
            GEMPLOT_VERSION="$OPTARG";;
        G)
            GEMPLOT_DEV_VERSION="$OPTARG";;
        v)
            VFATQC_VERSION="$OPTARG";;
        V)
            VFATQC_DEV_VERSION="$OPTARG";;
        p)
            VENV_ROOT="$OPTARG";;
        w)
            WIPE=1;;
        h)
            echo >&2 ${helpstring}
            return 1;;
        \?)
            echo >&2 ${helpstring}
            return 1;;
        [?])
            echo >&2 ${helpstring}
            return 1;;
    esac
done

# Check if user provided the venv argument
if [ -n "$DEBUG" ]
then
    echo VENV_ROOT $VENV_ROOT
    echo CMSGEMOS_VERSION $CMSGEMOS_VERSION
    echo GEMPLOT_VERSION $GEMPLOT_VERSION
    echo GEMPLOT_DEV_VERSION $GEMPLOT_DEV_VERSION
    echo VFATQC_VERSION $VFATQC_VERSION
    echo VFATQC_DEV_VERSION $VFATQC_DEV_VERSION
    echo WIPE $WIPE
fi

if [ ! -n "$VENV_ROOT" ]
then
    echo "you must provide the -p argument"
    echo >&2 ${helpstring}
    return 1
fi

#export ELOG_PATH=/<your>/<elog>/<directory>
if [ -z "$ELOG_PATH" ]
then
    echo "ELOG_PATH not set, please set ELOG_PATH to a directory where plots created by analysis applications will be written"
    echo " (export ELOG_PATH=<your>/<elog>/<directory>/) and then rerun this script"
    return 1
fi

# setup LCG view ?
####################
SYSTEM_INFO="$(uname -a)"
KERNEL_VERSION="$(uname -r)"
if [[ $KERNEL_VERSION == *"2.6."* ]];
then
    if [[ $SYSTEM_INFO == *"lxplus"* ]];
    then
        source /cvmfs/sft.cern.ch/lcg/views/LCG_93/x86_64-slc6-gcc7-opt/setup.sh
    fi
    OS_VERSION="slc6"
elif [[ $KERNEL_VERSION == *"3.10."* ]];
then
    if [[ $SYSTEM_INFO == *"lxplus"* ]];
    then
        source /cvmfs/sft.cern.ch/lcg/views/LCG_93/x86_64-centos7-gcc7-opt/setup.sh
    fi
    OS_VERSION="cc7"
else
  echo "operating system not recognized"
  echo "env is not set"
  return 1
fi

# setup virtualenv
####################
PYTHON_VERSION=$(python -c "import sys; sys.stdout.write(sys.version[:3])") 
VENV_DIR=${VENV_ROOT}/${OS_VERSION}/py${PYTHON_VERSION}

if [ -n "$DEBUG" ]
then
    echo SYSTEM_INFO $SYSTEM_INFO
    echo KERNEL_VERSION $KERNEL_VERSION
    echo OS_VERSION $OS_VERSION
    echo PYTHON_VERSION $PYTHON_VERSION
    echo VENV_DIR $VENV_DIR
fi

# Check if user wants to start from scratch
if [[ $WIPE == "1" ]];
then 
    /bin/rm -rf $VENV_DIR

    if [[ ( -e cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz ) && ( ! -z  ${CMSGEMOS_VERSION} ) ]]
    then
        /bin/rm cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz
    fi

    if [[ ( -e gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz) && ( ! -z ${GEMPLOT_VERSION} ) ]]
    then 
        /bin/rm gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
    fi

    if [[ ( -e gempython_vfatqc-${VFATQC_VERSION}.tar.gz) && ( ! -z ${VFATQC_VERSION} ) ]]
    then
        /bin/rm gempython_vfatqc-${VFATQC_VERSION}.tar.gz
    fi
fi

if [ ! -d "${VENV_DIR}" ]
then
    # Make virtualenv
    ####################
    mkdir -p $VENV_DIR
    python -m virtualenv -p python --system-site-packages $VENV_DIR
    . $VENV_DIR/bin/activate
    python -m pip install -U importlib setuptools pip
   
    # install cmsgemos?
    ####################
    if [ ! -z ${CMSGEMOS_VERSION} ]
    then
        if [ ! -e cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz ]
        then
            echo cp /afs/cern.ch/user/s/sturdy/public/cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz .
            cp /afs/cern.ch/user/s/sturdy/public/cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz .
        fi
        echo python -m pip install cmsgemos_gempython-0.3.1.tar.gz --no-deps
        python -m pip install cmsgemos_gempython-0.3.1.tar.gz --no-deps
    fi
    
    # install gemplotting?
    ####################
    if [ ! -z ${GEMPLOT_VERSION} ]
    then
        if [ ! -e gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz ]
        then
            if [ -z "$GEMPLOT_DEV_VERSION" ]
            then
                echo wget https://github.com/cms-gem-daq-project/gem-plotting-tools/releases/download/v${GEMPLOT_VERSION}/gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
                wget https://github.com/cms-gem-daq-project/gem-plotting-tools/releases/download/v${GEMPLOT_VERSION}/gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
            else
                echo wget https://github.com/cms-gem-daq-project/gem-plotting-tools/releases/download/v${GEMPLOT_VERSION}-dev${GEMPLOT_DEV_VERSION}/gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
                wget https://github.com/cms-gem-daq-project/gem-plotting-tools/releases/download/v${GEMPLOT_VERSION}-dev${GEMPLOT_DEV_VERSION}/gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
            fi
        fi
        echo python -m pip install gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
        python -m pip install gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
    fi

    # install vfatqc?
    ####################
    if [ ! -z ${VFATQC_VERSION} ]
    then
        if [ ! -e gempython_vfatqc-${VFATQC_VERSION}.tar.gz ]
        then
            if [ -z "$VFATQC_DEV_VERSION" ]
            then
                echo wget https://github.com/cms-gem-daq-project/vfatqc-python-scripts/releases/download/v${VFATQC_VERSION}/gempython_vfatqc-${VFATQC_VERSION}.tar.gz
                wget https://github.com/cms-gem-daq-project/vfatqc-python-scripts/releases/download/v${VFATQC_VERSION}/gempython_vfatqc-${VFATQC_VERSION}.tar.gz
            else
                echo wget https://github.com/cms-gem-daq-project/vfatqc-python-scripts/releases/download/v${VFATQC_VERSION}-dev${VFATQC_DEV_VERSION}/gempython_vfatqc-${VFATQC_VERSION}.tar.gz
                wget https://github.com/cms-gem-daq-project/vfatqc-python-scripts/releases/download/v${VFATQC_VERSION}-dev${VFATQC_DEV_VERSION}/gempython_vfatqc-${VFATQC_VERSION}.tar.gz
            fi
        fi
    echo python -m pip install gempython_vfatqc-${VFATQC_VERSION}.tar.gz
    python -m pip install gempython_vfatqc-${VFATQC_VERSION}.tar.gz
    fi
else
    echo source $VENV_DIR/bin/activate
    source $VENV_DIR/bin/activate
fi

# Setup locations
####################
if [[ $SYSTEM_INFO == *"lxplus"* ]];
then
    export DATA_PATH=/afs/cern.ch/work/$USER[0,1]/$USER/CMS_GEM/Data/gemdata
elif [[ $SYSTEM_INFO == *"gem904"* ]];
then
    export DATA_PATH=/data/bigdisk/GEM-Data-Taking/GE11_QC8/
    export LD_LIBRARY_PATH=/opt/cactus/lib:$LD_LIBRARY_PATH
    export GEM_ADDRESS_TABLE_PATH=/opt/cmsgemos/etc/maps
    export AMC13_ADDRESS_TABLE_PATH=/opt/cactus/etc/amc13/

    # Firmware
    export FIRMWARE_GEM=/data/bigdisk/GEMDAQ_Documentation/system/firmware/files

    # AMC13 Tool
    alias AMC13Tool2.ext='/opt/cactus/bin/amc13/AMC13Tool2.exe'
    alias AMC13ToolQC8='/opt/cactus/bin/amc13/AMC13Tool2.exe -c  192.168.2.104/c'

    # xDAQ
    alias xdaq=/opt/xdaq/bin/xdaq.exe

    # Misc
    #alias arp-scan='sudo /usr/sbin/arp-scan'
    alias gbtProgrammer='java -jar /data/bigdisk/sw/GBTx_programmer/programmerv2.20180116.jar'
elif [[ $SYSTEM_INFO == *"srv-s2g18"* || $SYSTEM_INFO == *"kvm"* ]];
then
    export DATA_PATH=/gemdata
    export LD_LIBRARY_PATH=/opt/cactus/lib:$LD_LIBRARY_PATH
fi

# Setup path
export PATH=$VENV_DIR/lib/python$PYTHON_VERSION/site-packages/gempython/scripts:$PATH
export PATH=$VENV_DIR/lib/python$PYTHON_VERSION/site-packages/gempython/gemplotting/macros:$PATH

# Create mapping files
if [ ! -f $VENV_DIR/lib/python2.7/site-packages/gempython/gemplotting/mapping/shortChannelMap.txt ]
then
    find $VENV_DIR/lib/python$PYTHON_VERSION/site-packages/gempython -type f -name buildMapFiles.py -exec python {} \;
fi
