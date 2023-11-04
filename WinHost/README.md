## Windows Host PC Setup

- Install these programs manually, if needed:
  - [Firefox](https://www.mozilla.org/en-US/firefox/new/)
  - [WhatsApp](https://www.whatsapp.com/download)
  - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  - [Lightshot](https://app.prntscr.com/en/index.html)
  - [Google Drive](https://www.google.com/drive/download/)
  - [Discord](https://discord.com/download)
  - [Steam](https://store.steampowered.com/about/)

- Run these lines in PowerShell, one by one:
  ```
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  iwr -useb get.scoop.sh | iex
  
  scoop install git
  git clone https://github.com/gchait/gchait.git
  cd .\gchait
  
  Copy-Item -Path .\WinHost\Home\* -Destination $HOME -Recurse -Force
  .\WinHost\scoop-pkgs.ps1
  ```
  Now close all PowerShell windows.

- Install the fonts from [here](../Fonts).

- Set some wallpapers. There are some nice ones [here](../Wallpapers).

- Continue to launching your Fedora instance [here](../Vagrant/README.md).
