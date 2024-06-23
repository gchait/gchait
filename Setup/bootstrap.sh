set -euxo pipefail

get_repo() {
    cd "${1}" && git pull || git clone --depth=1 "${2}" "${1}"
}

mkdir -p "${HOME}/.zsh"
sed -i "/git-completion.bash/d" /etc/profile.d/git-prompt.sh

get_repo "${HOME}/.zsh/complete" https://github.com/zsh-users/zsh-completions.git
get_repo "${HOME}/.zsh/highlight" https://github.com/zsh-users/zsh-syntax-highlighting.git
get_repo "${HOME}/.zsh/suggest" https://github.com/zsh-users/zsh-autosuggestions.git
get_repo "${HOME}/.zsh/p10k" https://github.com/romkatv/powerlevel10k.git
