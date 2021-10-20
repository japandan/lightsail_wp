#!/bin/bash
# Retrieve the backups
export backupserver="asus.datos.asia"
export user="danvogel"
export sshport="1965"
export target="/root/restore/"
echo "Backups will be downloaded from $backupserver  to /root/restore"
mkdir -p $target
cd $target
echo "Getting backups of /var/vmail for restoring iredmail."
read -p "type the date of the backups in format YYYY-MM-DD >" backupdate
scp -P$sshport $user@$backupserver:/backupdir/iredmail.$backupdate.tar.gz $target
echo "Getting backups of wordpress directories"
scp -P$sshport $user@$backupserver:/backupdir/wordpress.$backupdate.sql $target
scp -P$sshport $user@$backupserver:/backupdir/html.$backupdate.tar.gz $target
echo "getting backup of /etc/ and scripts"
scp -P$sshport $user@$backupserver:/backupdir/etc.$backupdate.tar.gz $target
scp -P$sshport $user@$backupserver:/backupdir/scripts $target
