function FindProxyForURL(url, host) { 
  
  // Hostname matches 
  if (
    dnsDomainIs(host, "whatismyipaddress.com") 
    || shExpMatch(host, "(*.abcdomain.com|abcdomain.com)")
  )
  return "PROXY 1.2.3.4:8080";
  
  // Protocol or URL matches 
  if (
    url.substring(0, 4)=="ftp:"
    || shExpMatch(url, "http://abcdomain.com/folder/*")
  )
  return "DIRECT";
  
  // Connect to internal host. 
  if (
    isPlainHostName(host)
    || shExpMatch(host, "*.local")  
    || isInNet(dnsResolve(host), "10.0.0.0", "255.0.0.0")  
    || isInNet(dnsResolve(host), "172.16.0.0",  "255.240.0.0")  
    || isInNet(dnsResolve(host), "192.168.0.0",  "255.255.0.0") 
    || isInNet(dnsResolve(host), "127.0.0.0", "255.255.255.0") 
  )
  return "DIRECT";
  
  // Connect from internal network. 
  if (
    isInNet(myIpAddress(), "10.10.5.0", "255.255.255.0")
  )
  return "PROXY 1.2.3.4:8080";
  
  // Default rule: All other traffic, use below proxies, in fail-over order. 
  return "DIRECT";
}
