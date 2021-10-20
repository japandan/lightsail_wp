#!/bin/bash
echo "Checking all the services that are needed for email and wordpress"
systemctl status nginx
systemctl status mariadb
systemctl status postfix
systemctl status iredapd
systemctl status dovecot
systemctl status clamav
systemctl status slapd
