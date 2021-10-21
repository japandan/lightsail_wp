#!/bin/bash
#
# this will install certbot and create ssl certificate for the new site
yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
sudo yum install -y certbot-nginx bind-utils
## Add the server names for the ssl
sed -i 's/server_name _;/server_name datos.asia www.datos.asia datostech.com mail.datostech.com www.datostech.com;/' /etc/nginx/sites-enabled/00-default.conf 
sed -i 's/server_name _;/server_name datos.asia www.datos.asia datostech.com mail.datostech.com www.datostech.com;/' /etc/nginx/sites-enabled/00-default-ssl.conf
systemctl restart nginx
#
certbot --nginx -d datos.asia -d www.datos.asia -d mail.datostech.com -d www.datostech.com -d datostech.com
#Congratulations! You have successfully enabled https://aws.datos.asia and https://vhost1.datos.asia
#
echo You should test your configuration at:
echo https://www.ssllabs.com/ssltest/analyze.html?d=datos.asia
echo https://www.ssllabs.com/ssltest/analyze.html?d=mail.datostech.com
echo https://www.ssllabs.com/ssltest/analyze.html?d=www.datostech.com
#
#   
#echo Adding more security diffie-Hellman
#openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
#sed -i '/server/a ssl_dhparam /etc/ssl/certs/dhparam.pem;' /etc/nginx/nginx.conf
#nginx -t
#systemctl reload nginx
#
echo To obtain a new or tweaked   version of this certificate in the future, 
echo simply run certbot again   with the "certonly" option. 
echo To non-interactively renew *all* of   your certificates, run "certbot renew" 
echo
echo "Copying nginx config to /etc/nginx/sites-enabled/"
cp /etc/nginx/sites-enabled/00-default-ssl.conf /etc/nginx/sites-enabled/00-default-ssl.conf.bak
cp /root/lightsail_wp/00-default-ssl.conf /etc/nginx/sites-enabled/00-default-ssl.conf 
echo
echo "Replacing iRedMail certificates"
mv -f /etc/pki/tls/private/iRedMail.key /root/
mv -f /etc/pki/tls/certs/iRedMail.crt   /root/
ln -s /etc/letsencrypt/live/datos.asia/privkey.pem /etc/pki/tls/private/iRedMail.key
ln -s /etc/letsencrypt/live/datos.asia/fullchain.pem /etc/pki/tls/certs/iRedMail.crt
#
echo done.
