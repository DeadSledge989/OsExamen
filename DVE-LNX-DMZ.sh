#!/bin/bash

# Hostname
hostname DVE-LNX-DMZ

# IP Settings
echo "" > /etc/sysconfig/network/ifcfg-eth0
echo "IPADDR='10.10.14.254/24'" >> /etc/sysconfig/network/ifcfg-eth0
echo "BOOTPROTO='static'" >> /etc/sysconfig/network/ifcfg-eth0
echo "STARTMODE='auto'" >> /etc/sysconfig/network/ifcfg-eth0
echo "zone='public'" >> /etc/sysconfig/network/ifcfg-eth0

# routes
echo "" > /etc/sysconfig/network/routes
echo "default 10.10.14.1 - -" >> /etc/sysconfig/network/routes

# DNS
echo 'NETCONFIG_DNS_STATIC_SERVERS="10.11.14.2"' >> /etc/sysconfig/network/config

# Reboot network service
service network restart

# Update
zypper update -y

# Firewall
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --add-service=ssh --permanent
firewall-cmd --reload

# Webserver
zypper install -y apache2
echo "CustomLog \"| /bin/sh -c '/usr/bin/tee -a /var/log/httpd/httpd-access.log | /usr/bin/logger -t httpd local1.info\'\" combined" >> /etc/apache2/httpd.conf

systemctl enable apache2.service
systemctl start apache2.service

# HTML file
echo "test-dmz" > /srv/www/htdocs/index.html

# RSyslog
zypper install rsyslog
echo "*.* @@10.11.14.11:514" >> /etc/rsyslog.conf
systemctl restart rsyslog
systemctl enable rsyslog