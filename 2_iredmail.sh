#!/bin/bash
#
# script to install iredmail and restore from backups on a new server
# Author: Daniel Vogel
# Date: 18 Oct 2021
#
echo "This script will do a clean install of iRedMail.  It should be run manually because some steps prompt the user."
export FQDN="www.datostech.com"
echo "setting FQDN hostname $FQDN in /etc/hosts"
sed -i "s/127.0.0.1   localhost/127.0.0.1   $FQDN www ldap mail localhost/" /etc/hosts
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
## latest version 
wget https://github.com/iredmail/iRedMail/archive/1.4.2.tar.gz
tar -xzvf 1.4.2.tar.gz
echo "cd into directory and type #bash iRedMail.sh"
#
#
MySQLPassword=$(cat /root/MySQLPassword )
echo "Please set the MySQL root password to $MySQLPassword"
mysql_secure_installation
#
sed -i "s/ChangeM3/$MySQLPassword/" lightsail_wp/config
cp -f lightsail_wp/config iRedMail*/
#
echo "Starting unattened iRedMail installation with these configs"
cd iRedMail*
cat config
#
# Run this unattended
#
AUTO_USE_EXISTING_CONFIG_FILE=y \
    AUTO_INSTALL_WITHOUT_CONFIRM=y \
    AUTO_CLEANUP_REMOVE_SENDMAIL=y \
    AUTO_CLEANUP_REPLACE_FIREWALL_RULES=y \
    AUTO_CLEANUP_RESTART_FIREWALL=y \
    AUTO_CLEANUP_REPLACE_MYSQL_CONFIG=y \
    bash iRedMail.sh
