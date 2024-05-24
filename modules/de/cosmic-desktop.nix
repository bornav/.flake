{ config, lib, vars, ... }:

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
    cosmic-desktop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.cosmic-desktop.enable) {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
  #   environment = {
  #     systemPackages = with pkgs-unstable; [
  #       cosmic-applets
  #       cosmic-applibrary
  #       cosmic-bg
  #       cosmic-comp
  #       cosmic-icons
  #       cosmic-launcher
  #       cosmic-notifications
  #       cosmic-osd
  #       cosmic-panel
  #       cosmic-session
  #       cosmic-settings 
  #       cosmic-settings-daemon
  #       cosmic-workspaces-epoch 
  #       xdg-desktop-portal-cosmic
  #       cosmic-greeter
  #       cosmic-protocols
  #       cosmic-edit 
  #       cosmic-screenshot 
  #       cosmic-design-demo 
  #       cosmic-term
  #       cosmic-randr
  #       cosmic-files
  #       cosmic-store
  #     ];
  #   };
  };
}