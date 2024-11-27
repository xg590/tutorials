### Fingerprint conflict
* Symptom
```txt
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ED25519 key sent by the remote host is
SHA256:xxxxxxxxxxxxxxxxxxxxxxx.
Please contact your system administrator.
Add correct host key in /home/a/.ssh/known_hosts to get rid of this message.
Offending ED25519 key in /home/a/.ssh/known_hosts:53
Host key for [127.0.0.1]:11111 has changed and you have requested strict checking.
Host key verification failed.
```
* Where to find and confirm the fingerprint 
```
ssh-keygen -f /etc/ssh/ssh_host_ed25519_key.pub -l
256 SHA256:xxxxxxxxxxxxxxxxxxxxxxx root@node-1 (ED25519)
```
* Reconnect 
```shell
ssh -o "UserKnownHostsFile ~/.ssh/abc123" example.org
```
ssh -o KexAlgorithms=+diffie-hellman-group1-sha1 username@123.123.123.123 
