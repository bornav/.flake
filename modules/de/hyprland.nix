{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
    };
in

# {
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

#     nixos-cosmic = {
#       url = "github:lilyinstarlight/nixos-cosmic";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#   };

#   outputs = { self, nixpkgs, nixos-cosmic }: {
#     nixosConfigurations = {
#       # NOTE: change "host" to your system's hostname
#       host = nixpkgs.lib.nixosSystem {
#         modules = [
#           {
#             nix.settings = {
#               substituters = [ "https://cosmic.cachix.org/" ];
#               trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
#             };
#           }
#           nixos-cosmic.nixosModules.default
#           ./configuration.nix
#         ];
#       };
#     };
#   };
# }

with lib;
{
  options = {
    hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.hyprland.enable) {
    programs.hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };
  };
}