#!/bin/bash



### Shell config
#
set -e
set -u



### Check parameters
#
MY_NODE_NAME="$1"
REMOVE_NODE_HOSTNAME="$2"
REMOVE_NODE_NAME_FQDN="$3"
REMOVE_NODE_IP="$4"



### Check if I am leader, exit if not
#
RES=`curl -sL http://127.0.0.1:2379/v2/members/leader | fgrep "$MY_NODE_NAME" -c | cat`
if [ "$RES" -ne "1" ]; then
    echo "SKIPPING: Not a cluster leader, exiting..."
    exit 0
fi



### Is this node still in cluster? If yes, remove it.
#
RES=`etcdctl member list | fgrep -c "$REMOVE_NODE_IP" | cat`
if [ "$RES" -ne "0" ]; then
    REMOVE_NODE_ID=`etcdctl member list | fgrep "$REMOVE_NODE_IP" | cut -d':' -f1`
    etcdctl member remove $REMOVE_NODE_ID

    # Wait for change propagation
    sleep 2
fi



### Check if new node is removed from cluster
#
RES=`etcdctl member list | fgrep -c "$REMOVE_NODE_IP" | cat`
if [ "$RES" -ne "0" ]; then
    echo "ERROR: Node was not successfully removed from cluster"
    exit 99
fi



### All done.
#
echo "OK: Node removed from cluster: $REMOVE_NODE_NAME_FQDN"
true
