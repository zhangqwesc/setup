#!/usr/bin/env bash

sudo apt update
sudo apt install -y curl git wget build-essential cmake pkg-config libssl-dev zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
pwd=$(pwd)
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions
cd $pwd
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install eza ripgrep dust bat

echo 'alias ls="eza --icons --time-style iso"' >> ~/.zshrc
echo 'alias cat="bat -Pp"' >> ~/.zshrc
echo 'alias du="dust -d1"' >> ~/.zshrc