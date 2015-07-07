#!/bin/bash



### Shell configuration
#
set -e
set -u



### Function: _etcdc_displayHelp
#
_etcdc_displayHelp()
{
    echo "Available commands:"
    for CMD in `cd $ETCDC_DIR_PLAYBOOKS && ls *.yml | sed -e 's/\.yml$//'`; do
        echo "    - $CMD"
    done
    echo "    - help"
}



### Function: _etcdc_fatalError
#
_etcdc_fatalError()
{
    MSG="$1"
    echo
    _etcdc_displayHelp
    echo
    echo "ERROR: $MSG"
    echo
    exit 1
}



### Initialisation: get directories
#
ETCDC_BIN_BOOTSTRAP_ABSPATH=`realpath ${BASH_SOURCE[0]}`
ETCDC_BIN_ABSPATH=`dirname $ETCDC_BIN_BOOTSTRAP_ABSPATH`
ETCDC_ABSPATH=`dirname $ETCDC_BIN_ABSPATH`
ETCDC_PARENT_ABSPATH=`dirname $ETCDC_ABSPATH`
ETCDC_DIR_PLAYBOOKS="$ETCDC_ABSPATH/playbooks"



### Initialisation: switch to etcd-conductor directory
#
cd $ETCDC_ABSPATH



### Initialisation: check if ansible is available
#
if ! which ansible > /dev/null; then
    _etcdc_fatalError "Unable to locate ansible binary"
fi



### Initialisation: determine which ansible configuration file to use
#
if [ -f $ETCDC_PARENT_ABSPATH/ansible.cfg ]; then
    export ANSIBLE_CONFIG="$ETCDC_PARENT_ABSPATH/ansible.cfg"
else
    export ANSIBLE_CONFIG="$ETCDC_ABSPATH/ansible.cfg"
fi



### Initialisation: find inventory file
#
RES=`cat $ANSIBLE_CONFIG | grep '^inventory' -c`
if [ "$RES" != "1" ]; then
    _etcdc_fatalError "Unable to determine inventory file path"
fi
ETCDC_INVENTORY_FILE=`cat "$ANSIBLE_CONFIG" | grep '^inventory' | cut -d= -f2 | sed -e 's/#.*//' | sed -e 's/^[ ]*//' | sed -e 's/[ ]*$//'`
if [ "$ETCDC_INVENTORY_FILE" == "" ]; then
    _etcdc_fatalError "Unable to parse inventory file path"
fi
