```shell
sudo mkdir -p /etc/wireplumber/main.lua.d
sudo cp -a /usr/share/wireplumber/main.lua.d/50-alsa-config.lua /etc/wireplumber/main.lua.d/50-alsa-config.lua
sudo vim /etc/wireplumber/main.lua.d/50-alsa-config.lua
```
```shell
["session.suspend-timeout-seconds"] = 0, -- default is 5
```
```shell
systemctl --user restart wireplumber
```
