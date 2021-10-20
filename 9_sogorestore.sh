#~/bin/bash
export backuppath="/var/vmail/backup/sogo/2021/10/"
echo "Backups are stored in ${backuppath}20YY/MM/##.tar.bz2"
echo "untar the latest backup"
read -p "Where is the backup sub-directory with user accounts? $backuppath" MYBACKUPDIR
#
export MYBACKUPDIR="${backuppath}${MYBACKUPDIR}"
echo "user mailboxes found"
ls -1 $MYBACKUPDIR
echo
#
USE_SIEVE=$(grep 'SOGoSieveScriptsEnabled = YES;' /etc/sogo/sogo.conf|cut -d '=' -f 2)
#
cd $MYBACKUPDIR 
#
for i in `ls` do
#
  echo "RESTORE MAILBOX $i"
  # create account in SOGo and set general preferences
  sogo-tool restore -p "${MYBACKUPDIR}" "${i}"

  # create and fill all calendars and addressbooks
  sogo-tool restore -f ALL "${MYBACKUPDIR}" "${i}"

  if [ "${USE_SIEVE}" = ' YES;' ]
  then
    # restore all ACLs and SIEVE scripts
    sogo-tool restore -p -c /etc/sogo/sieve.cred "${MYBACKUPDIR}" "${i}"
  else
    # restore all ACLs
    sogo-tool restore -p "${MYBACKUPDIR}" "${i}"
  fi
done
