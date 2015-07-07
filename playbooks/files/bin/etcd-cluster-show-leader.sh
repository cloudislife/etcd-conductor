#!/bin/bash



### Shell config
#
set -e
set -u



### Check parameters
#
MY_NODE_NAME="$1"



### Check if I am leader, exit if not
#
RES=`curl -sL http://127.0.0.1:2379/v2/members/leader | fgrep "$MY_NODE_NAME" -c | cat`
if [ "$RES" -ne "1" ]; then
    LEADER_NAME=`curl -sL http://127.0.0.1:2379/v2/members/leader | grep -Eo 'name":"[^"]+' | cut -d'"' -f3`

    echo "STATUS: I am NOT a cluster leader. Current leader is: $LEADER_NAME"
    exit 0
fi



### All done.
#
echo "STATUS: I am a cluster leader."
true
