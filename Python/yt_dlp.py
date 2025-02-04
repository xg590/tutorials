#!/home/ubuntu/software/yt-dlp/bin/python3
import argparse, yt_dlp, os, io, pandas as pd, time
parser = argparse.ArgumentParser(description='Rewrite cookies in Netscape format')
parser.add_argument(
    '-j',
    "--json-filename",
    type=str,
    default="javmost.com.json",
    #default="youtube.com.json",
    help=""
)
parser.add_argument(
    "-m",
    "--m3u8-url",
    type=str,
    help=""
)
parser.add_argument(
    "-o",
    "--output",
    type=str,
    help=""
)
parser.add_argument(
    "-M",
    "--mp4-url",
    type=str,
    help=""
)
#
args     = parser.parse_args()
json_fn  = args.json_filename
m3u8_url = args.m3u8_url
mp4_url  = args.mp4_url
output_fn= args.output

df = pd.read_json(json_fn, dtype={'expirationDate':int})
df['domain'] = df.apply(lambda x: x.domain if x.domain[0]=='.' else '.' + x.domain, axis=1)
df['True'] = 'TRUE'
df['_secure'] = df.apply(lambda x: 'TRUE' if x.secure else 'FALSE', axis=1)
df = df[['domain', 'True', 'path', '_secure', 'expirationDate', 'name', 'value']]
txt  = '''# Netscape HTTP Cookie File
# yt-dlp --cookies youtube.com.txt https://www.youtube.com/watch?v=UjpbQ1OWMPE

''' + df.to_csv(header=False, index=False, sep='\t')
sio = io.StringIO(txt)

ydl_opts = {
    'cookiefile': sio,
    'outtmpl': f'{output_fn}.%(ext)s',
    'ffmpeg_location': os.environ['HOME']+'/software/ffmpeg/bin', 
    #"external_downloader": "ffmpeg",
    "hls_use_mpegts": True,
    "skip_unavailable_fragments":False,
}
with yt_dlp.YoutubeDL(ydl_opts) as ydl:
    for n in range(9):
        try:
            ydl.download([m3u8_url if m3u8_url else mp4_url])
            break
        except yt_dlp.utils.DownloadError as e:
            print('Restart in 1 min')
            time.sleep(60)
