#!/usr/local/bin/bash

####################################################################################
##### Check if Local Requirements are met #####
#curl https://raw.githubusercontent.com/ntman4real/devopsinabox-k8/master/reqs.sh | bash -s
curl https://raw.githubusercontent.com/ntman4real/devopsinabox-k8/dev/reqs.sh | bash -s

#git clone git@github.com:ntman4real/devopsinabox-k8.git
git clone -b dev git@github.com:ntman4real/devopsinabox-k8.git

##### Build UTIL Images #####
cd devopsinabox-k8 || exit
nohup sh ./util_containers/build.sh &

##### Create config file or use existing #####
if [ -f ./vars.ini ]; then
  source vars.ini
else
  echo "No config file exists, creating now..."
  sh ./scripts/var_create.sh
  wait
fi

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

wait

if [[ ${mastersvar} -ge 2 ]] && [[ ${mastersvar} -le 3 ]]; then
  for master in $(seq 2 ${mastersvar}); do echo "- role: control-plane" >> "${clusterfile}"; done
elif [[ ${mastersvar} == 1 ]]; then
  echo "Only 1 Master"
else
  echo "Too Many Masters...Try again"
fi

for worker in $(seq 1 ${workersvar}); do echo "- role: worker" >> "${clusterfile}"; done

##### Update Remote State file #####
sed -i '' -e "s|domainvar|${domainvar}|g" ./base/variables.tf
sed -i '' -e "s|emailaddy|${emailaddy}|g" ./base/variables.tf
sed -i '' -e "s|clustername|${clustername}|g" ./base/variables.tf
sed -i '' -e "s|clustervar|${clustervar}|g" ./base/variables.tf
sed -i '' -e "s|thisenv|${thisenv}|g" ./base/variables.tf
sed -i '' -e "s|LOCAL_IP_ADDY|${LOCAL_IP_ADDY}|g" ./base/variables.tf
sed -i '' -e "s|thiscluster_fqdn|${thiscluster_fqdn}|g" ./base/variables.tf
sed -i '' -e "s|mastersvar|${mastersvar}|g" ./base/variables.tf
sed -i '' -e "s|workersvar|${workersvar}|g" ./base/variables.tf
terraform fmt ./base/variables.tf

##### START KIND CLuster Build #####
kconfig="./conf/kubeconfig"
kind create cluster --config=${clusterfile} &
wait
kind get kubeconfig |tee -a ${kconfig}

##### Update Local DNS #####

##### Build Base #####

##### Build Admin Functions #####

##### Add Registry #####

##### Build Sample Nginx APP #####

##### Add K8BITS and Web Status Page #####

##### Add Grafana Dashboard #####


####################################################################################
