Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex
scoop install git

Copy-Item -Path .\Home\* -Destination $HOME -Recurse -Force

scoop bucket add extras
scoop install vscode

reg import "$HOME\scoop\apps\vscode\current\install-context.reg"
reg import "$HOME\scoop\apps\vscode\current\install-associations.reg"

code --install-extension tinkertrain.theme-panda
code --install-extension Catppuccin.catppuccin-vsc-icons
code --install-extension efoerster.texlab
code --install-extension PKief.material-product-icons
code --install-extension eamodio.gitlens
code --install-extension ecmel.vscode-html-css
code --install-extension esbenp.prettier-vscode
code --install-extension hashicorp.terraform
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-pyright.pyright
code --install-extension redhat.vscode-yaml
code --install-extension kokakiwi.vscode-just
code --install-extension samuelcolvin.jinjahtml
code --install-extension tamasfe.even-better-toml

scoop install grep
scoop install vlc
scoop install tectonic
scoop install sumatrapdf

scoop update -a
