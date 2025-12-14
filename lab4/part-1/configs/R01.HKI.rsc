/ip address
add address=10.10.12.2/30 interface=ether2
add address=10.10.11.1/30 interface=ether3
add address=10.10.13.2/30 interface=ether4

/interface bridge
add name=loopback
/ip address 
add address=10.255.255.2/32 interface=loopback network=10.255.255.2

/routing ospf instance
add name=inst router-id=10.255.255.2
/routing ospf area
add name=backbonev28 area-id=0.0.0.0 instance=inst
/routing ospf network
add area=backbonev28 network=10.10.12.0/30
add area=backbonev28 network=10.10.11.0/30
add area=backbonev28 network=10.10.13.0/30
add area=backbonev28 network=10.255.255.2/32
/routing ospf lsa print
/routing ospf instance set inst redistribute-connected=as-type-1

/mpls ldp
set lsr-id=10.255.255.2
set enabled=yes transport-address=10.255.255.2
/mpls ldp interface
add interface=ether2
add interface=ether3
add interface=ether4

/routing bgp instance
set default as=64512 router-id=10.255.255.2
/routing bgp peer
add name=SPB address-families=l2vpn,vpnv4 remote-address=10.255.255.5 remote-as=64512 update-source=loopback route-reflect=no 
add name=LND address-families=l2vpn,vpnv4 remote-address=10.255.255.3 remote-as=64512 update-source=loopback route-reflect=yes 
add name=LBN address-families=l2vpn,vpnv4 remote-address=10.255.255.4 remote-as=64512 update-source=loopback route-reflect=yes 
/routing bgp network
add network=10.255.255.0/24

/user
add name=paninanq password=paninanq group=full
remove admin
/system identity
set name=R01.HKI