#!/bin/sh -ex

[[ -f ~/.hidden_zshrc ]] && source ~/.hidden_zshrc

zypper in -y cups system-config-printer opi fetchmsttfonts code gdm
opi codecs

# flatpak install com.spotify.Client io.github.mimbrero.WhatsAppDesktop
# zypper in -y rclone steam-devices
# flatpak install com.github.tchx84.Flatseal com.valvesoftware.Steam

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

set +x
echo
echo "To change display manager:"
echo "update-alternatives --config default-displaymanager"
