#!/bin/sh
set -euxo pipefail

get_executable() {
    wget -qO "$1" "$2"
    chmod +x "$1"
}

get_repo() {
    cd "$1" && git pull || git clone "$2" "$1"
}

cp -r ~/gchait/Linux/Home/.* ~/
cp -r ~/gchait/Linux/zypp.conf /etc/zypp/
mkdir -p ~/.zsh

zypper rm -y "*yast*" "*ruby*" 2> /dev/null || true

zypper addrepo https://yum.corretto.aws/corretto.repo 2> /dev/null || true
zypper ref

zypper in -y \
    docker docker-buildx docker-compose vim netcat-openbsd \
    zsh neofetch eza fastfetch figlet yq just ripgrep asciinema \
    java-21-amazon-corretto-devel wget bind-utils gron helm jq

get_executable /usr/local/bin/pfetch \
    "https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch"

get_repo ~/.zsh/pure https://github.com/sindresorhus/pure.git
get_repo ~/.zsh/zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting
get_repo ~/.zsh/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
