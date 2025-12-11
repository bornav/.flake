# hydra temp creds


su hydra
hydra-create-user admin --full-name 'admin' --email-address 'admin@admin' --password-prompt --role admin




### To deploy | wipes all disk data, on each call
`nix run github:nix-community/nixos-anywhere -- --flake /home/user/.flake#dockeropen root@10.2.11.33` #had to use password based auth since on nix first reboot(into installer) it would no longer work, constantly ask for password


### rebuilds the flake with the new configuration
`nixos-rebuild switch --flake ~/.flake#hydra-01 --target-host root@10.2.11.26` #how i updated the config on the remote system
aditional note, on update, seems local ip addres always switches
