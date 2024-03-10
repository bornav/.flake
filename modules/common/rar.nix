{ config, lib, pkgs, pkgs-unstable, vars, ... }:

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