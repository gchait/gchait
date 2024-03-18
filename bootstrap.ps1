Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
powershell "Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression"

scoop install git
scoop bucket add extras
scoop install vscode

reg import "$HOME\scoop\apps\vscode\current\install-context.reg"
reg import "$HOME\scoop\apps\vscode\current\install-associations.reg"

code --install-extension catppuccin.catppuccin-vsc-icons
code --install-extension dart-code.dart-code
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

scoop install `
    eza fastfetch vim grep jq vlc zip spotify `
    starship windows-terminal yq draw.io brave `
    ccleaner rufus ripgrep gron wget

Copy-Item -Path "$HOME\gchait\Home\*" -Destination "$HOME" -Recurse -Force
scoop update -a
