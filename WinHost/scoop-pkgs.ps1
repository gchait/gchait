scoop bucket add extras
scoop bucket add nerd-fonts

scoop install 7zip
scoop install wezterm
scoop install vscodium
reg import "$HOME\scoop\apps\vscodium\current\install-context.reg"
reg import "$HOME\scoop\apps\vscodium\current\install-associations.reg"

scoop install grep
scoop install vagrant
scoop install insomnia
scoop install spotify
scoop install vlc

scoop install Hack-NF
scoop install FiraMono-NF
scoop install DejaVuSansMono-NF
scoop install Meslo-NF
scoop install VictorMono-NF
scoop install Noto-NF

scoop update -a
