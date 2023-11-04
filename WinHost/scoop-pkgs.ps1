scoop bucket add extras

scoop install 7zip
scoop install wezterm
scoop install vscodium

reg import "$HOME\scoop\apps\vscodium\current\install-context.reg"
reg import "$HOME\scoop\apps\vscodium\current\install-associations.reg"

codium --install-extension Catppuccin.catppuccin-vsc-icons
codium --install-extension jeanp413.open-remote-ssh
codium --install-extension khan.two-monokai
codium --install-extension olifink.fedora-gnome-light-dark
codium --install-extension PKief.material-product-icons

scoop install grep
scoop install vagrant
scoop install insomnia
scoop install spotify
scoop install vlc

scoop update -a
