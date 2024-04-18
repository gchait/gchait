#!/bin/bash -xe

export OS_USER=guy

apt_up() {
    apt-get update
    apt-get upgrade -yq
    apt-get autoremove -yq
}

pretty() {
    # nvim plugin support
    curl -fLo "${XDG_DATA_HOME:-${HOME}/.local/share}"/nvim/site/autoload/plug.vim \
        --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # ohmyzsh
    [[ -d ~/.oh-my-zsh ]] || sh -c "$(curl -fsSL \
        https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # p10k
    [[ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]] || git clone \
        --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k

    # Main venv
    python3 -m venv ~/.venv
    . ~/.venv/bin/activate
    pip install isort black flake8 bandit requests pyyaml neovim

    newgrp docker
    docker run hello-world
    docker container prune -f

    [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -f ~/.ssh/id_rsa -q -N ""
    mkdir -p ~/Projects
}

# Base repo packages
apt_up
apt-get install -yq \
    tree sl vim neovim make apt-transport-https \
    python3-venv python3-dev python3-setuptools python3-pip \
    zip gzip tar jq cloud-utils zsh git lolcat \
    ca-certificates gnupg gcc curl dnsutils \
    cmatrix neofetch wget default-mysql-client \
    libmariadb-dev software-properties-common

# Docker start
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
    apt-get remove -yq ${pkg}
done

install -m 0755 -d /etc/apt/keyrings
[[ -f /etc/apt/keyrings/docker.gpg ]] || \
    { curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg; }

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "${VERSION_CODENAME}")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt_up
apt-get install -yq docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin
echo '{"default-address-pools":[{"base":"10.2.0.0/16","size":24}]}' > /etc/docker/daemon.json

systemctl restart docker
usermod -aG docker ${OS_USER}
# Docker end

# MongoDB repo
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu \
    focal/mongodb-org/6.0 multiverse" | \
    tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# GitHub CLI repo
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Amazon Corretto repo
wget -O- https://apt.corretto.aws/corretto.key | apt-key add - 
add-apt-repository 'deb https://apt.corretto.aws stable main'

# External repo packages
apt_up
apt-get install -yq \
    gh mongodb-mongosh \
    java-17-amazon-corretto-jdk

# External binaries without deb/apt
wget -qO /usr/local/bin/yq \
    https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod +x /usr/local/bin/yq

wget -O /usr/local/bin/websocat \
    https://github.com/vi/websocat/releases/latest/download/websocat.x86_64-unknown-linux-musl
chmod +x /usr/local/bin/websocat

[[ -f /usr/local/bin/just ]] || curl --proto '=https' \
    --tlsv1.2 -sSf https://just.systems/install.sh | \
    bash -s -- --to /usr/local/bin/

export -f pretty
su ${OS_USER} -c "bash -xec pretty"
chsh -s $(which zsh) ${OS_USER}

apt_up
echo REMEMBER TO BRING YOUR DOTFILES NOW
