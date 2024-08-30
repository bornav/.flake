
`nix run github:nix-community/nixos-anywhere -- --flake /home/bocmo/.flake#stealth --vm-test`

### To deploy | wipes all disk data, on each call
`nix run github:nix-community/nixos-anywhere -- --flake /home/bocmo/.flake#stealth root@10.0.0.151` 

### rebuilds the flake with the new configuration
`nixos-rebuild switch --flake ~/.flake#stealth --target-host stealth` 