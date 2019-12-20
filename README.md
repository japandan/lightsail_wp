# lightsail_wp
Lightsail installation scripts for CentOS 7 to create LAMP stack and install Wordpress

PROBLEMS Encountered:

1. SELINUX causes problems.  If using SELINUX enforcing, change this boolean for httpd_anon_write->On
   #setsebool -P httpd_anon_write=1
  This causes problems with permalinks because the server cannot write the .htaccess file

2./etc/httpd/conf/httpd.conf.  Edit the <directory /var/www/html> block to set "AllowOveride ALL"
  The causes problems with permalinks because the .htaccess is ignored.
