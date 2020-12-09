#!/bin/bash
# this will help you setup vsftpd so that you can make updates to the wordpress site
# It is not safe to leave vsftpd running all the time but if you configure it to work 
# you can shut it down when not needed.
#
# selinux creates problems so allow access to vsftpd
sudo setsebool -P ftpd_full_access on   
sudo setsebool -P ftpd_use_passive_mode  on
sudo yum install vsftpd
sudo user useradd ftpuser -d/var/www/html -Gapache
sudo chmod -R g+w /var/www/html
##
##  edit /etc/vsftpd/vsftpd.conf to allow pasv mode
# add these lines and edit the LightSail network to allow TCP ports 64000-64300
sudo cat >>/etc/vsftpd/vsftpd.conf <<'EOF'
pasv_enable=YES
pasv_min_port=64000
pasv_max_port=64300
pasv_address=3.114.205.254
listen=YES
# comment listen_ipv6 or set to NO
listen_ipv6=NO
EOF
