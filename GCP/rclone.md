### Setup
* All config params is in ~/.config/rclone/rclone.cfg
* One example is:
```
[gdrive]
type = drive
client_id = 11111111-xxxxxxxxxx.apps.googleusercontent.com
client_secret = XXXXXXXXXXXXXXXXXX
scope = drive.readonly
root_folder_id = 1111XXXXXX-XXXXXXXXXXXXXX
token = {"access_token":"xx11.xxxx","token_type":"Bearer","refresh_token":"1xxxx","expiry":"2021-10-11T18:11:11.11-11:00"}
```
### Create rclone.cfg
* Visit [making-your-own-client-id](https://rclone.org/drive/#making-your-own-client-id) for how to create your own Google Application Client Id / secret
* Run rclone config
``` 
No remotes found - make a new one
name> gdrive
Storage> drive 
client_id> 11111111-xxxxxxxxxx.apps.googleusercontent.com
client_secret> XXXXXXXXXXXXXXXXXX
scope> drive.readonly
root_folder_id> 1111XXXXXX-XXXXXXXXXXXXXX
service_account_file> leave it blank and just press enter
```
* You will be instructed to visit a link in web browser and get verification code
```
If your browser doesn't open automatically go to the following link: https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=xxxxxxxxxxxxxx
Log in and authorize rclone for access
Enter verification code> xxxxxxxxxxxxx
```
### rclone 
* List config file if there is a default cfg file
```
rclone config xxx.cfg
```
* Inspect cfg and string in sequre bracket is remote directory
```
rclone --config rclone.cfg config show
``` 
* List remote files
```
rclone --config xxx.cfg lsd gdrive:
```

* Use cfg to sync Google Drive with GCP machine
```
rclone --config xxx.cfg sync gdrive:/mydir /local_dir/
```
