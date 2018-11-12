#!/bin/bash
### Install an existing conda environment to your jupyter notebooks
### Done by bryan saldivar
### twitter: https://twitter.com/bsaldivaremc2
### Version: 20181112


env_name=${1}
env_label=${2}
if [ -z ${env_name} ]
then
	echo "No environment name specified."
	echo "usage:"
	echo "env_to_notebook.sh your_environment_name your_environment_label"
	echo "your_environment_name is the one that appears in your conda environments list. cond env list"
	echo "your_environment_label is the label that will appear on your jupyter notebook"
	exit
fi
if [ -z ${env_label}]
then
	env_label=${env_name}
	echo "enviornment label will be set ${env_name}"
fi
conda_exists=$(which conda | wc -l)
if [ ${conda_exists} -ne 1 ]
then
	echo "Conda is not installed on your system"
	exit
fi
env_exists=$(conda env list | grep ${env_name} | wc -l )
if [ ${env_exists} -ne 1 ]
then
	echo "your environment is not installed on your system"
	exit
fi

source activate ${env_name}
python -m ipykernel install --user --name ${env_name} --display-name "${env_label}"
source deactivate
still_base=$(echo $PS1 | grep "(base)" | wc -l)
if [ ${still_base} -eq 1 ]
then
	source deactivate
fi
echo "Installation finished. You can see your environment ${env_name} on jupyter with the name ${env_label}"


