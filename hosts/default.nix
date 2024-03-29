#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./<host>.nix
#           └─ default.nix 
#

{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, nur, hyprland, plasma-manager, vars, ... }:

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

  lib = nixpkgs.lib;
in
{
    vallium = lib.nixosSystem { 
        inherit system; 
        specialArgs = {
            inherit system pkgs-unstable hyprland vars;
            host = {
                hostName = "vallium";
            };
        };
        modules = [ 
          nur.nixosModules.nur
          ./configuration.nix
          ./vallium
          # ./custom.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ];        
    };
    stealth = lib.nixosSystem { 
        inherit system; 
        specialArgs = {
            inherit system pkgs-unstable hyprland vars;
            host = {
                hostName = "stealth";
            };
        };
        modules = [ 
          nur.nixosModules.nur
          ./configuration.nix
          ./stealth
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ];
    };
}