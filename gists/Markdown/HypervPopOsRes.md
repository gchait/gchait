1. Enable all services and guest stuff

2. Run this in PowerShell:
   ```
   Set-VMVideo -VMName "popos" -HorizontalResolution 2560 -VerticalResolution 1440 -ResolutionType Single
   ```

3. Generate a modeline:
   ```
   cvt 2560 1440 60
   ```

4. Put the result in `~/.xprofile`:
   ```
   #!/bin/sh
   xrandr --newmode "2560x1440_60.00"  312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync
   xrandr --addmode Virtual-1 "2560x1440_60.00"
   ```

5. Run those 2 commands just in case

6. Run this:
   ```
   sudo kernelstub -a video=hyperv_fb:2560x1440
   ```

7. Restart

8. Choose your new resolution in the settings