/ip address
add address=10.10.10.1/30 interface=ether2
add address=192.168.30.1/24 interface=ether3

/interface bridge
add name=loopback
/ip address 
add address=10.255.255.1/32 interface=loopback network=10.255.255.1

/routing ospf instance
add name=inst router-id=10.255.255.1
/routing ospf area
add name=backbonev28 area-id=0.0.0.0 instance=inst
/routing ospf network
add area=backbonev28 network=10.10.10.0/30
add area=backbonev28 network=192.168.30.0/24
add area=backbonev28 network=10.255.255.1/32
/routing ospf lsa print
/routing ospf instance set inst redistribute-connected=as-type-1

/mpls ldp
set lsr-id=10.255.255.1
set enabled=yes transport-address=10.255.255.1
/mpls ldp interface
add interface=ether2
add interface=ether3

/routing bgp instance
set default as=64512 router-id=10.255.255.1
/routing bgp peer
add name=LND remote-address=10.255.255.3 address-families=l2vpn,vpnv4 remote-as=64512 update-source=loopback route-reflect=no 
/routing bgp network
add network=10.255.255.0/24

/interface bridge 
add name=vpn
/interface bridge port
add interface=ether3 bridge=vpn
/interface vpls bgp-vpls
add bridge=vpn export-route-targets=64512:100 import-route-targets=64512:100 name=vpls route-distinguisher=64512:100 site-id=1
/ip address
add address=10.100.1.2/24 interface=vpn

/user
add name=paninanq password=paninanq group=full
remove admin
/system identity
set name=R01.NY