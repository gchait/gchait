#!/bin/bash -xe

configure_user() {
    # p10k
    [[ -d ~/powerlevel10k ]] || git clone \
        https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k --depth 1

    # NvChad
    [[ -d ~/.config/nvim ]] || git clone \
        https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

    # Dotfiles
    cp -r ./Home/.* ~/

    # System-level Python packages
    pip3 install isort black flake8 bandit requests pyyaml neovim

    # Git pre-setup
    [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -f ~/.ssh/id_rsa -q -N ""
    mkdir -p ~/Projects
}

# Base repo packages
dnf update -y
dnf install --setopt=install_weak_deps=false -y \
    tree sl vim neovim make ripgrep dnf-plugins-core util-linux-user \
    python3-setuptools python3-pip cmatrix neofetch wget awscli2 openssl \
    zip gzip tar jq cloud-utils zsh git lolcat python3-wheel eza zsh-autosuggestions \
    ca-certificates gnupg gcc curl dnsutils python3-netaddr npm htop

# Docker
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo '{"default-address-pools":[{"base":"10.2.0.0/16","size":24}]}' > /etc/docker/daemon.json
systemctl restart docker
systemctl enable docker
usermod -aG docker guy

# Amazon Corretto
#rpm --import https://yum.corretto.aws/corretto.key 
#curl -sLo /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
#dnf install -y java-17-amazon-corretto-devel

# MongoDB Shell
#cat <<EOF | tee /etc/yum.repos.d/mongodb-org-7.0.repo
#[mongodb-org-7.0]
#name=MongoDB Repository
#baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
#gpgcheck=1
#enabled=1
#gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
#EOF
#dnf install -y mongodb-mongosh-shared-openssl3

# External binaries
wget -qO /usr/local/bin/yq \
    https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod +x /usr/local/bin/yq

wget -qO /usr/local/bin/websocat \
    https://github.com/vi/websocat/releases/latest/download/websocat.x86_64-unknown-linux-musl
chmod +x /usr/local/bin/websocat

[[ -f /usr/local/bin/just ]] || curl --proto '=https' \
    --tlsv1.2 -sSf https://just.systems/install.sh | \
    bash -s -- --to /usr/local/bin/

# User configuration for guy
export -f configure_user
su guy -c "bash -xec configure_user"
chsh -s $(which zsh) guy
