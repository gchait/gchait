```shell
pactl list sinks | grep node.nick

mkdir -p ~/.config/wireplumber/main.lua.d
vim ~/.config/wireplumber/main.lua.d/51-alsa-custom.lua
```
```
rule = {
  matches = {
    {
      { "node.nick", "matches", "VG27A" },
    },
  },
  apply_properties = {
    ["session.suspend-timeout-seconds"] = 0
  },
}

table.insert(alsa_monitor.rules, rule)
```
```shell
systemctl --user restart wireplumber

watch -cd -n .1 pactl list short sinks
```

Doesn't work?
```shell
vim /usr/share/wireplumber/scripts/node/suspend-node.lua
```
Change
```
tonumber(node.properties["session.suspend-timeout-seconds"]) or 5
```
to
```
tonumber(node.properties["session.suspend-timeout-seconds"]) or 0
```
and reboot. `rg session.suspend-timeout-seconds /usr/share/wireplumber` to find the right place if it's not there.
