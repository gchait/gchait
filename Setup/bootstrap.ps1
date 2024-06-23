scoop update -a
scoop bucket add extras *> ${null}

scoop install `
    eza fastfetch vim grep spotify jq yq vscode `
    rufus just windows-terminal draw.io gron vlc `
    ccleaner kubectl helm wget zip ripgrep

reg import "${HOME}\scoop\apps\vscode\current\install-context.reg" *> ${null}
reg import "${HOME}\scoop\apps\vscode\current\install-associations.reg" *> ${null}

code `
    --install-extension catppuccin.catppuccin-vsc-icons `
    --install-extension eamodio.gitlens `
    --install-extension ecmel.vscode-html-css `
    --install-extension esbenp.prettier-vscode `
    --install-extension hashicorp.terraform `
    --install-extension kokakiwi.vscode-just `
    --install-extension ms-azuretools.vscode-docker `
    --install-extension ms-kubernetes-tools.vscode-kubernetes-tools `
    --install-extension ms-pyright.pyright `
    --install-extension pkief.material-product-icons `
    --install-extension redhat.vscode-yaml `
    --install-extension samuelcolvin.jinjahtml `
    --install-extension tamasfe.even-better-toml `
    --install-extension tinkertrain.theme-panda `
    | Select-String -NotMatch -Pattern "already installed" | % { $_.Line }

Copy-Item -Recurse -Force `
    -Path "${HOME}\gchait\Setup\Home\*" `
    -Destination "${HOME}"

Start-Process -Wait -NoNewWindow `
    -FilePath "${HOME}\scoop\apps\git\current\usr\bin\bash.exe" `
    -ArgumentList '-l ~/gchait/Setup/bootstrap.sh'
