#!/bin/bash -ex

sudo wget -qO /usr/local/bin/pfetch "https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch"
sudo chmod +x /usr/local/bin/pfetch

mkdir -p ~/.zsh

if cd ~/.zsh/pure; then
    git pull
else
    git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
fi

if cd ~/.zsh/zsh-syntax-highlighting; then
    git pull
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi

if cd ~/.zsh/zsh-autosuggestions; then
    git pull
else
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
