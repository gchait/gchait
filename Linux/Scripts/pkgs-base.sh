zypper rm -y "*yast*" "*ruby*"

zypper in -y asciinema docker docker-buildx docker-compose \
    eza fastfetch figlet yq helm jq just kubernetes-client \
    neofetch ripgrep tree vim wget zsh

wget -qO /usr/local/bin/pfetch \
    "https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch"
chmod +x /usr/local/bin/pfetch

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
