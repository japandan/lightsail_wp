#!/bin/bash
# This will restore the user accounts into the ldap
#
export target="/root/restore/"
echo "We need to restore the /var/vmail files to this new server.  These include the mail and ldap backup"
read -p "What is the date of the backup in YYYY-MM-DD format? " backupdate
echo "restoring backup files"
tar -xvzf $target/iredmail.$backupdate.tar.gz -C /
echo "make a quick backup of the current ldap users... "
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
echo "If this file has the .bz2 extension, run #bzip2 $filename.bz2" 
echo "This new installation of iRedMail has new passwords, stored in /opt/www/iredmail/settings.py"
echo "You need to edit this file to replace the password before doing the slapadd which imports the accounts"
grep userPassword /opt/www/iredmail/settings.py
echo "slapadd -f /etc/openldap/slapd.conf -l /var/vmail/backup/ldap/2021/10/$filename"
