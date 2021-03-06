#!/bin/bash
#
# script to install iredmail and restore from backups on a new server
# Author: Daniel Vogel
# Date: 21 Dec 2019
#
if [ getenforce ]; then
   echo 'iredmail will not work with selinux.  We will disable it now.'
   setenforce 0
fi
echo "Setting selinux to permissive mode"
sed -i.bak 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
echo
echo downloading iredmail into /root
cd /root
wget https://github.com/iredmail/iRedMail/archive/1.0.tar.gz
tar -xzvf 1.0.tar.gz
echo "cd into directory and type #bash iRedMail.sh"
cd iRedMail*
