{ lib, config, pkgs, pkgs-unstable, vars, ... }:
with lib;
{
  options = {
    steam = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.steam.enable) {
    
  };
}