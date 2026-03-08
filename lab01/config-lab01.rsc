# 2026-02-11 16:38:49 by RouterOS 7.21.3
# software id = DTHM-8ZQ1
#
# model = S53UG+M-5HaxD2HaxD
# serial number = HGQ09NRXN2R
/interface bridge
add name=bridge1
/interface wifi
set [ find default-name=wifi1 ] configuration.mode=ap .ssid=MyWifi disabled=\
    no security.authentication-types=wpa2-psk,wpa3-psk
/interface lte
# SIM not present
set [ find default-name=lte1 ] allow-roaming=no band="" nr-band=""
/ip dhcp-server
add disabled=yes interface=bridge1 name=server1
/ip pool
add name=dhcp_pool0 ranges=192.168.88.2-192.168.88.254
/ip dhcp-server
# Interface not running
add address-pool=dhcp_pool0 interface=ether1 name=dhcp1
/interface bridge port
add bridge=bridge1 interface=ether2
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=ether5
add bridge=bridge1 interface=wifi1
add bridge=bridge1 interface=wifi2
/ip address
add address=192.168.88.1/24 comment="default configuration" interface=ether1 \
    network=192.168.88.0
add address=10.0.0.254/24 comment="eth1 to net 10.0.0.0/24" interface=ether1 \
    network=10.0.0.0
add address=192.168.1.1/24 comment=bridge1 interface=bridge1 network=\
    192.168.1.0
/ip dhcp-server network
add address=192.168.1.0/24 dns-server=8.8.8.8 gateway=192.168.1.1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add comment="Default Gateway" disabled=no distance=1 dst-address=0.0.0.0/0 \
    gateway=10.0.0.1 routing-table=main
