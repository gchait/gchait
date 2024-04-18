[[ -f ~/.hidden_zshrc ]] && source ~/.hidden_zshrc

zypper in steam-devices system-config-printer opi \
    fetchmsttfonts cups avahi-utils code rclone gdm

flatpak install com.github.tchx84.Flatseal com.spotify.Client \
    com.valvesoftware.Steam io.github.mimbrero.WhatsAppDesktop

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

code_exts > /dev/null
