set -euxo pipefail

get_repo() {
    cd "$1" && git pull || git clone --depth=1 "$2" "$1"
}

wget -qO /usr/bin/pfetch \
    "https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch"

mkdir -p ~/.zsh
get_repo ~/.zsh/highlight https://github.com/zsh-users/zsh-syntax-highlighting
get_repo ~/.zsh/suggest https://github.com/zsh-users/zsh-autosuggestions
get_repo ~/.zsh/p10k https://github.com/romkatv/powerlevel10k.git

sed -i "/git-completion.bash/d" /etc/profile.d/git-prompt.sh
