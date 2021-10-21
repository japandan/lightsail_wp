# lightsail_wp
Lightsail (Amazon Web Services )installation scripts for CentOS 7 to create LAMP stack and install Wordpress

STEPS TO INSTALL
1. login to lightsail.aws.amazon.com and [create instance].  Choose [OS Only] CentOS 7 2009-01

2. In the box for + Launch script, copy & paste the text from the "0_launch-script" file in this repo.  This will automatically copy this repo and use it to configure the server for Wordpress. It will run 1_LAMPWP.sh to install PHP7.3, Wordpress, MariaDB (MySQL), etc.

3. Attach the static public IP datos.asia-ip of the lightsail instance and try to ssh to centos@datos.asia.  Go to Manage/Networking for the instance and add https port in the Lightsail IPV4 firewall. For ssh to work, you will need to download and install in your  /.ssh directory the default ssh key used by the instance.

4. At this point, run 2_iredmail.sh which will install the nginx webserver as well as postfix, dovecot, and SOGo email programs. The password saved in /root/MySQLPassword will be used for iredmail. 2_iredmail.sh will run mysql_secure_installation to set the MySQL root password.  Test by going to https://datos.asia/SOGo with a web browser.  Login as postmaster@datostech.com
   <pre>
   bash 2_iredmail.sh 
   </pre>
   
5. The 4_aws_ses_postfix.sh script will ask you for an AWS SES SMTP username and password which can be downloaded from Amazon Web Console. This script will configure postfix to use the Amazon SMTP server.  Test by sending emails from SOGo and Dovecot, https://datos.asia/mail. 

<pre>
bash /root/lightsail_wp/4_aws_ses_postfix.sh
</pre>

6. Install a new wordpress site. Go to URL https://datos.asia to complete the setup. Add a post and a post category menu item to test permlinks.
<pre> 
bash 5_wordpress.sh
</pre>

7. If you want to start restoring the old email accounts, run the following to retrieve all the backups.
<pre>
bash _RestoreBackups.sh
#The following will copy the backup file for email into /var/vmail
cd /root/restore
tar -xvzf iredmail.2021-10-19.tar.gz -C /
bash 8_sogo_restore.sh

8. The following will copy the wordpress data from the backups. Just enter the backup date in YYYY-MM-DD. This will delete the current MySQL wordpress database and try to create a new one with the latest backup that you specified.

<pre>
bash 7_migratemail.sh
</pre>

9. The script 3_addssl.sh can break SOGo login screen. It will get a new SSL certificate from Let's Encrypt.  These need to be installed manually. Do not use the certbot --nginx option.
<pre>
bash 3_addssl.sh
</pre>

10. Run the script 9_vsftpd.sh to install FTP and create a user called ftpuser for Wordpress updates.  This user is in the apache group. This should start the ftp server so test by logging in with ftp.  You need to install ftp client software if you are testing from the new server..also set the password for the ftpuser.  i.e.
   <pre>
   #passwd ftpuser     
   #bash ./9_vsftpd.sh
   </pre>
11. Test wordpress
12. Restore ldap using the slapadd command after you have installed a fresh working copy of iredmail.
13. Backup the current ldap using slapcat -f /etc/openldap/slapd.conf and copy the "userPassword::" entries from this for users "vmail" and "vmailadmin" into the same location of the ldap backup .ldif that you want to restore.  
i.e. /var/vmail/backup/ldap/2021/10/2021-10-09-03-00-01.ldif
14. Use the slapadd command after systemctl stop slapd and rm /var/lib/ldap/datostech.com/* 
slapadd -f /etc/openldap/slapd.conf -l /var/vmail/backup/ldap/2021/10/2021-10-09-03-00-01.ldif

PROBLEMS Encountered:
<pre>
1. SELINUX causes problems.  If using SELINUX enforcing, change this boolean for httpd_anon_write->On
   #setsebool -P httpd_anon_write=1
  This causes problems with permalinks because the server cannot write the .htaccess file
2. Amazon SES (Simple Email Services) must be enabled for the domains that you send email.  
   Do this on the AWS console.  You will need to verify domains by adding the keys from AWS to your DNS.
