# .bashrc

# Don't execute if session is non-interactive
if [ -z "$PS1" ]; then
   return
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Stop escaping during $ tab completion
shopt -s direxpand

# setup gemdaq
#export PATH=/opt/cmsgemos/bin:$PATH
#export GEM_ADDRESS_TABLE_PATH=/opt/cmsgemos/etc/maps
#source /data/bigdisk/sw/gemdaqenv.sh
#source $HOME/.setup_gemdaq.sh
