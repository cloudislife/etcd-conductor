#!/bin/bash



### Shell config
#
#set -e
#set -u



### Check parameters
#
if [[ ! $1 =~ ^[0-9]+$ ]]; then
    echo "Invalid node count: $1"
    exit 1
fi
if [ "$1" -lt "3" ]; then
    echo "Cluster with less than 3 nodes? ($1)"
    exit 1
fi
NODE_COUNT="$1"



### Check individual nodes first
#
RES=`etcdctl cluster-health | grep '^member ' | grep -c 'is healthy$'`
if [ "$RES" -ne "$NODE_COUNT" ]; then
    echo "WARNING: Some nodes are unhealthy! Healthy nodes/all nodes: $RES/$NODE_COUNT"
    exit 1
fi


### Check cluster as a whole
#
RES=`etcdctl cluster-health | grep '^cluster ' | grep -c 'is healthy$'`
if [ "$RES" -ne "1" ]; then
    echo "WARNING: Cluster is unhealthy!"
    exit 1
fi



### All is good.
#
echo "OK: Cluster is healthy."
true
