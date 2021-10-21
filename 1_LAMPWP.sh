#!/bash/bin
# AWS Lightsail Launch Script to create LAMP server by adding mysql, php, and nginx
# mysql & http
# This will not install nginx because that will be installed along with the iredmail server
# in a following step.
#
echo "Begin LAMPWP setup script for MariaDB,PHP 7.3 and Wordpress">>/root/INSTALL.LOG
echo "Installing mariadb(mysql)" >>/root/INSTALL.LOG
# This is mysql
yum install -y epel-release mariadb-server
systemctl start mariadb
systemctl enable mariadb
echo "there is no root password on mysql yet" >>/root/INSTALL.LOG
echo "mysql_secure_installation should be run manually or automated.">>/root/INSTALL.LOG
#
# TMUX is a handy program to run in case you have scripts to run and need to disconnect
# from the server while they run.  Run "tmux" after logging in.  If you get logged of
# run "#tmux attach" to resume
yum install -y tmux
#
# php 7.3 install
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php73
yum install libicu oniguruma5php
yum install -y php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysql php-imap php-mbstring php73-php-int
yum install -y php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysql php-imap php-mbstring php73-php-intl 
php -v >>/root/INSTALL.LOG
#
# create user and copy keys for ssh login
useradd danvogel
mkdir -p /home/danvogel/.ssh
cp /home/centos/.ssh/authorized_keys /home/danvogel/.ssh/
chown -R danvogel:danvogel /home/danvogel/.ssh/*
hostnamectl set-hostname mail >>/root/INSTALL.LOG
#
echo "Adding login banner" >>/root/INSTALL.LOG
cp /root/lightsail_wp/ssh-banner /etc/motd
#
yum update -y >>/root/INSTALL.LOG
echo "done. rebooting.">>/root/INSTALL.LOGreboot
