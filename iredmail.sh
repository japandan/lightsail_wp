#!/bin/bash
#
# script to install iredmail and restore from backups on a new server
# Author: Daniel Vogel
# Date: 21 Dec 2019
#
# Get the backup data from the backup server
# for example"
# scp -P{port} username@backup.example.com:/backupdir/iredmail.2021-10-18.tar.gz .
#
if [ getenforce ]; then
   echo 'iredmail will not work with selinux.  We will disable it now.'
   setenforce 0
fi
echo "Setting selinux to permissive mode"
sed -i.bak 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
echo
echo downloading iredmail into /opt
cd /opt
wget https://github.com/iredmail/iRedMail/archive/1.0.tar.gz
tar -xzvf 1.0.tar.gz
echo "cd into directory and type #bash iRedMail.sh"
cd iRedMail*
#
echo "Add the FQDN for the server"
echo "<< ERROR >> Please configure a fully qualified domain name (FQDN) in /etc/hosts before we go further.Example:127.0.0.1"
#mail.iredmail.org mail localhost
#bash iRedMail.sh
