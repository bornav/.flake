### Bootstrap commands

sudo su
nix-env -iA nixos.git
git clone <url> /mnt/<path>
nixos-install --flake .#<host>  || in my case username
reboot

## after first login 
sudo rm -r /etc/nixos/configuration.nix
/ move build to desired location
