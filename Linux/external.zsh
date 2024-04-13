#!/usr/bin/zsh -e

[[ -f ~/.hidden_zshrc ]] && source ~/.hidden_zshrc
mkdir -p ~/.zsh
set -x

apps() {
    sudo wget -qO /usr/local/bin/pfetch \
        "https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch"
    sudo chmod +x /usr/local/bin/pfetch
}

zsh_plugs() {
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
}

code_exts() {
    code --install-extension catppuccin.catppuccin-vsc-icons
    code --install-extension eamodio.gitlens
    code --install-extension ecmel.vscode-html-css
    code --install-extension esbenp.prettier-vscode
    code --install-extension hashicorp.terraform
    code --install-extension kokakiwi.vscode-just
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
    code --install-extension ms-pyright.pyright
    code --install-extension pkief.material-product-icons
    code --install-extension redhat.vscode-yaml
    code --install-extension samuelcolvin.jinjahtml
    code --install-extension tamasfe.even-better-toml
    code --install-extension tinkertrain.theme-panda
}

apps
zsh_plugs
code_exts > /dev/null
