/ip address
add address=10.10.10.2/30 interface=ether2
add address=10.10.14.1/30 interface=ether3
add address=10.10.11.2/30 interface=ether4

/interface bridge
add name=loopback
/ip address 
add address=10.255.255.3/32 interface=loopback network=10.255.255.3

/routing ospf instance
add name=inst router-id=10.255.255.3
/routing ospf area
add name=backbonev28 area-id=0.0.0.0 instance=inst
/routing ospf network
add area=backbonev28 network=10.10.10.0/30
add area=backbonev28 network=10.10.11.0/30
add area=backbonev28 network=10.10.14.0/30
add area=backbonev28 network=10.255.255.3/32
/routing ospf lsa print
/routing ospf instance set inst redistribute-connected=as-type-1

/mpls ldp
set lsr-id=10.255.255.3
set enabled=yes transport-address=10.255.255.3
/mpls ldp interface
add interface=ether2
add interface=ether3
add interface=ether4

/routing bgp instance
set default as=64512 router-id=10.255.255.3
/routing bgp peer
add name=NY remote-address=10.255.255.1 address-families=l2vpn,vpnv4 remote-as=64512 update-source=loopback route-reflect=no 
add name=HKI remote-address=10.255.255.2 address-families=l2vpn,vpnv4 remote-as=64512 update-source=loopback route-reflect=yes
add name=LBN remote-address=10.255.255.4 address-families=l2vpn,vpnv4 remote-as=64512 update-source=loopback route-reflect=yes
/routing bgp network
add network=10.255.255.0/24

/user
add name=paninanq password=paninanq group=full
remove admin
/system identity
set name=R01.LND