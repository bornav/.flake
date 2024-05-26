{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in

with lib;
{
  options = {
    rar = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.rar.enable) {
    environment = {
      systemPackages = with pkgs; [
        zip               # Zip
        p7zip             # Zip Encryption
        unzip             # Zip Files
        unrar             # Rar Files
      ];
    };
  };
}