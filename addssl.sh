#!/bin/bash
#
# this will install certbot and create ssl certificate for the new site
yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
sudo yum install -y certbot bind-utils
## Add the server names for the ssl
sed -i 's/server_name _;/server_name datos.asia www.datos.asia mail.datostech.com www.datostech.com;/' /etc/nginx/sites-enabled/00-default.conf 
sed -i 's/server_name _;/server_name datos.asia www.datos.asia mail.datostech.com www.datostech.com;/' /etc/nginx/sites-enabled/00-default-ssl.conf
systemctl restart nginx
#
certbot --nginx -d datos.asia -d www.datos.asia -d mail.datostech.com -d www.datostech.com 
#Congratulations! You have successfully enabled https://aws.datos.asia and https://vhost1.datos.asia
#
echo You should test your configuration at:
echo https://www.ssllabs.com/ssltest/analyze.html?d=datos.asia
echo https://www.ssllabs.com/ssltest/analyze.html?d=mail.datostech.com
echo https://www.ssllabs.com/ssltest/analyze.html?d=www.datostech.com
#
#   
echo To obtain a new or tweaked   version of this certificate in the future, 
echo simply run certbot again   with the "certonly" option. 
echo To non-interactively renew *all* of   your certificates, run "certbot renew" 
echo done.
