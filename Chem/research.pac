function FindProxyForURL(url, host) {  
  // Which Domain to proxy
  if ( 
    dnsDomainIs(host, "sciencedirect.com") 
    || dnsDomainIs(host, "elsevier.com") 
    || dnsDomainIs(host, "acs.org") 
    || dnsDomainIs(host, "rsc.org") 
    || dnsDomainIs(host, "iucr.org") 
    || dnsDomainIs(host, "nature.com") 
    || dnsDomainIs(host, "springer.com") 
    || dnsDomainIs(host, "wiley.com") 
    || dnsDomainIs(host, "portlandpress.com") 
  )
  return "SOCKS5 127.0.0.1:8080";  
  
  // Default rule: All other traffic, use below proxies, in fail-over order. 
  return "DIRECT"; 
}
