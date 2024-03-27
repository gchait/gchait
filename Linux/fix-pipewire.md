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
