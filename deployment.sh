#!/bin/sh
git clone https://github.com/bornav/.flake
cd .flake
sudo su
mkdir -p /mnt;      mount /dev/disk/by-label/NIXOS /mnt
mkdir -p /mnt/boot; mount /dev/disk/by-label/BOOT /mnt/boot
mkdir -p /mnt/home; mount /dev/disk/by-label/home_partition /mnt/home
nixos-install --flake .#vallium
nixos-enter --root /mnt
echo "root:nixos" | chpasswd
