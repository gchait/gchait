if [ $(grep "^ID=" /etc/os-release | cut -d"=" -f2 | tr -d '"') = "almalinux" ]; then echo yes; fi
