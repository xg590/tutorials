from flask import Flask, send_file
from zipfile import ZipFile  
import io  

app = Flask(__name__)  

@app.route('/', methods=['GET'])
def download():    
    blob_buffer = io.BytesIO() 
    with ZipFile(blob_buffer, 'w') as myzip: 
        for _ in ['1111', '2222','3333']:
            with myzip.open(f'{_}.txt','w') as f :
                f.write(_.encode())
    blob_buffer.seek(0)
    return send_file(blob_buffer, mimetype=f'application/zip', as_attachment=True, download_name=f"Glory2UA.zip")

app.run()  
