* Which format, resolution, frame speed does the USB camera support? Use V4L2 (Video for Linux Two). 
  ```shell
  pi@raspberrypi:~ $ v4l2-ctl -d /dev/video0 --list-formats-ext
  ioctl: VIDIOC_ENUM_FMT
  	Type: Video Capture
  	[0]: 'MJPG' (Motion-JPEG, compressed)
  		Size: Discrete 640x480
  			Interval: Discrete 0.033s (30.000 fps) 
  		Size: Discrete 2592x1944
  			Interval: Discrete 0.067s (15.000 fps)
  	[1]: 'YUYV' (YUYV 4:2:2)
  		Size: Discrete 640x480
  			Interval: Discrete 0.033s (30.000 fps) 
  		Size: Discrete 1920x1080
  			Interval: Discrete 0.200s (5.000 fps)
  			Interval: Discrete 0.333s (3.000 fps)
  ```