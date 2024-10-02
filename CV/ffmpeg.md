* Capture 150 images
  ```
  ffmpeg -y -input_format mjpeg -video_size 2592x1944 -i /dev/video0 -frames 150 test%3d.jpeg 
  ``` 
* Capture a video 
  ```
  ffmpeg -y -input_format mjpeg    -video_size 640x480 -i /dev/video0 -vcodec copy -t 3 3s.mjpg
  ffmpeg -y -input_format rawvideo -video_size 640x480 -i /dev/video0 -vcodec copy -t 3 3s.yuv 
  ``` 
* Convert the video
  ```
  ffmpeg -f rawvideo -video_size 1280x720 -pixel_format yuyv422 -i 10s.yuv -c:v libx264 output.mp4
  ``` 
 