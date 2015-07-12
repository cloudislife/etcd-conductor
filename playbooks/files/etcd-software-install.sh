#!/bin/bash
###########################################################################
# etcd-conductor                                                          #
#-------------------------------------------------------------------------#
# Copyright (c) Bostjan Skufca                                            #
#-------------------------------------------------------------------------#
# This program is free software; you can redistribute it and/or modify    #
# it under the terms of the GNU General Public License as published by    #
# the Free Software Foundation; either version 2, or (at your option)     #
# any later version.                                                      #
#                                                                         #
# This program is distributed in the hope that it will be useful,         #
# but WITHOUT ANY WARRANTY; without even the implied warranty of          #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           #
# GNU General Public License for more details.                            #
#                                                                         #
# You should have received a copy of the GNU General Public License       #
# along with this program; if not, write to the Free Software Foundation, #
# Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.          #
#-------------------------------------------------------------------------#
# Authors: Bostjan Skufca <my_name [at] a2o {dot} si>                     #
###########################################################################



### Configure shell
#
set -e
set -u



### Set build/temporary directory
#
export    SRCROOT="/var/src/etcd"
mkdir -p $SRCROOT
cd       $SRCROOT



### Installation package/destdir/version settings
#
export ETCD_VERSION="2.0.13"
export ETCD_RELEASE="1"
export ETCD_DESTDIR="/usr/local/etcd-$ETCD_VERSION-$ETCD_RELEASE"

export PNAME="etcd" &&
export PVERSION="$ETCD_VERSION" &&
export PDIR="$PNAME-v$PVERSION-linux-amd64" &&
export PFILE="$PDIR.tar.gz" &&
export PURI="https://github.com/coreos/etcd/releases/download/v$PVERSION/$PFILE" &&



### Install
#

# Download and extract
rm -rf   $PFILE
wget     $PURI

rm -rf   $PDIR
tar -xzf $PFILE
cd       $PDIR

# Secure
chown root.root etcd
chown root.root etcdctl

# Create empty destdir
rm -rf   $ETCD_DESTDIR
mkdir -p $ETCD_DESTDIR
mkdir -p $ETCD_DESTDIR/bin
mkdir -p $ETCD_DESTDIR/sbin

# Install
mv etcd    $ETCD_DESTDIR/sbin
mv etcdctl $ETCD_DESTDIR/bin

# Cleanup
cd $SRCROOT
rm -rf $PDIR



### Create final symlink
#
ln -sf $ETCD_DESTDIR /usr/local/etcd



### Create symlink to etcdctl
#
ln -sf $ETCD_DESTDIR/bin/etcdctl /usr/local/bin/etcdctl
