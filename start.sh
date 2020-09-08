#!/usr/local/bin/bash

##### Check if Local Requirements are met #####

sh ./reqs.sh | bash -s


##### Create config file or use existing #####

if [ -f ./vars.ini ]; then
  source ./vars.ini
else
  echo "No config file exists, exiting now..."
  exit 1
fi

##### Build UTIL Containers #####
sh ./util_containers/build.sh

##### Build KIND YAML file #####
clusterfile="./${clustername}${clustervar}.yaml"
cat >${clusterfile} <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${clustername}${clustervar}
networking:
  apiServerAddress: "${LOCAL_IP_ADDY}"
  apiServerPort: 50${clustervar}
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
    - containerPort: 80
      hostPort: 80
      protocol: TCP
    - containerPort: 443
      hostPort: 443
      protocol: TCP
EOF

if [ $mastersvar -ge 2 ]; then
  for master in $(seq 2 $mastersvar); do echo "- role: control-plane" >>${clusterfile}; done
else
  echo "Only 1 Master"
fi
for worker in $(seq 1 $workersvar); do echo "- role: worker" >>${clusterfile}; done

##### Update Remote State file #####
sed -i '' -e "s|domainvar|${domainvar}|g" ./remotestate.tf
sed -i '' -e "s|emailaddy|${emailaddy}|g" ./remotestate.tf
sed -i '' -e "s|clustername|${clustername}|g" ./remotestate.tf
sed -i '' -e "s|clustervar|${clustervar}|g" ./remotestate.tf
sed -i '' -e "s|thisenv|${thisenv}|g" ./remotestate.tf
sed -i '' -e "s|LOCAL_IP_ADDY|${LOCAL_IP_ADDY}|g" ./remotestate.tf
sed -i '' -e "s|thiscluster_fqdn|${thiscluster_fqdn}|g" ./remotestate.tf
sed -i '' -e "s|mastersvar|${mastersvar}|g" ./remotestate.tf
sed -i '' -e "s|workersvar|${workersvar}|g" ./remotestate.tf
terraform fmt ./remotestate.tf

##### START KIND CLuster Build #####
kconfig="./conf/kubeconfig"
kind create cluster --config=${clusterfile} &
wait
kind get kubeconfig |tee -a ${kconfig}