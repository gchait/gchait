#!/bin/bash -ex

mkdir -p ~/.zsh

if cd ~/.zsh/zsh-autosuggestions; then
    git pull
else
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
