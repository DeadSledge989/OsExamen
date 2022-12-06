#!/bin/bash

# Hostname
hostname DVE-LNX-10

# IP Settings
echo "" > /etc/sysconfig/network/ifcfg-eth0
echo "IPADDR='10.11.14.10/24'" >> /etc/sysconfig/network/ifcfg-eth0
echo "BOOTPROTO='static'" >> /etc/sysconfig/network/ifcfg-eth0
echo "STARTMODE='auto'" >> /etc/sysconfig/network/ifcfg-eth0
echo "zone='public'" >> /etc/sysconfig/network/ifcfg-eth0

echo "" > /etc/sysconfig/network/ifcfg-eth1
echo "IPADDR='10.12.14.10/24'" >> /etc/sysconfig/network/ifcfg-eth1
echo "BOOTPROTO='static'" >> /etc/sysconfig/network/ifcfg-eth1
echo "STARTMODE='auto'" >> /etc/sysconfig/network/ifcfg-eth1
echo "zone='public'" >> /etc/sysconfig/network/ifcfg-eth1

# DNS
echo 'NETCONFIG_DNS_STATIC_SERVERS="10.11.14.2"' >> /etc/sysconfig/network/config

# routes
echo "" > /etc/sysconfig/network/routes
echo "default 10.11.14.1 - -" >> /etc/sysconfig/network/routes
echo "10.99.14.0/24 10.12.14.20 - -" >> /etc/sysconfig/network/routes

# Ip Routing
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.conf

# Reboot network service
service network restart

# Firewall
systemctl stop firewalld.service
systemctl disable firewalld.service


# Update
zypper update -y

# DHCP-Relay
zypper install -y dhcp-relay
systemctl enable dhcrelay
dhcrelay 10.11.14.2