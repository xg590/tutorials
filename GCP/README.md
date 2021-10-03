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
### Google Cloud Storage: Alternative to AWS S3
* [Signed URL](CloudStorage_SignedURL.ipynb)
  * Generate a signed url so anyone can a download file in bucket
  * Let anyone upload file using the signed url.
