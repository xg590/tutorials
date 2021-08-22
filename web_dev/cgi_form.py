#!/usr/bin/python3
import sys
sys.path.append('/home/xxx/xxx/lib/python3.8/site-packages/')
import asyncio, kasa
bulb = kasa.SmartBulb("192.168.x.xxx")
asyncio.run(bulb.update())
if bulb.is_on:
  asyncio.run(bulb.turn_off())
else:
  asyncio.run(bulb.turn_on())
asyncio.run(bulb.update())
if bulb.is_on:
  foo="Light turned ON"
else:
  foo="Light turned OFF"
print(f"""Content-type:text/html

<html>
    <head>
        <meta charset=\"utf-8\"> 
        <title>Bulb</title>  
        <link rel="shortcut icon" type="image/png" href="/archive/bulb-icon.png"/>
        <link rel="apple-touch-icon" type="image/png" href="/archive/bulb-icon.png"/>
    </head> 
    <body> 
      <p style="font-size:4em">{foo}</p>
    </body> 
</html>""")
