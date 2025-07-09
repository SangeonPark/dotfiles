#!/bin/bash

# 1) Setup linux dependencies
su -c 'apt-get update && apt-get install -y sudo'
sudo apt-get install -y less nano htop ncdu nvtop lsof rsync btop jq

# 2) Setup virtual environment
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv python install 3.11
uv venv
source .venv/bin/activate
uv pip install ipykernel simple-gpu-scheduler # very useful on runpod with multi-GPUs https://pypi.org/project/simple-gpu-scheduler/
python -m ipykernel install --user --name=venv # so it shows up in jupyter notebooks within vscode

# 3) Setup dotfiles and ZSH
git clone https://github.com/SangeonPark/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --zsh --tmux
./install


echo "changing default shell to zsh"
chsh -s $(which zsh)

zsh
cd ..

# 4) Setup github
echo ./scripts/setup_github.sh "saepark35@gmail.com" "Sangeon Park"
