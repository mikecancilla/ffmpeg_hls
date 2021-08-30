#!/usr/bin/env bash

# Create a VOD that uses the Twitch live bitrate ladder

if [  $# -lt 1 ]
then
    echo "Need at least 1 argument."
    echo "$0 InputVideo"
    exit 1
fi

# CBR
ffmpeg -i $1 \
-s:v:0 1920x1080 -aspect:v:0 16:9 -r:v:0 60 -c:v:0 libx264 -x264-params:v:0 open-gop=0:nal-hrd=cbr -profile:v:0 main -g:v:0 120 -keyint_min:v:0 120 -sc_threshold:v:0 0 -b:v:0 6000k -minrate:v:0 6000k -maxrate:v:0 6000k -bufsize:v:0 9000k \
-c:a:0 aac -ac:a:0 2 -ar:a:0 48000 -b:a:0 128k \
-s:v:1 1280x720  -aspect:v:1 16:9 -r:v:1 60 -c:v:1 libx264 -x264-params:v:1 open-gop=0:nal-hrd=cbr -profile:v:1 main -g:v:1 120 -keyint_min:v:1 120 -sc_threshold:v:1 0 -b:v:1 3100k -minrate:v:0 3100k -maxrate:v:1 3100k -bufsize:v:1 4650k \
-c:a:1 aac -ac:a:1 2 -ar:a:1 48000 -b:a:1 128k \
-s:v:2 1280x720  -aspect:v:2 16:9 -r:v:2 30 -c:v:2 libx264 -x264-params:v:2 open-gop=0:nal-hrd=cbr -profile:v:2 main -g:v:2 60 -keyint_min:v:2 60 -sc_threshold:v:2 0 -b:v:2 2100k -minrate:v:0 2100k -maxrate:v:2 2100k -bufsize:v:2 3150k \
-c:a:2 aac -ac:a:2 2 -ar:a:2 48000 -b:a:2 128k \
-s:v:3 852x480   -aspect:v:3 16:9 -r:v:3 30 -c:v:3 libx264 -x264-params:v:3 open-gop=0:nal-hrd=cbr -profile:v:3 main -g:v:3 60 -keyint_min:v:3 60 -sc_threshold:v:3 0 -b:v:3 1200k -minrate:v:0 1200k -maxrate:v:3 1200k -bufsize:v:3 1800k \
-c:a:3 aac -ac:a:3 2 -ar:a:3 48000 -b:a:3 64k \
-s:v:4 640x360   -aspect:v:4 16:9 -r:v:4 30 -c:v:4 libx264 -x264-params:v:4 open-gop=0:nal-hrd=cbr -profile:v:4 main -g:v:4 60 -keyint_min:v:4 60 -sc_threshold:v:4 0 -b:v:4 550k  -minrate:v:0 550k -maxrate:v:4 550k  -bufsize:v:4 825k \
-c:a:4 aac -ac:a:4 2 -ar:a:4 48000 -b:a:4 48k \
-map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a \
-var_stream_map "v:0,a:0,name:1080p60 v:1,a:1,name:720p60 v:2,a:2,name:720p30 v:3,a:3,name:480p30 v:4,a:4,name:360p30" \
-threads 0 -y \
-f hls -hls_time 2 \
-hls_segment_type mpegts -hls_playlist_type vod -master_pl_name master.m3u8 \
-hls_segment_filename %v/%03d.ts %v/variant_playlist.m3u8

# original
#ffmpeg -i $1 \
#-s:v:0 1920x1080 -aspect:v:0 16:9 -r:v:0 60 -c:v:0 libx264 -x264-params:v:0 open-gop=0 -profile:v:0 main -crf:v:0 20 -g:v:0 120 -keyint_min:v:0 120 -sc_threshold:v:0 0 -b:v:0 6000k -maxrate:v:0 6420k -bufsize:v:0 9000k \
#-c:a:0 aac -ac:a:0 2 -ar:a:0 48000 -b:a:0 128k \
#-s:v:1 1280x720  -aspect:v:1 16:9 -r:v:1 60 -c:v:1 libx264 -x264-params:v:1 open-gop=0 -profile:v:1 main -crf:v:1 20 -g:v:1 120 -keyint_min:v:1 120 -sc_threshold:v:1 0 -b:v:1 3100k -maxrate:v:1 3317k -bufsize:v:1 4650k \
#-c:a:1 aac -ac:a:1 2 -ar:a:1 48000 -b:a:1 128k \
#-s:v:2 1280x720  -aspect:v:2 16:9 -r:v:2 30 -c:v:2 libx264 -x264-params:v:2 open-gop=0 -profile:v:2 main -crf:v:2 20 -g:v:2 60 -keyint_min:v:2 60 -sc_threshold:v:2 0 -b:v:2 2100k -maxrate:v:2 2247k -bufsize:v:2 3150k \
#-c:a:2 aac -ac:a:2 2 -ar:a:2 48000 -b:a:2 128k \
#-s:v:3 852x480   -aspect:v:3 16:9 -r:v:3 30 -c:v:3 libx264 -x264-params:v:3 open-gop=0 -profile:v:3 main -crf:v:3 20 -g:v:3 60 -keyint_min:v:3 60 -sc_threshold:v:3 0 -b:v:3 1200k -maxrate:v:3 1284k -bufsize:v:3 1800k \
#-c:a:3 aac -ac:a:3 2 -ar:a:3 48000 -b:a:3 64k \
#-s:v:4 640x360   -aspect:v:4 16:9 -r:v:4 30 -c:v:4 libx264 -x264-params:v:4 open-gop=0 -profile:v:4 main -crf:v:4 20 -g:v:4 60 -keyint_min:v:4 60 -sc_threshold:v:4 0 -b:v:4 550k  -maxrate:v:4 589k  -bufsize:v:4 825k \
#-c:a:4 aac -ac:a:4 2 -ar:a:4 48000 -b:a:4 48k \
#-map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a \
#-var_stream_map "v:0,a:0,name:1080p60 v:1,a:1,name:720p60 v:2,a:2,name:720p30 v:3,a:3,name:480p30 v:4,a:4,name:360p30" \
#-threads 0 -y \
#-f hls -hls_time 2 \
#-hls_segment_type mpegts -hls_playlist_type vod -master_pl_name master.m3u8 \
#-hls_segment_filename %v/%03d.ts %v/variant_playlist.m3u8
