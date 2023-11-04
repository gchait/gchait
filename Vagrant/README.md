## Fedora on (Windows, VirtualBox, Vagrant) Setup
**My personal development setup.**

#### Q&A
- Q: Why PC and not Mac?  
  A: I don't like the Ctrl, Super and Alt alternative keys in Mac.  
  Yes, they can be re-mapped, but the experience is not consistent across programs.  
  Also, for my container-centric needs, I require my "backend" machine to be Linux anyway.  
  Projects like `colima` are not perfect either.

- Q: Why Windows and not Linux?  
  A: Gaming on Linux is not nearly as common and supported as I'd like it to be.  
  Proton, Wine and Lutris are cool, but I like multiplayer games which often don't support Linux at all, or have Windows-based anti-cheats.  
  Also, not a lot of employers (at least not my current one) support a Linux laptop.  
  I wish I could be 100% and bare-metal Linux, but reality happens.

- Q: Why not dual-boot?  
  A: In the work laptop, it probably isn't practical or even allowed.  
  And in my personal PC, I wouldn't want to switch back and forth, restart all the time or handle and maintain multiple mutable OSes and DEs.  
  At first it sounded reasonable, but I value my time (and I'm lazy) a little too much for that.

- Q: Why not Docker Desktop?  
  A: Not my cup of tea, corporate, GUI and all that. I much prefer a pure-Linux, programmatic-based approach.  
  Also, for programming, I want to interact only with Linux anyway, so the best VM setup wins.

- Q: Why not WSL?  
  A: I used it a lot, but unfortunately it still doesn't support a `mirrored` or a proper networking mode
  that handles split-tunnel VPNs correctly, which I currently require. Yes, projects like `wsl-vpnkit` do work, but I don't like the idea of having multiple VMs.  
  Also, using WSL forces me into some kind of Microsoft ecosystem.  
  It is a VM, but also different enough from traditional ones to matter. WSL is using an old kernel too.

- Q: Why Fedora?  
  A: I used Debian, Arch and their derivatives a lot. I enjoyed PopOS and Manjaro.  
  Even so, for nearly my entire professional career, my experience has been with RPM-based systems, including CentOS, RHEL and AmazonLinux.  
  It's where I am most comfortable, so Fedora is the natural choice, being cutting-edge and stable enough to be a daily driver.
