#!/bin/bash
# This will install aide intrustion detection which will also help troubleshoot
# because you can use it to see what files are changed by each installation step.
# aide --check   ## will tell you the changes made 
# aide --update  ## will clear the changes so you can look for the next changes
#
sudo yum update -y
sudo yum install -y aide
sudo aide --init
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
#add a check at midnight
sudo echo "0 0 * * * root /usr/sbin/aide --check" >> /etc/crontab
#
# test it out
aide --check
# should show that you modified the crontab
