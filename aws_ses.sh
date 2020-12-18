#!/bin/bash
region="ap-northeast-1"
smtp_host="email-smtp.${region}.amazonaws.com"
echo "Setting postfix to use $smtp_host"
#
sudo postconf -e "relayhost = [${smtp_host}]:587" \
"smtp_sasl_auth_enable = yes" \
"smtp_sasl_security_options = noanonymous" \
"smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" \
"smtp_use_tls = yes" \
"smtp_tls_security_level = encrypt" \
"smtp_tls_note_starttls_offer = yes"
