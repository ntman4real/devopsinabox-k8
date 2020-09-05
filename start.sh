#!/usr/local/bin/bash
set -x

read -p 'DomainName: (00-99)' domainvar
read -p 'Server#: (00-99)' countvar
read -p 'ClusterName: (default: kind)' clustername
read -p 'Environment: (default: dev)' envvar
read -p 'Purpose: (default: myapp)' purpose
read -p '# of Masters: (default: 1)' purpose
read -p '# of Workers: (default: 1)' purpose

echo ${purpose}.${domainvar}
#https://github.com/ntman4real/devopsinabox-k8/blob/dev/start.sh
