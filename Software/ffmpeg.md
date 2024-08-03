Note that this method will drop frames to achieve the desired speed. You can avoid dropped frames by specifying a higher output frame rate than the input. For example, to go from an input of 4 FPS to one that is sped up to 4x that (16 FPS):
```
ffmpeg -i input.mkv -r 16 -filter:v "setpts=0.25*PTS" output.mkv
```
* Convert MOV to MP4 in high quality
```
ffmpeg -i INPUT.MOV -qscale 0 output.mp4
```
* Reboxing webm
  ```
  ffmpeg -ss 00:02:07 -to 00:04:33 -i a.webm -c copy a_clip.mp4
  ffmpeg -i a.webm -c copy a.mp4
  ```