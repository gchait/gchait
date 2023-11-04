## Windows Host PC Setup


#### Install these programs manually, if needed
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [WhatsApp](https://www.whatsapp.com/download)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Lightshot](https://app.prntscr.com/en/index.html)

- [Google Drive](https://www.google.com/drive/download/)
- [Discord](https://discord.com/download)
- [Steam](https://store.steampowered.com/about/)


#### Run these lines in PowerShell
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex

scoop install git
git clone https://github.com/gchait/gchait.git
cd .\gchait

Copy-Item -Path .\WinHost\Home\* -Destination $HOME -Recurse -Force
.\WinHost\scoop-pkgs.ps1

codium --install-extension jeanp413.open-remote-ssh
```
Now close all PowerShell windows.


#### Stuff to do next
- Think which font you want in VSCodium and which one in WezTerm.  
  Available nerd fonts names are in `font-names.txt` in this folder.
- Think about themes in those as well.
- Set some wallpaper(s). There are some great ones here in `Wallpapers`.
- Continue to launching your Fedora instance [here](../Vagrant/README.md).
