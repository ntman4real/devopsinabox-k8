#!/usr/local/bin/bash

echo "#########################" && echo
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

svc=kind
if kind version; then
    echo ${svc} is installed
    echo && echo "#########################" && echo
else
    echo ${svc} not running, please run or install.
    exit 1
fi
####################################################################################