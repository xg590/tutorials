function FindProxyForURL(url, host) {  
  // Which Domain to proxy
  // Tested on Windows 10 Edge and Ubuntu Firefox
  if ( 
    dnsDomainIs(host, "sciencedirect.com") 
    || dnsDomainIs(host, "science.org") 
    || dnsDomainIs(host, "elsevier.com") 
    || dnsDomainIs(host, "acs.org") 
    || dnsDomainIs(host, "rsc.org") 
    || dnsDomainIs(host, "cell.com") 
    || dnsDomainIs(host, "iucr.org") 
    || dnsDomainIs(host, "nature.com") 
    || dnsDomainIs(host, "springer.com") 
    || dnsDomainIs(host, "wiley.com") 
    || dnsDomainIs(host, "portlandpress.com") 
    || dnsDomainIs(host, "tandfonline.com")
    || dnsDomainIs(host, "whatismyip.com")
  )
  //return "SOCKS5 127.0.0.1:1080";   
  return "SOCKS 127.0.0.1:1080";   
  
  // Default rule: All other traffic, use below proxies, in fail-over order. 
  return "DIRECT"; 
}
