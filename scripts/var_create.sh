#!/usr/local/bin/bash

##### Get Domain Name #####
  while [[ -z "${domainvar}" ]]
do
  read -e -p "Enter a DomainName: " domainvar
done
echo "domainvar=${domainvar}" |tee -a ./vars.ini
echo && echo "#########################" && echo

##### Get Email addy #####
  while [[ -z "${email}" ]]
do
  read -e -p "Enter email address for SSL Cert: " email
done
echo "emailaddy=${email}" |tee -a ./vars.ini
echo && echo "#########################" && echo

##### Get Cluster name #####
while [[ -z "${clustername}" ]]
do
  read -e -p "Enter a name for your Cluster: (ex: kind) " clustername
done
echo "clustername=${clustername}" |tee -a ./vars.ini
echo && echo "#########################" && echo


##### Get Cluster # version #####
while [[ -z "${clustervar}" ]]
do
  read -e -p "Enter a ClusterVer: (00-99) " clustervar
done
echo "clustervar=${clustervar}" |tee -a ./vars.ini
echo && echo "#########################" && echo

##### Get Cluster # of Masters #####
while [[ -z "${mastersvar}" ]]
do
  read -e -p "Enter # of Masters: (1-3) " mastersvar
done
echo "mastersvar=${mastersvar}" |tee -a ./vars.ini
echo && echo "#########################" && echo

##### Get Cluster # of Workers #####
while [[ -z "${workersvar}" ]]
do
  read -e -p "Enter # of Workers: (1-9) " workersvar
done
echo "workersvar=${workersvar}" |tee -a ./vars.ini
echo && echo "#########################" && echo

##### Get Cluster ENV #####
while [[ -z "${thisenv}" ]]
do
  read -e -p "Enter ENV of Cluster: (ex. dev, qa, etc.) " thisenv
done
echo "thisenv=${thisenv}" |tee -a ./vars.ini
echo && echo "#########################" && echo

##### Get Workstation IP #####
LOCAL_IP_ADDY=($(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}'))
select ip in "${LOCAL_IP_ADDY[@]}"; do
    case $ip in
        "") echo 'Invalid choice' >&2 ;;
        *)  break
    esac
done
printf 'You picked IP %s\n' "$ip"
echo "LOCAL_IP_ADDY="$ip"" |tee -a ./vars.ini


export cluster_fqdn=${thisenv}${clustername}${clusterver}.${domainvar}
echo "thiscluster_fqdn=${cluster_fqdn}" |tee -a ./vars.ini
echo "Your Clusters FQDN endpoint is ${cluster_fqdn}"
echo "Your Clusters IP endpoint is 'https://${LOCAL_IP_ADDY}:5000'"
echo && echo "#########################" && echo