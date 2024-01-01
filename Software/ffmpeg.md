Note that this method will drop frames to achieve the desired speed. You can avoid dropped frames by specifying a higher output frame rate than the input. For example, to go from an input of 4 FPS to one that is sped up to 4x that (16 FPS):

ffmpeg -i input.mkv -r 16 -filter:v "setpts=0.25*PTS" output.mkv