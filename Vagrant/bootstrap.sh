#!/bin/bash -xe

export OS_USERNAME="vagrant"

configure_user() {
    # NvChad
    [[ -d ~/.config/nvim ]] || git clone \
        https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

    # Dotfiles
    if [ ${OS_USERNAME} = "vagrant" ]; then
        cp -r /vagrant/.config ~/
    else
        cp -r ./Home/.* ~/
    fi

    # System-level Python packages
    pip3 install isort ruff bandit requests pyyaml neovim

    # Git pre-setup
    [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -f ~/.ssh/id_rsa -q -N ""
    mkdir -p ~/Projects
}

# Base repo packages
dnf update -y
dnf install --setopt=install_weak_deps=false -y \
    tree sl vim neovim make ripgrep dnf-plugins-core util-linux-user figlet zsh asciiquarium \
    python3-setuptools python3-pip cmatrix neofetch wget awscli2 openssl asciinema \
    zip gzip tar jq cloud-utils zsh-autosuggestions git lolcat python3-wheel eza poetry \
    ca-certificates gnupg gcc curl dnsutils python3-netaddr npm htop just postgresql

# Docker
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo '{"default-address-pools":[{"base":"10.2.0.0/16","size":24}]}' > /etc/docker/daemon.json
systemctl restart docker
systemctl enable docker
usermod -aG docker vagrant

# Kubectl
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
EOF
dnf install -y kubectl

# MongoDB Shell
cat <<EOF | tee /etc/yum.repos.d/mongodb-org-7.0.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF
dnf install -y mongodb-mongosh-shared-openssl3

# External binaries
wget -qO /usr/local/bin/yq \
    https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod +x /usr/local/bin/yq

if [ ${OS_USERNAME} = "vagrant" ]; then
    # De-bloat
    hostnamectl hostname fedora
    > /etc/motd
    grep "#PrintLastLog yes" /etc/ssh/sshd_config \
        && sed -i 's/#PrintLastLog yes/PrintLastLog no/' /etc/ssh/sshd_config \
        && systemctl restart sshd
    
    # Ensure the filesystem takes all the space
    growpart /dev/sda 2 || true
    xfs_growfs /dev/sda2 || true
fi

# Regular user configuration
export -f configure_user
su ${OS_USERNAME} -c "bash -xec configure_user"
chsh -s $(which fish) ${OS_USERNAME}
