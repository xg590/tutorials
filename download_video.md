### Download MPEG-TS streaming 
* I prefer the [static build](https://johnvansickle.com/ffmpeg/) like [amd64-static](https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz) 
```python
import os, requests, re, threading, subprocess
def downloader(video_name, url): 
    os.makedirs(video_name, exist_ok=True) 
    to_be_replaced = re.compile('(?<=m3u8.).*?(?=.ts)')
    url = re.sub(to_be_replaced, '{}', url)
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36',}
    for i in range(9999):
        if os.path.isfile(f'{video_name}/{i}.ts'): continue  
        r = requests.get(url.format(i), headers=headers)
        if r.status_code != 200:
            print(f'Stop at clip "{i}" and return code "{r.status_code}" ~')
            break
        else: open(f'{video_name}/{i}.ts', 'wb').write(r.content)
    
    with open(f'{video_name}.list', 'w') as fw:
        for j in range(i):
            print(f"file '{video_name}/{j}.ts'", file=fw)
            
def compressor(video_name):   # combind and convert ts(es) to mp4
    ffmpeg = '/path/to/ffmpeg-4.3.1-amd64-static/ffmpeg'
    cmd = f"{ffmpeg} -f concat -safe 0 -i {video_name}.list -s hd480 -c:v libx264 -crf 23 -c:a aac -strict -2 {video_name}.mp4"
    _ = subprocess.run(cmd, shell=True, cwd=os.getcwd()) 

video_name = 'interesting'
url = "https://some.video.site/interesting.m3u8.22.ts"
threading.Thread(target=downloader, args=(video_name, url)).start()  # Run this and you will be notified when the downloading is done.
threading.Thread(target=compressor, args=(video_name,)).start()      # You must run this after downloader
```
### FFmpeg Vocabulary  
* time_base: interval between timestamps (time_base = second timestamp - first timestamp). It is a timing unit.
* duration_ts: duration timestamp. duration = duration_ts * time_base
