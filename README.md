# lightsail_wp
Lightsail (Amazon Web Services )installation scripts for CentOS 7 to create LAMP stack and install Wordpress

STEPS TO INSTALL
1. login to lightsail.aws.amazon.com and [create instance].  Choose [OS Only] CentOS 7 2009-01

2. In the box for Launch script, copy&paste the text from the "bootstrap" file in this repo.  This will automatically copy the
   this repo and us it to configure the server for wordpress. It will install php, wordpress, mysql, etc.

3. Set up the static public IP of the lightsail instance and try to open the webpage at that IP.  You may have to open http & https in the Lightsail network settings and the firewall for the instance. 
4. At this point, open your browser to website www.datos.asia to see if you are at a WordPress Setup Screen.  If not, you can login to the instance via the lightsail console to check if httpd is running.  
i.e. 
#systemctl status httpd

5. Run the script addssl.sh to install certbot and the free ssl certificates.  This will also create the /etc/httpd/conf.d/vhosts.conf file.
6. Run the script vsftpd.sh to install FTP and create a user called ftpuser for Wordpress updates.  This user is in the apache group. This should start the ftp server so test by logging in with ftp.  You need to install ftp client software if you are testing from the new server..also set the password for the ftpuser.  i.e.

 
   #passwd ftpuser   
   
   #bash ./vsftpd.sh

7. Run the script to copy a database backup from a remote server to this server and restore wordpress. Just enter the backup date in YYYY-MM-DD.


   #bash migratewp.sh
   
8. Copy the /var/www/html directory and files from a backup. 
   #tar -xvzf /root/html.2020-12-08.tar.gz 

9. This will change the default wp-config.php file and will break wordpress until you update the passwords. You will most likely need to set the mysql password to match the password stored in the wp-config.php file, or edit the wp-config.php password to match your mysql password.

  /** MySQL database password */define('DB_PASSWORD', 'PASSWORD');

10. The wordpress site should now work.  If you have changed the URL of the wordpress site, you will need to replace any hardcoded URL with the new website. Follow instruction in migratewp.sh to change the URL of wordpress stored in the mysql database.

i.e. The login link may be pointing to http://datostech.com/login.php and will need to point to http://datos.asia/login.php if this is the new website URL.

PROBLEMS Encountered:
<pre>
1. SELINUX causes problems.  If using SELINUX enforcing, change this boolean for httpd_anon_write->On
   #setsebool -P httpd_anon_write=1
  This causes problems with permalinks because the server cannot write the .htaccess file
  
2./etc/httpd/conf/httpd.conf.  Edit the <directory /var/www/html> block to set "AllowOveride ALL"
  The causes problems with permalinks because the .htaccess is ignored.
</pre>

3. Amazon SES (Simple Email Services) must be enabled for the domains that you send email.  
   Do this on the AWS console.  You will need to verify domains by adding the keys from AWS to your DNS.
