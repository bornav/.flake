{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, hyprland, nixos-cosmic, vars, ... }:

let
  system = "x86_64-linux";                                  # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow Proprietary Software
  };

  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
    vallium = nixpkgs.lib.nixosSystem { 
        inherit system; 
        specialArgs = {
            inherit system pkgs-unstable hyprland vars;
            host = {
                hostName = "vallium";
            };
        };
        modules = [ 
          # nur.nixosModules.nur
          ./configuration.nix
          ./vallium
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          # {
          # nix.settings = {
          #     substituters = [ "https://cosmic.cachix.org/" ];
          #     trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          #   };
          # }
          nixos-cosmic.nixosModules.default
          ];        
    };
    stealth = nixpkgs.lib.nixosSystem { 
        inherit system; 
        specialArgs = {
            inherit system pkgs-unstable hyprland vars;
            host = {
                hostName = "stealth";
            };
        };
        modules = [ 
          # nur.nixosModules.nur
          ./configuration.nix
          ./stealth
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          nixos-cosmic.nixosModules.default
          ];
    };
}