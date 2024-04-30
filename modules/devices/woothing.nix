{ lib, config, pkgs, pkgs-unstable, vars, ... }:
with lib;
{
  options = {
    woothing = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.woothing.enable) {
    
};}