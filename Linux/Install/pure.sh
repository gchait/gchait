#!/bin/bash -ex

mkdir -p ~/.zsh

if cd ~/.zsh/pure; then
    git pull
else
    git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
fi
