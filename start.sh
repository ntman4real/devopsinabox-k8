#!/usr/local/bin/bash
#set -x
####################################################################################
##### Check if Local Requirements are met #####

curl https://raw.githubusercontent.com/ntman4real/devopsinabox-k8/master/reqs.sh | bash -s -- corp app1

https://github.com/ntman4real/devopsinabox-k8/blob/dev/start.sh

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
touch ./remotestate.tf

while [[ -z "${domainvar}" ]]
do
  read -e -p "Enter a DomainName: " domainvar
done
sed -i '' "s|domainvar|'${domainvar}'|" ./remotestate.tf
echo && echo "#########################" && echo

while [[ -z "${clustervar}" ]]
do
  read -e -p "Enter a ClusterVer: " clustervar
done
sed -i '' "s|clustervar|'${clustervar}'|" ./remotestate.tf
echo && echo "#########################" && echo

while [[ -z "${countvar}" ]]
do
  read -e -p "Enter a ClusterVer: " clustervar
done
sed -i '' "s|clustervar|'${clustervar}'|" ./remotestate.tf
echo && echo "#########################" && echo




echo 'Server# (00-99):'
select countvar in [00-99]
do
  read countvar
done
echo && echo "#########################" && echo

echo
#read -p 'ClusterName: (default: kind)' clustername
echo && echo "#########################" && echo

echo
#read -p 'Environment: (default: dev)' envvar
echo && echo "#########################" && echo

echo "Purpose:"
read   purpose
echo && echo "#########################" && echo

echo
#read -p '# of Masters: (default: 1)' masters
echo && echo "#########################" && echo

echo
#read -p '# of Workers: (default: 1)' workers
echo && echo "#########################" && echo

echo ${purpose}.${domainvar}
#https://github.com/ntman4real/devopsinabox-k8/blob/dev/start.sh
echo && echo "#########################" && echo

####################################################################################
docker build -t util_base ./util_containers/base_container/.
docker build -t util_main ./util_containers/util_container/.