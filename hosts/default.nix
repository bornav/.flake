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

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
    vallium = lib.nixosSystem { 
        inherit system; 
        specialArgs = {
            inherit system unstable hyprland vars;
            host = {
                hostName = "vallium";
                # mainMonitor = "eDP-1";
                # secondMonitor = "";
            };
        };
        modules = [ 
          nur.nixosModules.nur
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ];
        # home-manager.nixosModules.home-manager {
        # 	home-manager.useGlobalPkgs = true;
        # 	home-manager.useUserPackages = true;
        # };
        
    };
#     desktop = lib.nixosSystem {                               # DEPRECATED Desktop Profile 
#     inherit system;
#     specialArgs = {
#       inherit inputs system unstable hyprland vars;
#       host = {
#         hostName = "desktop";
#         mainMonitor = "HDMI-A-1";
#         secondMonitor = "HDMI-A-2";
#       };
#     };
#     modules = [
#       nur.nixosModules.nur
#       ./desktop
#       ./configuration.nix

#       home-manager.nixosModules.home-manager {
#         home-manager.useGlobalPkgs = true;
#         home-manager.useUserPackages = true;
#       }
#     ];
#   };
}