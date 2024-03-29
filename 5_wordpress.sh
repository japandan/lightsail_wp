#!/bin/bash
#
echo "This will install a new copy of wordpress under nginx"
echo "This is a good way to test the nginx configuration for redirect & permalinks"
echo "This is also a good way to test the host for ability to update wordpress via vsftp"
#
# create database in mysql for new install of wp
echo "create database wordpress;">dbsetup.sql
echo "create user wpadmin@localhost identified by 'ChangeM3';">>dbsetup.sql
echo "grant all privileges on wordpress.* to wpadmin@localhost identified by 'ChangeM3';">>dbsetup.sql
echo "flush privileges;">>dbsetup.sql
#
mysql -uroot <dbsetup.sql
cd ~
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
sudo rsync -avP ~/wordpress/ /var/www/html/
mkdir /var/www/html/wp-content/uploads
sudo chown -R nginx:nginx /var/www/html
#
echo "open up the url for the website http://datos.asia and check if you can see the wordpress startup"
echo "Go ahead and create a new wordpress site and test the blog/permalinks to make sure they work"
echo "There are some nginx config changes needed for these to work."
echo "https://tecnstuff.net/how-to-install-wordpress-with-nginx-on-centos-7/"
