#!/bin/bash
#
# script to install iredmail and restore from backups on a new server
# Author: Daniel Vogel
# Date: 18 Oct 2021
#
# Get the backup data from the backup server
# for example"
echo " scp -P{port} username@backup.example.com:/backupdir/iredmail.2021-10-18.tar.gz ."
#
#
#Download the latest release of iRedMail
#   Visit Download page to get the latest stable release of iRedMail.
#   Upload iRedMail to your mail server via ftp or scp or whatever method you can use, login to the server to install iRedMail. 
#   We assume you uploaded it to /root/iRedMail-x.y.z.tar.gz (replace x.y.z by the real version number).
#
#    Uncompress iRedMail tarball:
#
# cd /root/
# tar zxf iRedMail-x.y.z.tar.gz
#
# Start iRedMail installer
#
# It's now ready to start iRedMail installer, it will ask you several simple questions, 
# that's all required to setup a full-featured mail server.
#
# cd /root/iRedMail-x.y.z/
# bash iRedMail.sh



if [ getenforce ]; then
   echo 'iredmail will not work with selinux.  We will disable it now.'
   setenforce 0
fi
echo "Setting selinux to permissive mode"
sed -i.bak 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
echo
echo downloading iredmail into /root
cd /root
## latest version 
wget https://github.com/iredmail/iRedMail/archive/1.4.2.tar.gz
#wget https://github.com/iredmail/iRedMail/archive/1.0.tar.gz
tar -xzvf 1.4.2.tar.gz
echo "cd into directory and type #bash iRedMail.sh"
cd iRedMail*
#
echo "Add the FQDN for the server"
echo "<< ERROR >> Please configure a fully qualified domain name (FQDN) in /etc/hosts before we go further.Example:127.0.0.1"
#mail.iredmail.org mail localhost
#bash iRedMail.sh
