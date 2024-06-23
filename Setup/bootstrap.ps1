scoop bucket add extras

scoop install `
    eza fastfetch vim grep spotify jq yq vscode `
    rufus just windows-terminal draw.io gron vlc `
    ccleaner kubectl helm wget zip ripgrep

reg import "$HOME\scoop\apps\vscode\current\install-context.reg"
reg import "$HOME\scoop\apps\vscode\current\install-associations.reg"

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

Copy-Item -Path "$HOME\gchait\Setup\Home\*" -Destination "$HOME" -Recurse -Force
scoop update -a

Start-Process -Wait -NoNewWindow `
    -FilePath "$HOME\scoop\apps\git\current\usr\bin\bash.exe" `
    -ArgumentList '-l ~/gchait/Setup/bootstrap.sh'
