#!/usr/bin/env bash

# Create a VOD that uses the Twitch live bitrate ladder

if [  $# -lt 1 ]
then
    echo "Need at least 1 argument."
    echo "$0 InputVideo"
    exit 1
fi

ffmpeg -i $1 \
-s:v:0 1920x1080 -r:v:0 60 -threads:v:0 16 -c:v:0 libvpx-vp9 -lag-in-frames 16 -profile:v:0 0 -g:v:0 120 -keyint_min:v:0 120 -sc_threshold:v:0 0 -b:v:0 6400k -minrate:v:0 6400k -maxrate:v:0 6400k \
-c:a:0 aac -ac:a:0 2 -ar:a:0 48000 -b:a:0 128k \
-s:v:1 1280x720  -r:v:1 60 -threads:v:1 16 -c:v:1 libvpx-vp9 -lag-in-frames 16 -profile:v:1 0 -g:v:1 120 -keyint_min:v:1 120 -sc_threshold:v:1 0 -b:v:1 3100k -minrate:v:1 3100k -maxrate:v:1 3100k \
-c:a:1 aac -ac:a:1 2 -ar:a:1 48000 -b:a:1 128k \
-s:v:2 1280x720  -r:v:2 30 -threads:v:2 16 -c:v:2 libvpx-vp9 -lag-in-frames 16 -profile:v:2 0 -g:v:2 60  -keyint_min:v:2 60  -sc_threshold:v:2 0 -b:v:2 2100k -minrate:v:2 2100k -maxrate:v:2 2100k \
-c:a:2 aac -ac:a:2 2 -ar:a:2 48000 -b:a:2 128k \
-s:v:3 852x480   -r:v:3 30 -threads:v:3 16 -c:v:3 libvpx-vp9 -lag-in-frames 16 -profile:v:3 0 -g:v:3 60  -keyint_min:v:3 60  -sc_threshold:v:3 0 -b:v:3 1200k -minrate:v:3 1200k -maxrate:v:3 1200k \
-c:a:3 aac -ac:a:3 2 -ar:a:3 48000 -b:a:3 64k \
-s:v:4 640x360   -r:v:4 30 -threads:v:4 16 -c:v:4 libvpx-vp9 -lag-in-frames 16 -profile:v:4 0 -g:v:4 60  -keyint_min:v:4 60  -sc_threshold:v:4 0 -b:v:4 630k  -minrate:v:4 630k  -maxrate:v:4 630k \
-c:a:4 aac -ac:a:4 2 -ar:a:4 48000 -b:a:4 48k \
-map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a \
-var_stream_map "v:0,a:0,name:1080p60 v:1,a:1,name:720p60 v:2,a:2,name:720p30 v:3,a:3,name:480p30 v:4,a:4,name:360p30" \
-threads 0 -y \
-f hls -hls_time 2 -movflags frag_keyframe \
-hls_segment_type fmp4 -hls_playlist_type vod -master_pl_name master.m3u8 \
-hls_segment_filename %v/%03d.mp4 %v/variant_playlist.m3u8
