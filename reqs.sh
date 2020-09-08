#!/usr/local/bin/bash
set -e
echo "#########################" && echo

svc=kind
echo "check for ${svc} installed"
if ${svc} version; then
    echo ${svc} is installed
    echo && echo "#########################" && echo
else
    echo ${svc} not running, please run or install.
    exit 1
fi

svc=git2
echo "check for ${svc} installed"
if ${svc} version; then
    echo ${svc} is installed
    echo && echo "#########################" && echo
else
    echo ${svc} not running, please run or install.
    exit 1
fi

svc=docker
echo "check for running ${svc}"
if pgrep -xq -- ${svc}; then
    echo ${svc} is running
    echo && echo "#########################" && echo
else
    echo ${svc} not running, please run or install.
    exit 1
fi

svc=Lens
echo "check for running ${svc}"
if pgrep -xq -- ${svc}; then
    echo ${svc} is running
    echo && echo "#########################" && echo
else
    echo ${svc} not running, please run or install.
    exit 1
fi
####################################################################################