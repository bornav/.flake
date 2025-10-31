## in prog how was deployed

### Test before deployment
`nix run github:nix-community/nixos-anywhere -- --flake /home/user/.flake#networktest --vm-test` # to test before deploymend
some weird fuckerry happened in the grub part of the configuration making it not work, problem with not mounting the volumed since it did not exist

### To deploy | wipes all disk data, on each call
`nix run github:nix-community/nixos-anywhere -- --flake /home/user/.flake#networktest root@10.2.11.39` #had to use password based auth since on nix first reboot(into installer) it would no longer work, constantly ask for password


### rebuilds the flake with the new configuration
`nixos-rebuild switch --flake ~/.flake#networktest --target-host networktest` #how i updated the config on the remote system
aditional note, on update, seems local ip addres always switches
