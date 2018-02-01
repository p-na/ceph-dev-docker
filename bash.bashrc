alias ls='ls --color=auto'
alias o='grep --color=auto'
alias dashb='cd /ceph/src/pybind/mgr/dashboard_v2'

if [ ! -d ~/bin ]; then
    mkdir ~/bin
fi
export PATH=~/bin:${PATH}
