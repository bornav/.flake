mkdir -p /mnt
mount /dev/disk/by-label/NIXOS /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
git clone https://github.com/bornav/.flake
# cd .flake
sudo nixos-install --flake ~/.flake#vallium