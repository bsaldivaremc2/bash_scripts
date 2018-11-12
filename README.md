# Bash scripts to help
## Install a conda environment into jupyter
If you want to set your existing conda environment available into your jupyter notebooks use the sintaxis:
```bash
source activate ${env_name}
python -m ipykernel install --user --name ${env_name} --display-name "${env_label}"
```

Or you can use the script [**env_to_notebook.sh**](https://github.com/bsaldivaremc2/bash_scripts/blob/master/env_to_notebook.sh) present on this repository to help you.

