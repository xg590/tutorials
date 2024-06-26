### Basic Concepts in Google Cloud
* One Cloud, multiple projects.
* Each project, many resources (and their API), but only serves one purpose.
* You can create many apps (web app, mobile app, desktop app) to use the resources via API but all shall serves one purpose. These apps shares the same OAuth consent screen, which tells the purpose.
### Google Cloud SDK
* Download SDK from https://cloud.google.com/sdk/docs/install
```
./google-cloud-sdk/install.sh
source ~/.bashrc
gcloud init
# gcloud config set compute/zone NAME
# gcloud config set compute/region NAME
gcloud compute ssh xxx@yyy --tunnel-through-iap
``` 
### Google Cloud Persistent SSH key
* Use [VM metadata](https://cloud.google.com/compute/docs/metadata/overview)
* SSH Key Format: [public_key username]
### Google Cloud Storage: Alternative to AWS S3
* [Signed URL](CloudStorage_SignedURL.ipynb)
  * Generate a signed url so anyone can a download file in bucket 
    * Tips: I use flask to shorten the super-long signed url
    ```python
      import os
      from flask import Flask,redirect
      
      app = Flask(__name__)
      
      @app.route('/xxxx.mp4')
      def xxxx():
          return redirect(
              'https://storage.googleapis.com/my_private_bucket/xxxx.mp4?X-Goog-Algorithm=GOOG4-RSA-SHA25xxxx83d887654d2da5'
              , code=302)
      
      @app.route('/xxxxx.mp4')
      def xxxxx():
          return redirect(
              'https://storage.googleapis.com/my_private_bucket/xxxxx.mp4?X-Goog-Algorithm=GOOG4-RSA-SHA25xxx482ad87bfbc2ae'
              , code=302)
      
      if __name__ == '__main__': 
          app.run(host='0.0.0.0', port=8080)
    ``` 
  * Let anyone upload file using the signed url.
