#!/bin/bash
# these commands will restore the wordpress site from a backup
# this should create a wordpress multi-site for now.  We may need to convert later.
# we will change the WP site ID to the new domain location after copying files and wp mysql db
#
#for ease of use, I recommend executing ssh-keygen and ssh-copy-id to transfer ssh key to the backup
#server so scp & ssh do not prompt for passwords.
#
# Retrieve the backups
read -p "type the date of the backups in format YYYY-MM-DD" backupdate
scp -P1965 danvogel@asus.datos.asia:/backupdir/wordpress.$backupdate.sql /root/
scp -P1965 danvogel@asus.datos.asia:/backupdir/html.$backupdate.tar.gz /root/
scp -P1965 danvogel@asus.datos.asia:/backupdir/etc.$backupdate.tar.gz /root/
scp -P1965 danvogel@asus.datos.asia:/backupdir/scripts /root/
##
## delete the existing wordpress database and copy from backup
mysql -uroot 
MariaDB[(none)]> drop database wordpress;
MariaDB[(node)]> create database wordpress;
quit;
mysql -uwpadmin -pChangeM3 wordpress< /root/wordpress.$backupdate.sql
# now the password for wpadmin will not match the password in the old site's
# wp-config.php file (unless it is "ChangeM3").  Change the password in mysql 
# for wpadmin to match the password in /var/www/html/wp-config.php
# Check the {password, username, database name, host} using this command
grep DB_ /var/www/html/wp-config.php
# Set the password using this command.
#
# also you will need to use mysql to change the wp_options id#1,2 which contains the 
# name of the old wordpress URL/Home
#MariaDB [wordpress]> select option_id,option_name,option_value from multi_options where option_id <3;
#+-----------+-------------+----------------------+
#| option_id | option_name | option_value         |
#+-----------+-------------+----------------------+
#|         1 | siteurl     | http://datostech.com |
#|         2 | home        | http://datostech.com |
#+-----------+-------------+----------------------+
# Change the option_values with this command
#MariaDB [wordpress]> update multi_options set option_value="http://www.datos.asia" where option_id<3;
#Query OK, 2 rows affected (0.00 sec)Rows matched: 2  Changed: 2  Warnings: 0
#
# check them again...
#MariaDB [wordpress]> select option_id,option_name,option_value from multi_options where option_id <3;
#+-----------+-------------+-----------------------+
#| option_id | option_name | option_value          |
#+-----------+-------------+-----------------------+
#|         1 | siteurl     | http://www.datos.asia |
#|         2 | home        | http://www.datos.asia |
#+-----------+-------------+-----------------------+
#2 rows in set (0.00 sec)
#
echo "Additionally define url in wp-config.php file"
grep http /var/www/html/wp-config.php
echo "define('WP_HOME','http://example.com');"
echo "define('WP_SITEURL','http://example.com');"

