#!/usr/local/bin/bash

##### Check if Local Requirements are met #####

curl https://raw.githubusercontent.com/ntman4real/devopsinabox-k8/master/reqs.sh | bash -s

git clone git@github.com:ntman4real/devopsinabox-k8.git

##### Create config file or use existing #####

if [ -f ./vars.ini ]; then
  source vars.ini
else
  echo "No config file exists, creating now..."
  sh ./var_create.sh
fi

####################################################################################

touch ./remotestate.tf


####################################################################################
docker build -t util_base ./util_containers/base_container/.
docker build -t util_main ./util_containers/util_container/.