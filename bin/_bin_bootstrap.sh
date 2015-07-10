#!/bin/bash



### Shell configuration
#
set -e
set -u



### Function: _etcdc_displayHelp
#
_etcdc_displayHelp()
{
    echo "ETCDC Available commands:"
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
    echo "ETCDC ERROR: $MSG"
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



### Initialisation: terminate initialisation if requested
#
# This is mainly used by ../bootstrap-parent-git.sh script
#
if [ "$ETCDC_BOOTSTRAP_BASIC" == "true" ]; then
    return 0
fi



### Initialisation: check if ansible is available
#
ETCDC_INIT_ANSIBLE_SUBMODULE_ENVIRONMENT="no"
if ! which ansible-playbook > /dev/null; then
    if [ -d ansible/hacking ]; then
        ETCDC_INIT_ANSIBLE_SUBMODULE_ENVIRONMENT="yes"
    else
        echo    "ETCDC WARNING:  No 'ansible-playbook' program available."
        echo -n "ETCDC QUESTION: Would you like me to set it up for you? (enter 'yes' to continue): "
        read ANSWER
        if [ "$ANSWER" != "yes" ]; then
            _etcdc_fatalError "Unable to locate ansible binary"
        fi

        # Update submodule
        git submodule init
        git submodule update --init --recursive

        # Set up ansible environment
        ETCDC_INIT_ANSIBLE_SUBMODULE_ENVIRONMENT="yes"
    fi
fi



### Initialisation: set up ansible environment if requested
#
if [ "$ETCDC_INIT_ANSIBLE_SUBMODULE_ENVIRONMENT" == "yes" ]; then
    echo -n "ETCDC: Initialising ansible environment... "
    . ./ansible/hacking/env-setup > /dev/null 2>/dev/null
    echo "done."
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
