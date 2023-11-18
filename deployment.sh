git clone https://github.com/bornav/.flake
cd .flake
sudo su
mkdir -p /mnt
mount /dev/disk/by-label/NIXOS /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
nixos-install --flake .#vallium