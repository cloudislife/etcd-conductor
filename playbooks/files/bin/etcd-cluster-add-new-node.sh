#!/bin/bash



### Shell config
#
set -e
set -u



### Check parameters
#
MY_NODE_NAME="$1"
NEW_NODE_HOSTNAME="$2"
NEW_NODE_NAME_FQDN="$3"
NEW_NODE_IP="$4"



### Check if I am leader, exit if not
#
RES=`curl -sL http://127.0.0.1:2379/v2/members/leader | fgrep "$MY_NODE_NAME" -c | cat`
if [ "$RES" -ne "1" ]; then
    echo "SKIPPING: Not a cluster leader, exiting..."
    exit 0
fi



### Check if cluster already has this node added? If not, add it.
#
RES=`etcdctl member list | fgrep -c "$NEW_NODE_IP" | cat`
if [ "$RES" -eq "0" ]; then
    etcdctl member add $NEW_NODE_NAME_FQDN http://$NEW_NODE_IP:2380

    # Wait for change propagation
    sleep 2
fi



### Check if new node is pending in cluster
#
RES=`etcdctl member list | fgrep -c "$NEW_NODE_IP" | cat`
if [ "$RES" -ne "1" ]; then
    echo "ERROR: Newly added node is not to be found on list of cluster nodes"
    exit 99
fi



### All done.
#
echo "OK: New node added to the cluster: $NEW_NODE_NAME_FQDN"
true
