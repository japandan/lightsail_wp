#!/bin/bash
# This will restore the user accounts into the ldap
#
echo "make a quick backup of the current database "
slapcat -f /etc/openldap/slapd.conf  > backup.ldif
echo "stop slapd service"
systemctl stop slapd
echo "remove old ldap data"
rm -rf /var/lib/ldap/datostech.com/*
echo "start/stop slapd to create empty databases"
systemctl start slapd
systemctl stop slapd
#
export filename="2021-10-20-04-08-28.ldif"
export target="/root/restore"
echo "The backup $filename file has the original password for users vmail and vmailadmin"
echo "This new installation of iRedMail has new passwords, stored in /opt/www/iredmail/settings.py"
echo "You need to edit this file to replace the password before doing the slapadd which imports the accounts"
echo "slapadd -f /etc/openldap/slapd.conf -l /root/restore/$filename
