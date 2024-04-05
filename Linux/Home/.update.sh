#!/bin/bash -ex

if command -v zypper; then
    sudo zypper ref
    sudo zypper dup -yl
fi

if command -v dnf; then
    sudo dnf update -y
fi

if command -v flatpak; then
    flatpak update -y
    flatpak uninstall --unused -y
fi

if command -v scoop; then
    scoop update -a
fi
