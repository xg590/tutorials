import base64
with open('/var/www/html/out.PNG', "rb") as image_file: img_str = 'data:image/png;base64,' + base64.b64encode(image_file.read()).decode() 
a = """<div> <img src="{}" alt="Red dot" /> </div>""".format(img_str) 
a
