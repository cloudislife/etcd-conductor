#!/bin/bash



### Bootstrap && shell configuration
#
set -e
set -u
MYDIR=`dirname $0`
MYDIR_ABSPATH=`realpath "$MYDIR"`
ETCDC_BOOTSTRAP_BASIC="true"
. $MYDIR_ABSPATH/bin/_bin_bootstrap.sh

# Get into parent dir
cd ..



### Check if parent has .git and directory defined
#
if [ ! -d ./.git ]; then
    _etcdc_fatalError "Parent directory is not a git root"
fi

if [ ! -d ./etcd-conductor ]; then
    _etcdc_fatalError "There is no etcd-conductor directory in parent git repository"
fi



### Copy files and create symlinks
#
echo -n "ETCDC BOOTSTRAP GIT: Symlinking ./ansible.cfg -> etcd-conductor/ansible.cfg... "
if [ ! -e ./ansible.cfg ]; then
    ln -s ./etcd-conductor/ansible.cfg ./ansible.cfg
    echo "done."
else
    echo "already there, skipping."
fi

echo -n "ETCDC BOOTSTRAP GIT: Symlinking ./bin -> etcd-conductor/bin... "
if [ ! -e ./bin ]; then
    ln -s ./etcd-conductor/bin ./bin
    echo "done."
else
    echo "already there, skipping."
fi

echo -n "ETCDC BOOTSTRAP GIT: Creating sample inventory: ./hosts... "
if [ ! -e ./hosts ]; then
    cp etcd-conductor/hosts-sample ./hosts
    echo "done."
else
    echo "already there, skipping."
fi



### All done.
#
echo "ETCDC BOOTSTRAP GIT: All done."
echo
echo "What now?"
echo "You need to configure inventory file: ./hosts"
echo
echo "And then what?"
echo "Once inventory is configured, you may bootstrap your cluster with:"
echo
echo "    ./bin/cluster-bootstrap"
echo
