#!/bin/bash
#
# this will install certbot and create ssl certificate for the new site
yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
sudo yum install -y certbot python2-certbot-apache bind-utils
## make sure that you have virtual host config in apache for example /etc/httpd/conf.d/vhosts.conf
sudo cat >/etc/httpd/conf.d/vhosts.conf <<'EOF'
<VirtualHost *:80>
 DocumentRoot "/var/www/html"
 ServerName www.datos.asia
 ServerAlias datos.asia
 #ServerAlias datostech.com
 #ServerAlias www.datostech.com
</VirtualHost>
EOF
sudo systemctl restart httpd
certbot --apache
#Congratulations! You have successfully enabled https://aws.datos.asia and https://vhost1.datos.asia
#You should test your configuration at:
#https://www.ssllabs.com/ssltest/analyze.html?d=aws.datos.asia
#https://www.ssllabs.com/ssltest/analyze.html?d=vhost1.datos.asia
#
#Congratulations! Your certificate and chain have been saved at:   
#/etc/letsencrypt/live/aws.datos.asia/fullchain.pem   
#Your key file has been saved at:   /etc/letsencrypt/live/aws.datos.asia/privkey.pem
#Your cert will expire on 2020-03-08. To obtain a new or tweaked   version of this certificate in the future, 
#simply run certbot again   with the "certonly" option. 
#To non-interactively renew *all* of   your certificates, run "certbot renew" 
