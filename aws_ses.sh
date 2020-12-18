#!/bin/bash
# 
# Script to configure Postfix to work with Amazon SES
#
region="ap-northeast-1"
smtp_host="email-smtp.${region}.amazonaws.com"
#
echo "Setting postfix to use $smtp_host"
#
sudo postconf -e "relayhost = [${smtp_host}]:587" \
"smtp_sasl_auth_enable = yes" \
"smtp_sasl_security_options = noanonymous" \
"smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" \
"smtp_use_tls = yes" \
"smtp_tls_security_level = encrypt" \
"smtp_tls_note_starttls_offer = yes"
#
# FYI only
# This section was not coded since the entry did not exist in my lightsail master.cf
# In a text editor, open the file /etc/postfix/master.cf.
# Search for the following entry:
#
#   -o smtp_fallback_relay=
#
#  If you find this entry, comment it out by placing a # (hash) character 
#  at the beginning of the line. Save and close the file. 
#
read -p 'SMTPUSERNAME ? ' SMTPUSERNAME
read -p 'SMTPPASSWORD ? ' SMTPPASSWORD
echo "[${smtp_host}]:587 ${SMTPUSERNAME}:${SMTPPASSWORD}"|sudo tee /etc/postfix/sasl_passwd
