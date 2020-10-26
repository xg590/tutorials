### Capture Screen
Save 10 sec screenshot 
```
ffmpeg -f x11grab -i :0.0 -video_size 1024x768 -framerate 25 -t 10 output.mp4
```
Broadcast screenshot via tcp 
```
ffmpeg -f x11grab -i :0.0 -framerate 25 -video_size 1024x768 -listen 1 -f mpegts tcp://0.0.0.0:12345
```
