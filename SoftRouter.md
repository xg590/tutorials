## Make a Soft WiFi Router
### What router do
* Layer 2 switching: forward frames between connected devices 
* IP management: respond devices with ip address and other network configuration.
* Layer 3 routing: gateway to the public net space.
### Materials
* Two NICs: I have two Wireless NICs (Network Interface Card) and a wired NIC. I will use two wireless ones. One joined another internet-connected WiFi network. One would serve a WiFi sub-network. 
* Two softwares: I need hostapd to host an access point and isc-dhcp-server to host a DHCP service. I also need linux-builtin iptables
