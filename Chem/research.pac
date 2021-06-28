function FindProxyForURL(url, host) {  
  // Which Domain to proxy
  if ( 
    dnsDomainIs(host, "sciencedirect.com") 
    || dnsDomainIs(host, "elsevier.com") 
    || dnsDomainIs(host, "pubs.acs.org") 
    || dnsDomainIs(host, "nature.com") 
  )
  return "SOCKS5 127.0.0.1:8080";  
  
  // Default rule: All other traffic, use below proxies, in fail-over order. 
  return "DIRECT"; 
}
