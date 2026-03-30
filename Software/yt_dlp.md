yt-dlp --cookies a.txt -f "bestvideo[vcodec^=avc1][ext=mp4][height<=720]+bestaudio[acodec^=mp4a][ext=m4a]/best" --merge-output-format mp4 $1


yt-dlp --cookies a.txt -f "wv+ba/w" --merge-output-format mp4 https://www.youtube.com/watch?v=
 