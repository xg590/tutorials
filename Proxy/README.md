## Remarks on Proxy
### National Firewall of China (So-called Great FireWall)
* It will block most well-known VPN protocols (like softether, openvpn), since they are not designed to confuse the National Firewall and snuck outside information into China. 
* Some proxy protocols like shadowsocks and v2ray are designed to circumvent the National Firewall but I personally do not recommand them. 
  * They are the target of National Firewell. The user is play hide and seek. One day or another, shadowsocks stops working. 
  * They are against the local rules. The legal implication is huge.
  * Requires extra client softwares. 
* I believe a better solution is:
  * Connect to an oversea proxy server via common tunneling protocols.
  * Create secondary VPN service which supports common VPN protcols (like ikev2 or sstp). 
    * The secondary VPN service will not be bothered by National Firewall which are working on international traffics.
    * Windows/Linux/MacOS/iOS/Android support the secondary VPN service natively (without any external software, only needs configuration)
### Secondary VPN service.
* PPTP is the most simple one but technically it is not VPN. It involves no encryption. It is not private. There is no privacy. 
  * It works well on LAN. 
  * Windows support it! iOS/MacOS does not.
* ikev2 is the best since it works on most Operating System.
  * MacOS, Windows, iOS, iPadOS, android support it natively.
  * Traffic is encryptied. 
### Schemes
* When I need to visit source behind the university gateway, I will create a VPN network, put a raspberry pi inside the university so that I can forward traffic outside of the university to resource inside the university. 
* When I need to visit Google inside China. I use pptp over SSH tunneling to establish the connection between an oversea proxy server and a local server. SSH tunneling is not conventional VPN protocol so it is not blocked by National Firewall. I use ikev2 as the protcol for the secondary VPN service. 