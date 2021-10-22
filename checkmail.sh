#!/bin/bash
echo "Checking all the services that are needed for email and wordpress"
systemctl status nginx
systemctl status mariadb
systemctl status postfix
systemctl status iredapd
systemctl status dovecot
systemctl status slapd
# stop clamav because memory was low
#systemctl status clamav

