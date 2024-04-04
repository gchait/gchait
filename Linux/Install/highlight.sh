#!/bin/bash -ex

mkdir -p ~/.zsh

if cd ~/.zsh/zsh-syntax-highlighting; then
    git pull
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi
