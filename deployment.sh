#!/bin/sh
git clone https://github.com/bornav/.flake
cd .flake
sudo mkdir -p /mnt
sudo mount /dev/disk/by-label/NIXOS /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/BOOT /mnt/boot
sudo nixos-install --flake .#vallium