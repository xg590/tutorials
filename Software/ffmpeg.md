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
* Docker
  ```
  alias ffmpeg='docker run --rm -v ~/software/ffmpeg_linuxarm64_gpl/bin/ffmpeg:/workspace/ffmpeg -v $PWD:/workspace -w /workspace ubuntu:22.04 /workspace/ffmpeg'
  ffmpeg -err_detect ingnore_err -i 996_backup.mp4 -c copy  996_backup_fixed.mp4
  ```
* Cut
  ```
  ffmpeg -i filename -ss start_timestamp -t duratio        -codec copy
  ffmpeg -i filename -ss start_timestamp -tt end_timestamp -codec copy
  ```
* transcoding
  ```
  ffmpeg -i filename -c:v libx264 -c:a aac output.mp4
  ```
### Troubleshooting
  * PNG Video
```
Input #0, png_pipe, from 'XXX.mp4':
  Duration: N/A, bitrate: N/A
  Stream #0:0: Video: png, rgba(pc, gbr/bt709/iec61966-2-1), 1x1 [SAR 4724:4724 DAR 1:1], 25 fps, 25 tbr, 25 tbn

for i in `ls *.mp4` ; do dd if=$i of=fixed/$i ibs=8 skip=1 obs=4M status=progress ; done
```
#### Convert MPEG-TS to MP4
```
for i in `ls *.mp4` ; do ffmpeg -i $i -c copy -bsf:a aac_adtstoasc fixed/$i; done
```