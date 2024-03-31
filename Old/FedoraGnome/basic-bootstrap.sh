#!/bin/bash -xe

set -o nounset
export OS_USERNAME="${1}"

configure_user() {
    # p10k
    [[ -d ~/powerlevel10k ]] || git clone \
        https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k --depth 1
    
    # Dotfiles
    if [ ${OS_USERNAME} = "vagrant" ]; then
        cp -r /vagrant/Home/.* ~/
    else
        cp -Lr ./Home/.* ~/
    fi

    # System-level Python packages
    pip3 install requests pyyaml

    # Rust packages
    cargo install krabby

    # Git pre-setup
    [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -f ~/.ssh/id_rsa -q -N ""
    mkdir -p ~/Projects
}

get_docker() {
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf install -y docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
    echo '{"default-address-pools":[{"base":"10.2.0.0/16","size":24}]}' > \
        /etc/docker/daemon.json
    systemctl restart docker
    systemctl enable docker
    usermod -aG docker ${OS_USERNAME}
}

# Base repo packages
dnf update -y
dnf install --setopt=install_weak_deps=false -y \
    tree vim make dnf-plugins-core util-linux-user \
    figlet zsh asciiquarium cronie rust cargo fzf just \
    python3-setuptools python3-pip kubernetes-client \
    wget awscli2 openssl asciinema lolcat zip gzip \
    tar jq zsh-autosuggestions git eza poetry htop \
    python3-wheel gnupg gcc clang curl postgresql \
    ca-certificates dnsutils cmatrix ranger cmake

# Docker
docker ps &> /dev/null || get_docker

# External executables
wget -qO /usr/local/bin/yq \
    https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod +x /usr/local/bin/yq

wget -qO /usr/local/bin/pfetch \
    https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch
chmod +x /usr/local/bin/pfetch

if [ ${OS_USERNAME} = "vagrant" ]; then
    # De-bloat
    hostnamectl hostname fedora
    > /etc/motd
    grep "#PrintLastLog yes" /etc/ssh/sshd_config \
        && sed -i "s/#PrintLastLog yes/PrintLastLog no/" /etc/ssh/sshd_config \
        && systemctl restart sshd
    
    # Ensure the filesystem takes all the space
    growpart /dev/sda 2 || true
    xfs_growfs /dev/sda2 || true

    # Flex
    dnf install -y neofetch
else
    dnf install -y fastfetch
fi

# Regular user configuration
export -f configure_user
su ${OS_USERNAME} -c "bash -xec configure_user"
chsh -s $(which zsh) ${OS_USERNAME}
