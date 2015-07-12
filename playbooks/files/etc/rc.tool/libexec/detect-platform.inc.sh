#!/bin/bash



### Output methods
#
function _doEcho()
{
    if [ "$2" != "" ]; then
        echo "$1" "$2"
    else
        echo "$1"
    fi
}

function _echo()
{
    case $DETECT_PLATFORM_QUIET in

        yes|true|1)
            return
            ;;
        no|false|0)
            _doEcho "$1" "$2"
            return
            ;;
        *)
            _doEcho "$1" "$2"
            return
            ;;
    esac
}



### Paths
#
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin



### Determine virtualization (LXC is of particular interest)
#
_echo -n "RCTOOL:   Determinig if inside VM or container... "
HOST_VIRTUAL="no"
HOST_VIRT_TYPE=""
HOST_VIRT_PLATFORM=""

if [ -d /proc/bus/pci ]; then
    if which lspci > /dev/null 2>&1; then
        RES=`lspci | grep -i 'vmware' -c`
        if [ "$RES" -gt "0" ]; then
            HOST_VIRTUAL="yes"
            HOST_VIRT_TYPE="full"
            HOST_VIRT_PLATFORM="vmware"
            _echo -n "Yes, VMware. "
        fi
    fi
fi
if [ -f /sys/hypervisor/type ]; then
    RES=`cat /sys/hypervisor/type | grep 'xen' -c`
    if [ "$RES" -gt "0" ]; then
        HOST_VIRTUAL="yes"
        HOST_VIRT_TYPE="full"
        HOST_VIRT_PLATFORM="xen"
        _echo -n "Yes, Xen. "
    fi
fi
if [ -f /proc/cpuinfo ]; then
    RES=`cat /proc/cpuinfo | grep 'QEMU Virtual CPU' -c`
    if [ "$RES" -gt "0" ]; then
        HOST_VIRTUAL="yes"
        HOST_VIRT_TYPE="full"
        HOST_VIRT_PLATFORM="kvm"
        _echo -n "Yes, KVM. "
    fi
fi

if [ -d /proc/vz ] && [ ! -d /proc/bz ]; then
    HOST_VIRTUAL="yes"
    HOST_VIRT_TYPE="para"
    HOST_VIRT_PLATFORM="openvz"
    _echo -n "Yes, OpenVZ container. "
fi

if [ -f /proc/self/cgroup ]; then
    RES=`cat /proc/self/cgroup | grep '/lxc/' -c`
    if [ "$RES" -gt "0" ]; then
        HOST_VIRTUAL="yes"
        HOST_VIRT_TYPE="para"
        HOST_VIRT_PLATFORM="lxc"
        HOST_VIRT_LXC_UNPRIVILEGED="no"
        _echo -n "Yes, LXC container. "

        # Check if unprivileged
        if [ -f /proc/self/uid_map ]; then
            RES=`cat /proc/self/uid_map | awk '{print $1,$2}' | grep '^0 0$' -c`
            if [ "$RES" -eq "1" ]; then
                _echo -n "Privileged. "
                HOST_VIRT_LXC_UNPRIVILEGED="no"
            else
                _echo -n "Unprivileged. "
                HOST_VIRT_LXC_UNPRIVILEGED="yes"
            fi
        fi
    fi
fi

if [ "$HOST_VIRTUAL" == "no" ]; then
    _echo "no."
else
    _echo
fi
