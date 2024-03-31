- PowerShell:
```
Set-VMVideo -VMName "rocky" -HorizontalResolution 2560 -VerticalResolution 1440 -ResolutionType Single
```

- Add to `GRUB_CMDLINE_LINUX`:
```
video=Virtual-1:2560x1440@60
```

- Update grub

- Reboot
