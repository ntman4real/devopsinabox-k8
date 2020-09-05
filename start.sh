#!/usr/local/bin/bash
set -x

read -p 'DomainName: (00-99)' domainvar
read -p 'Server#: (00-99)' countvar
read -p 'ClusterName: (default: kind)' clustername
read -p 'Environment: (default: dev)' envvar
read -p 'Purpose: (default: myapp)' purpose

How Many Masters?
How many Workers?

echo ${purpose}.${domainvar}

