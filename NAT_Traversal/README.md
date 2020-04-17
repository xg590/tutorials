## Detect the NAT Type
### NAT Existence Detection:<br>
Server Side --- universally accessible xxx.com
```
import socket 
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # UDP protocol
s.bind(('', 12345))                                   # use port 12345 to communicate 
_, pub_addr = s.recvfrom(0)                           # detect the public addr of client
print(pub_addr)                                       
```
Client Side --- Perhaps behind NAT:
```
import json, socket 
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 
s.sendto(b'', ('xxx.com', 12345))                     # contact with xxx.com 
print(s.recv(1024))                                   # to be explained 
```
When client contacts with xxx.com, server gets the public addr of client. If the client could not find the public addr in its binding IP list, then the client is behind NAT.<br><br>
List the binding IP of localhost:
```
import socket, fcntl, struct # Code origin https://stackoverflow.com/a/27494105

def get_ip(nicName):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        ip = socket.inet_ntoa(fcntl.ioctl(
            s.fileno(),
            0x8915,  # SIOCGIFADDR
            struct.pack('256s', nicName[:15].encode("UTF-8"))
        )[20:24])
    except:
        ip = None
    return ip

nic_info = [(nicName, get_ip(nicName)) for i, nicName in socket.if_nameindex() if nicName!='lo'] 
print(nic_info)
```
### Full Cone NAT: the outbound port on NAT accepts any inbound connection. (Example: Virtualbox NAT scheme)
During NAT existence detection (if NAT does exist), the sever caught an addr ['128.111.111.111', 22222]. Port 22222 is opened on NAT for the reply from sever, and the opening is triggered by contacting from client to server. If the NAT is full cone, any third party can communicate with client via 128.111.111.111:22222]<br>
A third party host:
```
# The code should run right after we detected the NAT 
# Now we see a reply on client side
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  
s.sendto(b'NAT Traversed', ('128.111.111.111', 22222))
```
If the client got 'NAT Traversed' from the third party, the NAT is full cone type.<br>
Summary: if x.x.x.x:x (Client behind NAT) -> 128.111.111.111:22222 (NAT) -> xxx.com:12345 (Server) is OK, then y.y.y.y:y (any host) -> 128.111.111.111:22222 (NAT) -> x.x.x.x:x (Client behind NAT) is possible<br> 
### Restricted Cone NAT: the outbound port on NAT accept only incoming connection from contacted ip. (Mobile Network, router, AP)
Server side:
```
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 
s.bind(('', 12345))                                   
_, addr = s.recvfrom(0)                              # Catch the addr of client behind NAT when port 12345 of the server 
c = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # is contacted. Try to reply with another port 
c.bind(('', 22222))                                   
c.sendto(b'NAT Traversed', addr)
```
client side:
```
import json, socket
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  
s.sendto(b'', ('xxx.com', 12345))
print(s.recv(1024))
```
Summary: if x.x.x.x:x (Client behind NAT) -> 128.111.111.111:22222 (NAT) -> xxx.com:12345 (Server) is OK, then xxx.com:y (only the same server but any port is OK) -> 128.111.111.111:22222 (NAT) -> x.x.x.x:x (Client behind NAT) is possible<br>
### Port Restricted Cone NAT: the outbound port on NAT accept only incoming connection from contacted ip:port. (Haven't met)
Summary: if x.x.x.x:x (Client behind NAT) -> 128.111.111.111:22222 (NAT) -> xxx.com:12345 (Server) is OK, then xxx.com:<b>12345</b>(only the same server and same port is OK) -> 128.111.111.111:22222 (NAT) -> x.x.x.x:x (Client behind NAT) is possible<br>


This Example works for both Python v2 and v3 on Linux or QPython on Android. <br>
<p>
Running server-side py on a host with public IP as a salon host, who will introduce the another partner of a conversation. <br>
Running client-side py on a host behind NAT or not, who will get introduction from server and start the conversation on its own after with another client. <br>
Presence of 2 clients is required before the introduction and then the salon host can move around for next introduction for another two clients. <br>
<p>
Lots of Credits to https://github.com/dwoz/python-nat-hole-punching, while codes here have more notes and explanations

