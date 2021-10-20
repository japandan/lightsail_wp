# lightsail_wp
Lightsail (Amazon Web Services )installation scripts for CentOS 7 to create LAMP stack and install Wordpress

STEPS TO INSTALL
1. login to lightsail.aws.amazon.com and [create instance].  Choose [OS Only] CentOS 7 2009-01

2. In the box for + Launch script, copy & paste the text from the "launch-script" file in this repo.  This will automatically copy the
   this repo and use it to configure the server for Wordpress. It will install PHP7.3, Wordpress, MariaDB (MySQL), etc.

3. Attach the static public IP datos.asia-ip of the lightsail instance and try to ssh to centos@datos.asia.  Add https port in the Lightsail network setting firewall for the instance. 

4. At this point, run iredmail.sh which will install the nginx webserver as well as postfix, dovecot, and SOGo email programs.  
   <pre>
   bash /root/lightsail_wp/iredmail.sh 
   # The following will copy a single backup file for email.
   cd /root
   tar -xvzf /root/iredmail.2021-10-19.tar.gz -C /
   </pre>
   
5. Run the script addssl.sh to install certbot and the free ssl certificates.  Test by going to https://datos.asia with a web browser.

6. Run the script vsftpd.sh to install FTP and create a user called ftpuser for Wordpress updates.  This user is in the apache group. This should start the ftp server so test by logging in with ftp.  You need to install ftp client software if you are testing from the new server..also set the password for the ftpuser.  i.e.
   <pre>
   #passwd ftpuser     
   #bash ./vsftpd.sh
   </pre>
   
7. Run the script to copy a database backup from a remote server to this server and restore wordpress. Just enter the backup date in YYYY-MM-DD. This will delete the current MySQL wordpress database and try to create a new one with the latest backup that you specified.
<pre>
   #bash migratewp.sh
</pre>

8. Copy the /var/www/html directory and files from a backup.  As root do type:
<pre>
  #cd /
  #tar -xvzf /root/html.2020-12-08.tar.gz -C /
</pre>

9. This will add wordpress files including the wp-config.php file and will break wordpress until you update the MySql database password. You will need to set the mysql password to match the password stored in the wp-config.php file, or edit the wp-config.php password to match your mysql password.

  /** MySQL database password */define('DB_PASSWORD', 'PASSWORD');

10. The wordpress site should now work.  If you have changed the URL of the wordpress site, you will need to replace any hardcoded URL with the new website. 
11. Follow instruction in migratewp.sh to change the URL of wordpress stored in the mysql database.  If you are using nginx, add the following to the /etc/nginx/00-default.conf 
<pre>
location / {
    index index.php index.html index.htm;
    try_files $uri $uri/ /index.php?$args;
}
</pre>
If you need to force ssl, add the following to /etc/nginx.conf but it's not needed if you have a plugin in Wordpress as we use.
<pre>
server {
listen 80;
server_name example.com;
return 301 https://www.example.com$request_uri;
}
</pre>
i.e. The login link may be pointing to http://datostech.com/login.php and will need to point to http://datos.asia/login.php if this is the new website URL.

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
