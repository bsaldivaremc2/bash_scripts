#!/bin/bash
video=${1}
audio=${2}

function file_exists()
{
  if [ ! -f ${1} ]
  then
    echo "No such file: "${1}". Terminating script."
    exit
  fi
}


if [ -z ${video} ] | [ -z ${audio} ]
then
  echo "No video or audio file specified."
  echo "two arguments required, video_file audio_file"
  exit
fi

file_exists ${video}
file_exists ${audio}

tmp_video=".tmp.mp4"
output="proc_"${video}
MP4Box ${video} -single 1 -out ${tmp_video}
MP4Box ${tmp_video} -add ${audio}
mv ${tmp_video} ${output}
echo "Finished on "${output}
