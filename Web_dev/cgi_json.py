#!/usr/bin/python3
import os, sys, json
__len__ = int(os.environ["CONTENT_LENGTH"])
req_body = sys.stdin.read(__len__)
js = json.loads(req_body)

sys.path.append('/home/xxx/xxx/lib/python3.8/site-packages/')  
import asyncio, kasa
bulb = kasa.SmartBulb("192.168.x.x")

asyncio.run(bulb.update())
if bulb.is_on and not js['status']:
  asyncio.run(bulb.turn_off())
elif not bulb.is_on and js['status']:
  asyncio.run(bulb.turn_on())
else:
  print(f"""Content-type:text/html\n\n<html> Wrong intention </html>""") 
  sys.exit()
  
asyncio.run(bulb.update())
if bulb.is_on:
  foo="Light turned ON"
else:
  foo="Light turned OFF"
print(f"""Content-type:text/html\n
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
