## rclone 
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
