#!/bin/bash
echo "Checking all the services that are needed for email and wordpress"
for service in slapd nginx mariadb postfix iredapd dovecot sogod
do
	echo -n "$service :"
	systemctl status $service|grep -i active
	echo
done
