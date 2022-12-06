#!/bin/bash

# Hostname
hostname DVE-LNX-11

# IP Settings
echo "" > /etc/sysconfig/network/ifcfg-eth0
echo "IPADDR='10.11.14.11/24'" >> /etc/sysconfig/network/ifcfg-eth0
echo "BOOTPROTO='static'" >> /etc/sysconfig/network/ifcfg-eth0
echo "STARTMODE='auto'" >> /etc/sysconfig/network/ifcfg-eth0
echo "zone='public'" >> /etc/sysconfig/network/ifcfg-eth0

# DNS
echo 'NETCONFIG_DNS_STATIC_SERVERS="10.11.14.2"' >> /etc/sysconfig/network/config

# routes
echo "" > /etc/sysconfig/network/routes
echo "default 10.11.14.1 - -" >> /etc/sysconfig/network/routes

# Reboot network service
service network restart

# Firewall
systemctl stop firewalld.service
systemctl disable firewalld.service

# Update
zypper update -y

# RSyslog
zypper install rsyslog
echo '# Provides TCP syslog reception' >> /etc/rsyslog.conf
echo '$ModLoad imtcp.so' >> /etc/rsyslog.conf
echo '$InputTCPServerRun 514' >> /etc/rsyslog.conf
echo " " >> /etc/rsyslog.conf
echo '$template DynamicFile,"/var/log/%HOSTNAME%/forwarded-logs.log"' >> /etc/rsyslog.conf
echo '*.* -?DynamicFile' >> /etc/rsyslog.conf
echo 'local1.* @10.10.14.254:514' >> /etc/rsyslog.conf
systemctl restart rsyslog
systemctl enable rsyslog