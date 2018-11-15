#!/bin/bash
video=${1}
audio=${2}


tmp_video="tmp.mp4"
output="proc_"${video}
MP4Box ${video} -single 1 -out ${tmp_video}
MP4Box ${tmp_video} -add ${audio}
mv ${tmp_video} ${output}
echo "Finished on "${output}
