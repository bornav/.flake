
`nix run github:nix-community/nixos-anywhere -- --flake /home/bocmo/.flake#zbook-max395 --vm-test`

### To deploy | wipes all disk data, on each call
`nix run github:nix-community/nixos-anywhere -- --flake /home/bocmo/.flake#zbook-max395 root@10.1.10.101` 
`nix run github:nix-community/nixos-anywhere -- --flake /home/bocmo/.flake#zbook-max395 root@zbook-max395.local -i ~/.ssh/id_local` 

git/kubernetes/fluxcd#oracle-km1-1 root@141.144.255.9

### rebuilds the flake with the new configuration
`nixos-rebuild switch --flake ~/.flake#zbook-max395 --target-host zbook-max395` 