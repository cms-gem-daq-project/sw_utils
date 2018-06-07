# Detect when we're not being sourced, print a hint and exit
# Based on https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced#34642589
if ! $(return >/dev/null 2>&1);
then
    echo >&2 "ERROR: You must use \"source $0\" to run this script."
    exit 1
fi

if [[ ! "$0" =~ ("bash") ]];
then
    # Not sourced from Bash
    BASH_SOURCE="$0"
    # For zsh (http://zsh.sourceforge.net/FAQ/zshfaq03.html#l18)
    setopt shwordsplit || true
fi

helpstring="Usage: source $BASH_SOURCE [options]
    Options:
        -c cmsgemos release version (e.g. X.Y.Z)
        -d debug information is printed
        -g gemplotting release version (e.g. X.Y.Z)
        -G gemplotting dev version (e.g. single integer)
        -h displays this string
        -p Path to the venv location
        -P When at P5, port of a SOCKS proxy to be used by pip
        -v vfatqc release version (e.g. X.Y.Z)
        -V vfatqc dev version (e.g. single integer)
        -w No value following, deletes and recreates the venv from scratch

    The virtualenv found at -p will either be activated or created"

CMSGEMOS_VERSION=""
DEBUG=""
GEMPLOT_VERSION=""
GEMPLOT_DEV_VERSION=""
PROXY_PORT=""
VFATQC_VERSION=""
VFATQC_DEV_VERSION=""
VENV_ROOT=""
WIPE=""

OPTIND=1
while getopts "c:g:G:v:V:p:P:whd" opts
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
        P)
            PROXY_PORT="$OPTARG";;
        h)
            echo >&2 "${helpstring}"
            return 1;;
        \?)
            echo >&2 "${helpstring}"
            return 1;;
        [?])
            echo >&2 "${helpstring}"
            return 1;;
    esac
done
unset OPTIND

# Check if user provided the venv argument
if [ -n "$DEBUG" ]
then
    echo VENV_ROOT $VENV_ROOT
    echo CMSGEMOS_VERSION $CMSGEMOS_VERSION
    echo GEMPLOT_VERSION $GEMPLOT_VERSION
    echo GEMPLOT_DEV_VERSION $GEMPLOT_DEV_VERSION
    echo PROXY_PORT $PROXY_PORT
    echo VFATQC_VERSION $VFATQC_VERSION
    echo VFATQC_DEV_VERSION $VFATQC_DEV_VERSION
    echo WIPE $WIPE
fi

if [ ! -n "$VENV_ROOT" ]
then
    # Sane default
    VENV_ROOT=$PWD/venv
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
DNS_INFO="$(dnsdomainname)"
SYSTEM_INFO="$(uname -a)"
KERNEL_VERSION="$(uname -r)"
VIRTUALENV=virtualenv
PIP=pip
WGET=wget
if [[ $KERNEL_VERSION == *"2.6."* ]];
then
    if [[ $SYSTEM_INFO == *"lxplus"* ]];
    then
        source /cvmfs/sft.cern.ch/lcg/views/LCG_93/x86_64-slc6-gcc7-opt/setup.sh
        # LCG 93 doesn't provide `virtualenv' in PATH
        VIRTUALENV="python -m virtualenv"
        PIP="python -m pip"
    elif [[ "$DNS_INFO" == "cms" ]];
    then
        # We are in the .cms network
        WGET="ssh cmsusr wget"
    fi
    OS_VERSION="slc6"
elif [[ $KERNEL_VERSION == *"3.10."* ]];
then
    if [[ $SYSTEM_INFO == *"lxplus"* ]];
    then
        source /cvmfs/sft.cern.ch/lcg/views/LCG_93/x86_64-centos7-gcc7-opt/setup.sh
        # LCG 93 doesn't provide `virtualenv' in PATH
        VIRTUALENV="python -m virtualenv"
        PIP="python -m pip"
    elif [[ "$DNS_INFO" == "cms" ]];
    then
        # We are in the .cms network
        WGET="ssh cmsusr wget"
    fi
    OS_VERSION="cc7"
else
  echo "operating system not recognized"
  echo "env is not set"
  return 1
fi

# Setup proxy
####################

if [ ! -z "$PROXY_PORT" ];
then
    # Install PySocks if it's not alread there
    if ! $PIP --disable-pip-version-check show -q PySocks >/dev/null ; then
        echo "Installing PySocks..."
        ssh cmsusr wget https://files.pythonhosted.org/packages/53/12/6bf1d764f128636cef7408e8156b7235b150ea31650d0260969215bb8e7d/PySocks-1.6.8.tar.gz
        $PIP --disable-pip-version-check install --user PySocks-1.6.8.tar.gz
    fi

    PIP="$PIP --proxy socks5://localhost:$PROXY_PORT"
    VIRTUALENV="$VIRTUALENV --never-download" # virtualenv doesn't have proxy support
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
    echo PIP $PIP
    echo PYTHON_VERSION $PYTHON_VERSION
    echo VENV_DIR $VENV_DIR
    echo VIRTUALENV $VIRTUALENV
    echo WGET $WGET
fi

# Install virtualenv if it's not already there
if ! $PIP show -q virtualenv >/dev/null ; then
    $PIP install --user virtualenv
fi

# Check if user wants to start from scratch
if [[ "$WIPE" == "1" ]];
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
    echo $VIRTUALENV -p python --system-site-packages $VENV_DIR
    $VIRTUALENV -p python --system-site-packages $VENV_DIR
    . $VENV_DIR/bin/activate

    # Check virtualenv
    ####################
    if [ -z ${VIRTUAL_ENV+x} ] ; then
        echo "ERROR: Could not activate virtualenv"
        return
    fi

    # Install deps
    ####################
    echo $PIP install -U importlib 'setuptools>25,<=38' 'pip>8,<10'
    $PIP install -U importlib 'setuptools>25,<=38' 'pip>8,<10'

    # install cmsgemos?
    ####################
    if [ ! -z ${CMSGEMOS_VERSION} ]
    then
        if [ ! -e cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz ]
        then
            if [ ! -z "$PROXY_PORT" ];
            then
                echo scp lxplus.cern.ch:/afs/cern.ch/user/s/sturdy/public/cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz .
                scp lxplus.cern.ch:/afs/cern.ch/user/s/sturdy/public/cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz .
            else
                echo cp /afs/cern.ch/user/s/sturdy/public/cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz .
                cp /afs/cern.ch/user/s/sturdy/public/cmsgemos_gempython-${CMSGEMOS_VERSION}.tar.gz .
            fi
        fi
        ls >/dev/null # Forces a filesystem sync
        echo $PIP install cmsgemos_gempython-0.3.1.tar.gz --no-deps
        $PIP install cmsgemos_gempython-0.3.1.tar.gz --no-deps
    fi
    
    # install gemplotting?
    ####################
    if [ ! -z ${GEMPLOT_VERSION} ]
    then
        if [ ! -e gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz ]
        then
            if [ -z "$GEMPLOT_DEV_VERSION" ]
            then
                echo $WGET https://github.com/cms-gem-daq-project/gem-plotting-tools/releases/download/v${GEMPLOT_VERSION}/gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
                $WGET https://github.com/cms-gem-daq-project/gem-plotting-tools/releases/download/v${GEMPLOT_VERSION}/gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
            else
                echo $WGET https://github.com/cms-gem-daq-project/gem-plotting-tools/releases/download/v${GEMPLOT_VERSION}-dev${GEMPLOT_DEV_VERSION}/gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
                $WGET https://github.com/cms-gem-daq-project/gem-plotting-tools/releases/download/v${GEMPLOT_VERSION}-dev${GEMPLOT_DEV_VERSION}/gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
            fi
        fi
        ls >/dev/null # Forces a filesystem sync
        echo $PIP install gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
        $PIP install gempython_gemplotting-${GEMPLOT_VERSION}.tar.gz
    fi

    # install vfatqc?
    ####################
    if [ ! -z ${VFATQC_VERSION} ]
    then
        if [ ! -e gempython_vfatqc-${VFATQC_VERSION}.tar.gz ]
        then
            if [ -z "$VFATQC_DEV_VERSION" ]
            then
                echo $WGET https://github.com/cms-gem-daq-project/vfatqc-python-scripts/releases/download/v${VFATQC_VERSION}/gempython_vfatqc-${VFATQC_VERSION}.tar.gz
                $WGET https://github.com/cms-gem-daq-project/vfatqc-python-scripts/releases/download/v${VFATQC_VERSION}/gempython_vfatqc-${VFATQC_VERSION}.tar.gz
            else
                echo $WGET https://github.com/cms-gem-daq-project/vfatqc-python-scripts/releases/download/v${VFATQC_VERSION}-dev${VFATQC_DEV_VERSION}/gempython_vfatqc-${VFATQC_VERSION}.tar.gz
                $WGET https://github.com/cms-gem-daq-project/vfatqc-python-scripts/releases/download/v${VFATQC_VERSION}-dev${VFATQC_DEV_VERSION}/gempython_vfatqc-${VFATQC_VERSION}.tar.gz
            fi
        fi
        ls >/dev/null # Forces a filesystem sync
        echo $PIP install gempython_vfatqc-${VFATQC_VERSION}.tar.gz
        $PIP install gempython_vfatqc-${VFATQC_VERSION}.tar.gz
    fi
else
    echo source $VENV_DIR/bin/activate
    source $VENV_DIR/bin/activate
fi

# Setup locations
####################
if [[ $SYSTEM_INFO == *"lxplus"* ]];
then
    if [[ -z "$DATA_PATH" ]]; # Don't override existing value
    then
        export DATA_PATH=/afs/cern.ch/work/${USER:0:1}/$USER/CMS_GEM/Data/gemdata
    else
        # Make sure it's exported
        export DATA_PATH
    fi
    if [ ! -d "$DATA_PATH" ];
    then
        mkdir -p "$DATA_PATH"
        echo "INFO: The directory \"$DATA_PATH\" (\$DATA_PATH) didn't exist."
        echo "      I created it for you."
    fi
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
if [ ! -f $VENV_DIR/lib/python$PYTHON_VERSION/site-packages/gempython/gemplotting/mapping/shortChannelMap.txt ]
then
    find $VENV_DIR/lib/python$PYTHON_VERSION/site-packages/gempython -type f -name buildMapFiles.py -exec python {} \;
fi

# Clean up
unset DEBUG DNS_INFO helpstring PIP VIRTUALENV WIPE
if [[ ! "$0" =~ ("bash") ]];
then
    # Not sourced from Bash
    unset BASH_SOURCE
fi
