New-NetIPAddress -IPAddress 10.11.14.2 -DefaultGateway 10.11.14.1 -PrefixLength 24 -InterfaceAlias 'Ethernet0'
Set-DnsClientServerAddress -ServerAddresses 10.11.14.2,8.8.8.8 -InterfaceAlias 'Ethernet0'

Install-WindowsFeature DNS -IncludeManagementTools

Install-WindowsFeature DHCP -IncludeManagementTools
netsh dhcp add securitygroups
Restart-Service dhcpserver

Add-DhcpServerV4Scope -name “vlan86” -StartRange 10.11.14.200 -Endrange 10.11.14.250 -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerv4OptionValue -ScopeId 10.11.14.200 -DnsServer 10.11.14.2 -Router 10.11.14.1 -DnsDomain vlan86.kingstefan

Add-DhcpServerV4Scope -name “vlan87” -StartRange 10.12.14.200 -Endrange 10.12.14.250 -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerv4OptionValue -ScopeId 10.12.14.200 -DnsServer 10.11.14.2 -Router 10.12.14.10 -DnsDomain vlan87.kingstefan

Add-DhcpServerV4Scope -name “vlan88” -StartRange 10.99.14.200 -Endrange 10.99.14.250 -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerv4OptionValue -ScopeId 10.99.14.200 -DnsServer 10.11.14.2 -Router 10.99.14.20 -DnsDomain vlan88.kingstefan

Add-DnsServerPrimaryZone kingstefan -DynamicUpdate None -ZoneFile kingstefan.dns
Add-DnsServerPrimaryZone -NetworkId 10.0.0.0/8 -ZoneFile 0.0.10.in-addr.arpa.dns

Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru
Add-DnsServerForwarder -IPAddress 8.8.4.4 -PassThru


Add-DnsServerResourceRecordA -createPtr -Name Pfsense -ZoneName kingstefan -IPv4Address 10.11.14.1

Add-DnsServerResourceRecordA -createPtr -Name dve-lnx-dmz -ZoneName kingstefan -IPv4Address 10.10.14.254

Add-DnsServerResourceRecordA -createPtr -Name dve-lnx-10 -ZoneName kingstefan -IPv4Address 10.11.14.10
Add-DnsServerResourceRecordA -createPtr -Name dve-lnx-11 -ZoneName kingstefan -IPv4Address 10.11.14.11
Add-DnsServerResourceRecordA -createPtr -Name dve-win2019 -ZoneName kingstefan -IPv4Address 10.11.14.2

Add-DnsServerResourceRecordA -createPtr -Name dve-lnx-20 -ZoneName kingstefan -IPv4Address 10.12.14.20
Add-DnsServerResourceRecordA -createPtr -Name dve-lnx-21 -ZoneName kingstefan -IPv4Address 10.12.14.21

Add-DnsServerResourceRecordA -createPtr -Name dve-lnx-31 -ZoneName kingstefan -IPv4Address 10.14.31