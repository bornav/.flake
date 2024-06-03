## in prog how was deployed

nix run github:nix-community/nixos-anywhere -- --flake /home/bocmo/.flake#k3s-local --vm-test # to rest before deploymend
some weird fuckerry happened in the grub part of the configuration making it not work, problem with not mounting the volumed since it did not exist

nix run github:nix-community/nixos-anywhere -- --flake /home/bocmo/.flake#k3s-local root@10.2.11.24 #had to use password based auth since on nix first reboot(into installer) it would no longer work, constantly ask for password

nixos-rebuild switch --flake ~/.flake#k3s-local --target-host k3s-local #how i updated the config on the remote system
aditional note, on update, seems local ip addres always switches
