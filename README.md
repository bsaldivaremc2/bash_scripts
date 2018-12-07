# Bash scripts to help
## Install a conda environment into jupyter
If you want to set your existing conda environment available into your jupyter notebooks use the sintaxis:
```bash
source activate ${env_name}
python -m ipykernel install --user --name ${env_name} --display-name "${env_label}"
```

Or you can use the script [**env_to_notebook.sh**](https://github.com/bsaldivaremc2/bash_scripts/blob/master/env_to_notebook.sh) present on this repository to help you.

## Add audio to a video:
If you have a video file and wish to remove the audio from it and then add sound from a different file use:  
[**mp4_mix_video_audio.sh**](https://github.com/bsaldivaremc2/bash_scripts/blob/master/mp4_mix_video_audio.sh).  
Usage:  
```bash
./mp4_mix_video_audio.sh your_video_file.mp4 your_audio_file.mp4
```

#Find some text in a file and replace with the content of other file:
See the  bash script for more information: 
[**insert_in_line.sh**](https://github.com/bsaldivaremc2/bash_scripts/blob/master/insert_in_line.sh).  