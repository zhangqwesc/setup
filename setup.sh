#!/usr/bin/env bash

set -e

# if run with root, abort
if [[ $EUID -eq 0 ]]; then
    echo "Error: This script must not be run as root"
    exit 1
fi

# check user sudo access
if ! sudo -v; then
    echo "Error: sudo access is required"
    exit 1
fi

if ! command -v apt &> /dev/null; then
    echo "Error: This script requires apt package manager (Ubuntu/Debian)"
    exit 1
fi

echo "Updating system and installing basic packages..."
sudo apt update
sudo apt install -y curl git wget build-essential cmake pkg-config libssl-dev zsh

echo "Changing default shell to zsh..."
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo usermod -s $(which zsh) $(whoami)
else
    echo "zsh is already the default shell"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "oh-my-zsh is already installed"
fi

echo "Installing zsh plugins..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed"
fi

echo "Installing brew packages..."
brew install eza ripgrep dust bat

echo "Configuring aliases..."
if ! grep -q "alias ls=\"eza --icons --time-style iso\"" "$HOME/.zshrc"; then
    echo 'alias ls="eza --icons --time-style iso"' >> "$HOME/.zshrc"
fi
if ! grep -q "alias cat=\"bat -Pp\"" "$HOME/.zshrc"; then
    echo 'alias cat="bat -Pp"' >> "$HOME/.zshrc"
fi
if ! grep -q "alias du=\"dust -d1\"" "$HOME/.zshrc"; then
    echo 'alias du="dust -d1"' >> "$HOME/.zshrc"
fi

echo "Configuring zsh plugins..."
if ! grep -q "plugins=(.*zsh-syntax-highlighting.*)" "$HOME/.zshrc"; then
    sed -i 's/plugins=(/plugins=(zsh-syntax-highlighting /' "$HOME/.zshrc"
fi
if ! grep -q "plugins=(.*zsh-autosuggestions.*)" "$HOME/.zshrc"; then
    sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' "$HOME/.zshrc"
fi

echo "Configuring editor..."
echo 'export EDITOR="vim"' >> "$HOME/.zshrc"

echo "Installation completed! Please restart your shell or run 'source ~/.zshrc'"