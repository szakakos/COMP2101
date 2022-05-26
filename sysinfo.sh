#!/bin/bash
echo "Host Name: $(hostname)" #Display the hostname variable with formatting
echo "DNS Domain Name: "`hostname -f` #Display the DNS Domain
echo `hostnamectl | grep "Operating System"` #Get just the operating system value from hostnamectl
echo  "IP Addressing Information: \\n" `ifconfig | grep inet | awk -F ' ' '{print $2}' | grep -v '^172'`
#Invoke ifconfig, only take lines with inet, seperate the data and print it, only display ips beginning in 172.
echo "Root Filesystem Status: "
df -hT /
#Invoke DF with human readable formatting, reports the system type, and only displays the main drive.
