#!/bin/bash

# Hostname
hostname DVE-LNX-21

# IP Settings
echo "" > /etc/sysconfig/network/ifcfg-eth0
echo "IPADDR='10.12.14.21/24'" >> /etc/sysconfig/network/ifcfg-eth0
echo "BOOTPROTO='static'" >> /etc/sysconfig/network/ifcfg-eth0
echo "STARTMODE='auto'" >> /etc/sysconfig/network/ifcfg-eth0
echo "zone='public'" >> /etc/sysconfig/network/ifcfg-eth0

# DNS
echo 'NETCONFIG_DNS_STATIC_SERVERS="10.11.14.2"' >> /etc/sysconfig/network/config

# routes
echo "" > /etc/sysconfig/network/routes
echo "default 10.12.14.10 - -" >> /etc/sysconfig/network/routes

# Reboot network service
service network restart

# Firewall
systemctl stop firewalld.service
systemctl disable firewalld.service

# Update
zypper update -y