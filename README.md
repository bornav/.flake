### Bootstrap commands

    sudo su
    nix-env -iA nixos.git
    git clone <url> /mnt/<path>
    nixos-install --flake .#<host>  || in my case username
    reboot

## after first login 
    sudo rm -r /etc/nixos/configuration.nix
    / move build to desired location

## rebuild config
    sudo nixos-rebuild switch --flake ~/.flake/#bocmo

## update flage dependancies
    nix flake update
sudo nixos-rebuild switch --flake ~/.flake/#vallium
efibootmgr -c -d /dev/nvme0n1p4 -p 1 -L NixOS-boot -l '\EFI\NixOS-boot\grubx64.efi'
sudo nixos-rebuild switch --impure --flake ~/.flake/#vallium



### bootstrap TODO

mount /mnt and /mnt/boot acordingly then proceed with nixos-install